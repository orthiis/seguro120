<?php
/* ============================================================
   cobrador/dashboard.php — VERSIÓN CORREGIDA
   ============================================================ */
$paginaActualTitulo = 'Dashboard';
require_once __DIR__ . '/header_cobrador.php';

$cobradorId = (int)$_SESSION['cobrador_portal_id'];
$nombre     = $_SESSION['cobrador_portal_nombre'] ?? 'Cobrador';

// ── KPIs ──
$totalClientes = 0;
$totalPend     = 0;
$montoPend     = 0.0;
$totalVencidas = 0;
$msgNoLeidosDash = 0;

try {
    $s = $conn->prepare("
        SELECT COUNT(DISTINCT cl.id)
        FROM clientes cl
        JOIN contratos c ON c.cliente_id = cl.id AND c.cobrador_id = ? AND c.estado = 'activo'
        WHERE cl.estado = 'activo'
    ");
    $s->execute([$cobradorId]);
    $totalClientes = (int)$s->fetchColumn();
} catch (PDOException $e) { error_log('dash kpi1: '.$e->getMessage()); }

try {
    $s = $conn->prepare("
        SELECT COUNT(*) AS total, COALESCE(SUM(f.monto),0) AS monto
        FROM asignaciones_facturas af
        JOIN facturas f ON af.factura_id = f.id
        WHERE af.cobrador_id = ? AND af.estado = 'activa'
          AND f.estado IN ('pendiente','vencida','incompleta')
    ");
    $s->execute([$cobradorId]);
    $row = $s->fetch(PDO::FETCH_ASSOC);
    $totalPend = (int)($row['total'] ?? 0);
    $montoPend = (float)($row['monto'] ?? 0);
} catch (PDOException $e) { error_log('dash kpi2: '.$e->getMessage()); }

try {
    $s = $conn->prepare("
        SELECT COUNT(*) FROM asignaciones_facturas af
        JOIN facturas f ON af.factura_id = f.id
        WHERE af.cobrador_id = ? AND af.estado = 'activa' AND f.estado = 'vencida'
    ");
    $s->execute([$cobradorId]);
    $totalVencidas = (int)$s->fetchColumn();
} catch (PDOException $e) { error_log('dash kpi3: '.$e->getMessage()); }

try {
    $s = $conn->prepare("SELECT COUNT(*) FROM cobrador_mensajes WHERE cobrador_id = ? AND leido = 0");
    $s->execute([$cobradorId]);
    $msgNoLeidosDash = (int)$s->fetchColumn();
} catch (PDOException $e) { $msgNoLeidosDash = 0; }

// ── Cobros próximos ──
$cobrosHoy = [];
try {
    $diaHoy = (int)date('j');
    $s = $conn->prepare("
        SELECT cl.nombre, cl.apellidos,
               COALESCE(c.telefono1, cl.telefono1) AS telefono1,
               c.no_whatsapp,
               c.direccion,
               c.numero_contrato, c.dia_cobro,
               c.ubicacion_lat, c.ubicacion_lng, c.ubicacion_ref,
               f.id AS factura_id, f.numero_factura, f.monto, f.estado AS factura_estado
        FROM clientes cl
        JOIN contratos c  ON c.cliente_id  = cl.id AND c.estado = 'activo'
        JOIN facturas  f  ON f.contrato_id = c.id  AND f.estado IN ('pendiente','vencida','incompleta')
        JOIN asignaciones_facturas af ON af.factura_id = f.id AND af.cobrador_id = ? AND af.estado = 'activa'
        WHERE c.cobrador_id = ?
          AND c.dia_cobro BETWEEN ? AND ?
        ORDER BY c.dia_cobro ASC, cl.nombre ASC
        LIMIT 6
    ");
    $s->execute([$cobradorId, $cobradorId, $diaHoy, $diaHoy + 3]);
    $cobrosHoy = $s->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) { error_log('dash cobros: '.$e->getMessage()); }

// ── Facturas Asignadas (todas, sin importar estado) ──
$facturasAsignadas = [];
try {
    $s = $conn->prepare("
        SELECT
            f.id              AS factura_id,
            f.numero_factura,
            f.mes_factura,
            f.fecha_vencimiento,
            f.estado          AS factura_estado,
            f.monto,
            f.cuota,
            c.numero_contrato,
            c.dia_cobro,
            p.nombre          AS plan_nombre,
            cl.nombre,
            cl.apellidos,
            c.direccion,
            COALESCE(c.telefono1, cl.telefono1) AS telefono1,
            c.no_whatsapp,
            DATE(af.fecha_asignacion) AS fecha_grupo
        FROM asignaciones_facturas af
        JOIN facturas  f  ON af.factura_id  = f.id
        JOIN contratos c  ON f.contrato_id  = c.id
        JOIN planes    p  ON c.plan_id      = p.id
        JOIN clientes  cl ON c.cliente_id   = cl.id
        WHERE af.cobrador_id = ?
          AND af.estado      = 'activa'
          AND f.estado       IN ('pendiente', 'vencida', 'incompleta')
        ORDER BY af.fecha_asignacion DESC, cl.nombre ASC
    ");
    $s->execute([$cobradorId]);
    $facturasAsignadasRaw = $s->fetchAll(PDO::FETCH_ASSOC);
    // Agrupar por fecha de asignación al cobrador
    foreach ($facturasAsignadasRaw as $row) {
        $grupo = $row['fecha_grupo']; // DATE(af.fecha_asignacion)
        $facturasAsignadas[$grupo][] = $row;
    }
    // Ordenar grupos: más recientes primero
    krsort($facturasAsignadas);
} catch (PDOException $e) {
    error_log('dash facturas_asignadas: ' . $e->getMessage());
}

// Saludo según hora
$hora   = (int)date('H');
$saludo = $hora < 12 ? 'Buenos días' : ($hora < 19 ? 'Buenas tardes' : 'Buenas noches');
$meses  = [1=>'enero',2=>'febrero',3=>'marzo',4=>'abril',5=>'mayo',6=>'junio',
           7=>'julio',8=>'agosto',9=>'septiembre',10=>'octubre',11=>'noviembre',12=>'diciembre'];
$fechaHoy = date('j') . ' de ' . $meses[(int)date('n')] . ' de ' . date('Y');
$primerNombre = explode(' ', trim($nombre))[0];
?>
<?php
// Helper: badge de estado factura
function badgeEstadoCob(string $estado): string {
    $map = [
        'pendiente'  => ['color'=>'#92400e','bg'=>'#fef3c7','label'=>'Pendiente'],
        'vencida'    => ['color'=>'#991b1b','bg'=>'#fee2e2','label'=>'Vencida'],
        'incompleta' => ['color'=>'#7c3aed','bg'=>'#ede9fe','label'=>'Incompleta'],
        'pagada'     => ['color'=>'#065f46','bg'=>'#d1fae5','label'=>'Pagada'],
    ];
    $s = $map[$estado] ?? ['color'=>'#374151','bg'=>'#f3f4f6','label'=>ucfirst($estado)];
    return '<span style="font-size:10px;font-weight:700;padding:2px 7px;border-radius:10px;'
         . 'background:' . $s['bg'] . ';color:' . $s['color'] . ';">'
         . $s['label'] . '</span>';
}
?>

<div class="app-content">

  <!-- Saludo -->
  <div class="page-header">
    <div class="page-title"><?= $saludo ?>, <?= htmlspecialchars($primerNombre) ?> 👋</div>
    <div class="page-subtitle">
      <i class="fas fa-calendar-day" style="color:var(--accent);font-size:11px;margin-right:4px;"></i>
      <?= $fechaHoy ?>
    </div>
  </div>

  <!-- Alerta mensajes no leídos -->
  <?php if ($msgNoLeidosDash > 0): ?>
  <div class="alert alert-info">
    <i class="fas fa-envelope"></i>
    <span>
      Tienes <strong><?= $msgNoLeidosDash ?></strong>
      mensaje<?= $msgNoLeidosDash > 1 ? 's' : '' ?> sin leer de la oficina.
    </span>
    <a href="mensajes.php" class="btn btn-sm"
       style="margin-left:auto;background:var(--accent);color:#fff;min-height:28px;">
      <i class="fas fa-envelope-open"></i> Ver
    </a>
  </div>
  <?php endif; ?>

  <!-- KPI Cards -->
  <div class="kpi-grid fade-in delay-1">
    <!-- Mis Clientes -->
    <div class="kpi-card blue">
      <div class="kpi-label">Mis Clientes</div>
      <div class="kpi-top">
        <div>
          <div class="kpi-value"><?= number_format($totalClientes) ?></div>
          <div class="kpi-sub">Clientes asignados activos</div>
        </div>
        <div class="kpi-icon"><i class="fas fa-users"></i></div>
      </div>
      <div class="kpi-footer"><i class="fas fa-database"></i> Total activos</div>
    </div>
    <!-- Facturas Pendientes -->
    <div class="kpi-card amber">
      <div class="kpi-label">Facturas Pendientes</div>
      <div class="kpi-top">
        <div>
          <div class="kpi-value"><?= number_format($totalPend) ?></div>
          <div class="kpi-sub">Por cobrar asignadas</div>
        </div>
        <div class="kpi-icon"><i class="fas fa-file-invoice-dollar"></i></div>
      </div>
      <div class="kpi-footer"><i class="fas fa-clock"></i> Pendientes de cobro</div>
    </div>
    <!-- Monto Pendiente -->
    <div class="kpi-card green">
      <div class="kpi-label">Monto Pendiente (RD$)</div>
      <div class="kpi-top">
        <div>
          <div class="kpi-value sm">RD$<?= number_format($montoPend, 0, '.', ',') ?></div>
          <div class="kpi-sub">Total por cobrar</div>
        </div>
        <div class="kpi-icon"><i class="fas fa-dollar-sign"></i></div>
      </div>
      <div class="kpi-footer"><i class="fas fa-arrow-trend-up"></i> Monto total asignado</div>
    </div>
    <!-- Facturas Vencidas -->
    <div class="kpi-card red">
      <div class="kpi-label">Facturas Vencidas</div>
      <div class="kpi-top">
        <div>
          <div class="kpi-value"><?= number_format($totalVencidas) ?></div>
          <div class="kpi-sub">Requieren atención urgente</div>
        </div>
        <div class="kpi-icon"><i class="fas fa-exclamation-triangle"></i></div>
      </div>
      <div class="kpi-footer"><i class="fas fa-calendar-xmark"></i> Vencidas sin cobrar</div>
    </div>
  </div>

  <!-- Accesos rápidos -->
  <div class="section-title"><i class="fas fa-bolt"></i> Accesos Rápidos</div>
  <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin-bottom:20px;">
    <a href="clientes.php" class="btn btn-secondary"
       style="flex-direction:column;gap:4px;height:64px;font-size:11px;">
      <i class="fas fa-users" style="font-size:18px;color:var(--accent);"></i>Clientes
    </a>
    <a href="facturas.php" class="btn btn-secondary"
       style="flex-direction:column;gap:4px;height:64px;font-size:11px;">
      <i class="fas fa-file-invoice" style="font-size:18px;color:var(--orange);"></i>Facturas
    </a>
    <a href="facturas.php?vista=ruta" class="btn btn-secondary"
       style="flex-direction:column;gap:4px;height:64px;font-size:11px;">
      <i class="fas fa-route" style="font-size:18px;color:var(--success);"></i>Mi Ruta
    </a>
    <a href="mensajes.php" class="btn btn-secondary"
       style="flex-direction:column;gap:4px;height:64px;font-size:11px;position:relative;">
      <i class="fas fa-envelope" style="font-size:18px;color:var(--accent);"></i>
      Mensaje
      <?php if ($msgNoLeidosDash > 0): ?>
      <span style="position:absolute;top:6px;right:6px;background:var(--danger);
                   color:#fff;border-radius:50%;width:16px;height:16px;
                   font-size:9px;font-weight:700;display:flex;
                   align-items:center;justify-content:center;line-height:1;">
        <?= $msgNoLeidosDash > 9 ? '9+' : $msgNoLeidosDash ?>
      </span>
      <?php endif; ?>
    </a>
  </div>

  <!-- Cobros próximos -->
  <?php if (!empty($cobrosHoy)): ?>
  <div class="section-title">
    <i class="fas fa-calendar-check"></i> Cobros de Hoy / Próximos
  </div>
  <div class="card" style="margin-bottom:16px;">
    <div class="card-header">
      <div class="card-title">
        <i class="fas fa-clock"></i>
        Clientes con día de cobro próximo
      </div>
    </div>
    <?php foreach ($cobrosHoy as $c): ?>
    <div style="padding:12px 16px;border-bottom:1px solid var(--border);
                display:flex;align-items:center;gap:12px;">
      <div style="width:36px;height:36px;border-radius:50%;background:var(--warning-light);
                  color:var(--warning-text);display:flex;align-items:center;justify-content:center;
                  font-size:12px;font-weight:700;flex-shrink:0;">
        <?= strtoupper(substr($c['nombre'],0,1) . substr($c['apellidos'],0,1)) ?>
      </div>
      <div style="flex:1;min-width:0;">
        <div style="font-size:13px;font-weight:700;color:var(--gray-800);
                    white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
          <?= htmlspecialchars($c['nombre'] . ' ' . $c['apellidos']) ?>
        </div>
        <div style="font-size:11px;color:var(--text-muted);">
          <?= htmlspecialchars($c['numero_contrato']) ?>
          &bull; Día <?= (int)$c['dia_cobro'] ?>
          &bull; <strong>RD$<?= number_format((float)$c['monto'], 2) ?></strong>
        </div>
        <?php if (!empty($c['ubicacion_lat']) && !empty($c['ubicacion_lng'])): ?>
        <div style="margin-top:4px;">
          <a href="https://www.google.com/maps?q=<?= htmlspecialchars($c['ubicacion_lat']) ?>,<?= htmlspecialchars($c['ubicacion_lng']) ?>"
             target="_blank"
             style="font-size:11px;color:var(--accent);text-decoration:none;
                    display:inline-flex;align-items:center;gap:4px;margin-right:8px;">
            <i class="fas fa-map-marker-alt"></i> Google Maps
          </a>
          <a href="https://waze.com/ul?ll=<?= htmlspecialchars($c['ubicacion_lat']) ?>,<?= htmlspecialchars($c['ubicacion_lng']) ?>&navigate=yes"
             target="_blank"
             style="font-size:11px;color:var(--accent);text-decoration:none;
                    display:inline-flex;align-items:center;gap:4px;">
            <i class="fas fa-route"></i> Waze
          </a>
        </div>
        <?php endif; ?>
      </div>
      <a href="facturas.php?factura_id=<?= (int)$c['factura_id'] ?>"
         class="btn btn-sm btn-primary">
        <i class="fas fa-file-invoice"></i>
      </a>
    </div>
    <?php endforeach; ?>
  </div>
  <?php endif; ?>

<!-- ════════════════════════════════════════
     BLOQUE: FACTURAS ASIGNADAS
════════════════════════════════════════ -->
<?php if (!empty($facturasAsignadas)):
    $totalFacturasAsignadas = array_sum(array_map('count', $facturasAsignadas));
    $labelContador = $totalFacturasAsignadas === 1
        ? '1 factura asignada'
        : $totalFacturasAsignadas . ' Facturas asignadas';
?>
<div class="section-title">
  <i class="fas fa-clipboard-list" style="color:var(--accent);"></i>
  Facturas Asignadas
  <span style="font-size:11px;font-weight:600;color:var(--white);
               background:var(--accent);padding:2px 9px;
               border-radius:20px;margin-left:6px;">
    <?= $labelContador ?>
  </span>
</div>
<?php
$hoy = date('Y-m-d');
$mesesEs = [
    '01'=>'Ene','02'=>'Feb','03'=>'Mar','04'=>'Abr',
    '05'=>'May','06'=>'Jun','07'=>'Jul','08'=>'Ago',
    '09'=>'Sep','10'=>'Oct','11'=>'Nov','12'=>'Dic'
];
foreach ($facturasAsignadas as $fechaGrupo => $facturas):
    $dt      = new DateTime($fechaGrupo);
    $esHoy   = ($fechaGrupo === $hoy);
    $diaNum  = $dt->format('d');
    $mesAbr  = $mesesEs[$dt->format('m')] ?? $dt->format('m');
    $anio    = $dt->format('Y');
    $labelFecha = $esHoy
        ? '🟢 Hoy — ' . $diaNum . ' ' . $mesAbr . ' ' . $anio
        : $diaNum . ' ' . $mesAbr . ' ' . $anio;
    $borderColor = $esHoy ? '2px solid #16a34a' : '1px solid var(--border)';
    $cardBg      = $esHoy ? '#f0fdf4' : 'var(--white)';
?>
<!-- Separador de fecha -->
<div style="display:flex;align-items:center;gap:8px;margin:12px 0 6px 0;">
  <span style="font-size:11px;font-weight:700;color:<?= $esHoy ? '#16a34a' : 'var(--text-muted)' ?>;
               background:<?= $esHoy ? '#dcfce7' : 'var(--gray-100)' ?>;
               padding:3px 10px;border-radius:20px;">
    <?= $labelFecha ?>
  </span>
  <span style="font-size:11px;color:var(--text-muted);">
    (<?= count($facturas) ?> factura<?= count($facturas) > 1 ? 's' : '' ?>)
  </span>
</div>
<?php foreach ($facturas as $fa):
    $fid       = (int)$fa['factura_id'];
    $nombreCl  = htmlspecialchars($fa['nombre'] . ' ' . $fa['apellidos']);
    $nContrato = htmlspecialchars($fa['numero_contrato']);
    $nFactura  = htmlspecialchars($fa['numero_factura']);
    $mes       = htmlspecialchars($fa['mes_factura']);
    $fVence    = date('d/m/Y', strtotime($fa['fecha_vencimiento']));
    $estado    = $fa['factura_estado'];
    $monto     = number_format((float)$fa['monto'], 2);
    $dir       = htmlspecialchars($fa['direccion'] ?? 'No registrada');
    $diaCobro  = (int)$fa['dia_cobro'];
    $cuota     = $fa['cuota'] ? 'N° ' . (int)$fa['cuota'] : '—';
    $plan      = htmlspecialchars($fa['plan_nombre'] ?? '—');
    /* WhatsApp: usar no_whatsapp; si está vacío, caer a telefono1 */
    $_waRaw    = trim($fa['no_whatsapp'] ?? '');
    $_tel1Raw  = trim($fa['telefono1'] ?? '');
    $telWa     = $_waRaw !== '' ? $_waRaw : $_tel1Raw;
    $tel       = preg_replace('/[^0-9+]/', '', $telWa);
    $telShow   = htmlspecialchars($telWa);
    $cardId    = 'fa-card-' . $fid;
    $bodyId    = 'fa-body-' . $fid;
    $msgWa     = urlencode('Hola ' . $fa['nombre'] . ' ' . $fa['apellidos']
                 . ', le contactamos respecto a su factura del mes ' . $fa['mes_factura'] . '.');
?>
<div id="<?= $cardId ?>"
     style="background:<?= $cardBg ?>;border:<?= $borderColor ?>;
            border-radius:var(--radius);margin-bottom:8px;overflow:hidden;
            box-shadow:0 1px 3px rgba(0,0,0,.06);">
  <!-- Header clickeable (colapsa/expande) -->
  <div onclick="toggleFaCard('<?= $bodyId ?>')"
       style="padding:11px 13px;cursor:pointer;display:flex;
              align-items:stretch;gap:10px;">
    <!-- Columna izquierda: datos básicos -->
    <div style="flex:1;min-width:0;">
      <!-- Línea 1: Nº Factura + Estatus -->
      <div style="display:flex;align-items:center;gap:6px;margin-bottom:3px;flex-wrap:wrap;">
        <span style="font-size:11px;font-weight:700;color:var(--text-muted);
                     font-family:monospace;"><?= $nFactura ?></span>
        <?= badgeEstadoCob($estado) ?>
      </div>
      <!-- Línea 2: Nombre cliente -->
      <div style="font-size:13px;font-weight:700;color:var(--gray-800);
                  white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
        <?= $nombreCl ?>
      </div>
      <!-- Línea 3: Contrato + Mes + Vencimiento -->
      <div style="font-size:11px;color:var(--text-muted);margin-top:2px;line-height:1.6;">
        <i class="fas fa-file-contract" style="width:12px;"></i>
        <?= $nContrato ?>
        &bull;
        <i class="fas fa-calendar" style="width:12px;"></i>
        <?= $mes ?>
        &bull;
        <i class="fas fa-clock" style="width:12px;"></i>
        Vence: <strong><?= $fVence ?></strong>
      </div>
    </div>
    <!-- Columna derecha: monto arriba, chevron abajo — posición siempre fija -->
    <div style="flex-shrink:0;display:flex;flex-direction:column;
                align-items:flex-end;justify-content:space-between;">
      <div style="font-size:14px;font-weight:700;color:var(--gray-800);">
        RD$<?= $monto ?>
      </div>
      <i class="fas fa-chevron-down fa-card-chevron"
         style="font-size:10px;color:var(--text-muted);
                transition:transform .2s;"></i>
    </div>
  </div>
  <!-- Body (oculto por defecto, se expande al clic) -->
  <div id="<?= $bodyId ?>" style="display:none;
       border-top:1px solid var(--border);padding:10px 13px;">
    <!-- Dirección -->
    <div style="font-size:12px;color:var(--text-muted);margin-bottom:6px;">
      <i class="fas fa-map-marker-alt" style="width:14px;color:var(--accent);"></i>
      <?= $dir ?>
    </div>
    <!-- Día cobro / Cuota / Plan -->
    <div style="font-size:12px;color:var(--text-muted);margin-bottom:10px;line-height:1.8;">
      <i class="fas fa-calendar-day" style="width:14px;color:var(--accent);"></i>
      Día cobro: <strong><?= $diaCobro ?></strong>
      &bull; Cuota: <strong><?= $cuota ?></strong>
      &bull; <i class="fas fa-umbrella" style="font-size:10px;"></i>
      <strong><?= $plan ?></strong>
    </div>
    <!-- Botones de acción -->
    <div style="display:flex;gap:8px;flex-wrap:wrap;">
      <!-- Ver (abre modal igual que en facturas.php) -->
      <button onclick="abrirDetalleFactura(<?= $fid ?>)"
              class="btn btn-primary btn-sm" style="flex:1;min-width:70px;">
        <i class="fas fa-eye"></i> Ver
      </button>
      <!-- Imprimir -->
      <a href="imprimir.php?factura_id=<?= $fid ?>"
         class="btn btn-secondary btn-sm" style="flex:1;min-width:80px;">
        <i class="fas fa-print"></i> Imprimir
      </a>
      <?php if ($tel): ?>
      <!-- Llamar -->
      <a href="tel:<?= $tel ?>"
         class="btn btn-success btn-sm"
         title="Llamar a <?= $telShow ?>">
        <i class="fas fa-phone"></i>
      </a>
      <!-- WhatsApp -->
      <a href="https://wa.me/1<?= $tel ?>?text=<?= $msgWa ?>"
         target="_blank" rel="noopener noreferrer"
         class="btn btn-sm"
         style="background:#16a34a;color:#fff;"
         title="WhatsApp">
        <i class="fab fa-whatsapp"></i>
      </a>
      <?php endif; ?>
    </div>
  </div>
</div>
<?php endforeach; ?>
<?php endforeach; ?>
<?php endif; ?>

  <!-- Estado vacío si no hay nada -->
  <?php if ($totalClientes === 0 && $totalPend === 0): ?>
  <div class="empty-state">
    <i class="fas fa-check-circle" style="color:var(--success);opacity:1;"></i>
    <h3>Todo al día</h3>
    <p>No tienes clientes o facturas asignadas en este momento.<br>
       Contacta a la oficina si crees que hay un error.</p>
  </div>
  <?php endif; ?>

</div><!-- /.app-content -->

<!-- ════════════════════════════════════════
     MODAL DETALLE FACTURA (Dashboard)
════════════════════════════════════════ -->
<div id="modalFactura"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.52);
            z-index:2000;overflow-y:auto;padding:20px;">
  <div style="display:flex;align-items:flex-start;
              justify-content:center;min-height:100%;">
    <div id="modalFacturaBox"
         style="background:var(--white);border-radius:var(--radius-lg);
                width:100%;max-width:500px;overflow:hidden;
                box-shadow:var(--shadow-lg);margin-top:50px;margin-bottom:30px;">
      <div id="modalFacturaBody">
        <div class="loading-overlay"><div class="spinner"></div></div>
      </div>
    </div>
  </div>
</div>

<script>
/* ── Toggle Facturas Asignadas ── */
function toggleFaCard(bodyId) {
    var body    = document.getElementById(bodyId);
    var card    = body ? body.parentElement : null;
    var chevron = card ? card.querySelector('.fa-card-chevron') : null;
    if (!body) return;
    var abierto = body.style.display !== 'none';
    body.style.display = abierto ? 'none' : 'block';
    if (chevron) {
        chevron.style.transform = abierto ? '' : 'rotate(180deg)';
    }
}

/* ── Utilidades para el modal ── */
function esc(v) {
    return String(v == null ? '' : v)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;')
        .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
function fmtMonto(v) {
    return parseFloat(v || 0).toLocaleString('es-DO', {
        minimumFractionDigits: 2, maximumFractionDigits: 2
    });
}
function fmtFecha(f) {
    if (!f) return '—';
    var d = new Date(String(f).replace(' ', 'T'));
    if (isNaN(d.getTime())) return String(f);
    return ('0' + d.getDate()).slice(-2) + '/' +
           ('0' + (d.getMonth() + 1)).slice(-2) + '/' +
           d.getFullYear();
}

/* ── Modal Detalle Factura ── */
function abrirDetalleFactura(facturaId) {
    var modal = document.getElementById('modalFactura');
    var body  = document.getElementById('modalFacturaBody');

    body.innerHTML =
        '<div class="loading-overlay" style="padding:48px;">' +
        '<div class="spinner"></div></div>';

    modal.style.display = 'block';
    document.body.style.overflow = 'hidden';

    fetch('api/get_factura_det.php?id=' + facturaId, { credentials: 'same-origin' })
        .then(function(r) { return r.text(); })
        .then(function(txt) {
            var data;
            try { data = JSON.parse(txt); }
            catch (e) {
                body.innerHTML =
                    '<div style="padding:20px;color:var(--danger);">' +
                    'Error al leer la respuesta del servidor.</div>';
                return;
            }
            if (!data.success) {
                body.innerHTML =
                    '<div style="padding:20px;color:var(--danger);">' +
                    esc(data.message || 'Error desconocido') + '</div>';
                return;
            }

            var f     = data.factura;
            var pagos = data.pagos || [];
            var pend  = parseFloat(f.monto_pendiente || 0);
            var total = parseFloat(f.monto || 0);
            var pct   = total > 0 ? Math.round((total - pend) / total * 100) : 0;

            function fila(label, valor) {
                return '<div style="display:flex;justify-content:space-between;' +
                       'align-items:flex-start;padding:8px 0;' +
                       'border-bottom:1px solid var(--gray-100);font-size:13px;">' +
                       '<span style="color:var(--text-muted);flex-shrink:0;margin-right:10px;">' +
                       label + '</span>' +
                       '<span style="font-weight:600;text-align:right;">' +
                       valor + '</span></div>';
            }

            var h = '';

            /* Cabecera */
            h += '<div style="padding:16px;border-bottom:1px solid var(--border);' +
                 'display:flex;align-items:flex-start;justify-content:space-between;gap:8px;">' +
                 '<div>' +
                 '<div style="font-size:15px;font-weight:700;color:var(--gray-800);">' +
                 esc(f.numero_factura) + '</div>' +
                 '<div style="font-size:12px;color:var(--text-muted);margin-top:2px;">' +
                 esc(((f.nombre || '') + ' ' + (f.apellidos || '')).trim()) +
                 '</div></div>' +
                 '<button onclick="cerrarModal()" class="btn btn-secondary btn-sm"' +
                 ' style="flex-shrink:0;"><i class="fas fa-times"></i></button>' +
                 '</div>';

            /* Tarjetas de monto */
            h += '<div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;padding:14px;">';
            h += '<div style="background:var(--gray-50);padding:12px;border-radius:var(--radius-sm);text-align:center;">' +
                 '<div style="font-size:10px;color:var(--text-muted);text-transform:uppercase;' +
                 'letter-spacing:.5px;margin-bottom:4px;">Total Factura</div>' +
                 '<div style="font-size:18px;font-weight:700;color:var(--gray-900);">' +
                 'RD$' + fmtMonto(f.monto) + '</div></div>';
            h += '<div style="background:var(--warning-light);padding:12px;border-radius:var(--radius-sm);text-align:center;">' +
                 '<div style="font-size:10px;color:var(--warning-text);text-transform:uppercase;' +
                 'letter-spacing:.5px;margin-bottom:4px;">Pendiente</div>' +
                 '<div style="font-size:18px;font-weight:700;color:var(--warning-text);">' +
                 'RD$' + fmtMonto(pend) + '</div></div>';
            h += '</div>';

            /* Barra de progreso */
            if (pct > 0 && pct < 100) {
                h += '<div style="padding:0 14px 12px;">' +
                     '<div style="display:flex;justify-content:space-between;' +
                     'font-size:11px;color:var(--text-muted);margin-bottom:5px;">' +
                     '<span>Pagado: ' + pct + '%</span>' +
                     '<span>Pendiente: ' + (100 - pct) + '%</span></div>' +
                     '<div style="height:7px;background:var(--gray-200);border-radius:4px;">' +
                     '<div style="height:7px;border-radius:4px;background:var(--success);' +
                     'width:' + pct + '%;transition:width .4s ease;"></div></div></div>';
            }

            /* Detalles */
            h += '<div style="padding:0 14px 4px;">';
            h += fila('Contrato',     esc(f.numero_contrato || '—'));
            h += fila('Mes',          esc(f.mes_factura     || '—'));
            h += fila('Plan',         esc(f.plan_nombre     || '—'));
            if (f.cuota) h += fila('Cuota', 'N° ' + esc(f.cuota));
            h += fila('Vencimiento',  fmtFecha(f.fecha_vencimiento));
            h += fila('Día de cobro', esc(f.dia_cobro || '—'));
            if (f.direccion) {
                h += fila('Dirección',
                    '<span style="max-width:220px;word-break:break-word;display:block;' +
                    'text-align:right;">' + esc(f.direccion) + '</span>');
            }
            if (f.telefono1) {
                var t1 = String(f.telefono1).replace(/\D/g, '');
                h += '<div style="display:flex;justify-content:space-between;' +
                     'align-items:center;padding:8px 0;' +
                     'border-bottom:1px solid var(--gray-100);font-size:13px;">' +
                     '<span style="color:var(--text-muted);">Teléfono</span>' +
                     '<a href="tel:' + esc(t1) + '" ' +
                     'style="font-weight:600;color:var(--accent);text-decoration:none;">' +
                     '<i class="fas fa-phone" style="font-size:10px;margin-right:3px;"></i>' +
                     esc(f.telefono1) + '</a></div>';
            }
            h += '</div>';

            /* Historial de abonos */
            if (pagos.length > 0) {
                h += '<div style="padding:12px 14px;">' +
                     '<div style="font-size:11px;font-weight:700;color:var(--gray-500);' +
                     'text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px;">' +
                     '<i class="fas fa-coins" style="color:var(--accent);margin-right:5px;"></i>' +
                     'Historial de abonos</div>';
                pagos.forEach(function(p) {
                    h += '<div style="display:flex;justify-content:space-between;' +
                         'padding:6px 0;border-bottom:1px solid var(--gray-100);font-size:12px;">' +
                         '<span style="color:var(--text-muted);">' +
                         fmtFecha(p.fecha_pago) +
                         (p.metodo_pago ? ' · ' + esc(p.metodo_pago) : '') +
                         '</span>' +
                         '<span style="font-weight:700;color:var(--success);">' +
                         'RD$' + fmtMonto(p.monto) + '</span></div>';
                });
                h += '</div>';
            }

            /* Botones del modal */
            h += '<div style="padding:12px 14px;border-top:1px solid var(--border);' +
                 'display:flex;gap:8px;flex-wrap:wrap;">';
            h += '<a href="imprimir.php?factura_id=' + f.id +
                 '" target="_blank" rel="noopener" ' +
                 'class="btn btn-primary" style="flex:1;min-width:130px;">' +
                 '<i class="fas fa-print"></i> Imprimir Recibo</a>';
            var _waRaw = (f.no_whatsapp && String(f.no_whatsapp).trim())
                         ? String(f.no_whatsapp).trim()
                         : (f.telefono1 ? String(f.telefono1).trim() : '');
            if (_waRaw) {
                var t1wa  = _waRaw.replace(/\D/g, '');
                var nomCl = ((f.nombre || '') + ' ' + (f.apellidos || '')).trim();
                var msgW  = 'Hola ' + nomCl + ', le contactamos respecto ' +
                            'a su factura del mes ' + (f.mes_factura || '') + '.';
                h += '<a href="https://wa.me/1' + esc(t1wa) +
                     '?text=' + encodeURIComponent(msgW) +
                     '" target="_blank" rel="noopener" class="btn btn-sm" ' +
                     'style="background:#16a34a;color:#fff;flex-shrink:0;padding:0 14px;">' +
                     '<i class="fab fa-whatsapp"></i></a>';
            }
            h += '</div>';

            body.innerHTML = h;
        })
        .catch(function(err) {
            body.innerHTML =
                '<div style="padding:20px;color:var(--danger);">' +
                'Error de conexión. Intenta de nuevo.</div>';
            console.error('abrirDetalleFactura dash error:', err);
        });
}

function cerrarModal() {
    document.getElementById('modalFactura').style.display = 'none';
    document.body.style.overflow = '';
}

/* Cerrar al clic en el fondo oscuro */
document.getElementById('modalFactura').addEventListener('click', function(e) {
    if (e.target === this) cerrarModal();
});

/* Cerrar con Escape */
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') cerrarModal();
});
</script>
</body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        