<?php
/* ============================================================
   cobrador/config_cobrador.php — VERSIÓN FINAL CORREGIDA
   
   REGLA CRÍTICA: config.php del sistema ya llama session_start().
   Esta versión NO lo llama antes. Solo lo requiere y luego
   verifica que la sesión esté activa.
   ============================================================ */

// Capturar cualquier output inesperado (warnings de config.php)
// para que no corrompan el HTML
if (!ob_get_level()) {
    ob_start();
}

// Incluir config.php del sistema principal PRIMERO
// Él se encarga de session_start() y la conexión $conn
if (!defined('DB_HOST')) {
    require_once __DIR__ . '/../config.php';
}

// Descartar cualquier warning que config.php haya podido generar
// (solo si no hay contenido útil en el buffer)
$bufferActual = ob_get_contents();
if ($bufferActual && str_contains($bufferActual, 'Warning')) {
    ob_clean();
}

// Verificar que la sesión está activa (config.php la inicia)
// Si por alguna razón no lo está, iniciarla de forma segura
if (session_status() !== PHP_SESSION_ACTIVE) {
    @session_start();
}

// Token CSRF exclusivo del portal cobrador
if (empty($_SESSION['csrf_token_cobrador'])) {
    $_SESSION['csrf_token_cobrador'] = bin2hex(random_bytes(32));
}

/* ============================================================
   resolverCobradorPorSesion()
   Cuando el cobrador llega desde el login principal (login.php),
   la sesión tiene usuario_id y rol='cobrador' pero NO tiene
   cobrador_portal_id (que es el ID en tabla cobradores).
   Esta función busca el registro en cobradores y puebla la sesión.
   ============================================================ */
function resolverCobradorPorSesion(): bool
{
    global $conn;

    // Si ya está resuelto, no hacer nada
    if (!empty($_SESSION['cobrador_portal_id'])) {
        return true;
    }

    // Necesitamos usuario_id para buscar
    $usuarioId     = (int)($_SESSION['cobrador_portal_uid'] ?? $_SESSION['usuario_id'] ?? 0);
    $usuarioNombre = $_SESSION['cobrador_portal_nombre'] ?? $_SESSION['usuario_nombre'] ?? '';

    if (!$usuarioId && !$usuarioNombre) {
        return false;
    }

    // Obtener datos completos del usuario desde BD
    $user = [];
    try {
        $s = $conn->prepare("SELECT id, usuario, nombre FROM usuarios WHERE id = ? LIMIT 1");
        $s->execute([$usuarioId]);
        $user = $s->fetch(PDO::FETCH_ASSOC) ?: [];
    } catch (PDOException $e) {
        error_log('resolverCobradorPorSesion usuario: ' . $e->getMessage());
    }

    if (empty($user)) {
        return false;
    }

    $cobrador = null;

    // ESTRATEGIA 1: Buscar por usuario_id (si la columna existe)
    try {
        $cols = $conn->query("SHOW COLUMNS FROM `cobradores` LIKE 'usuario_id'")->fetch();
        if ($cols) {
            $s = $conn->prepare("SELECT id, nombre_completo, codigo FROM cobradores WHERE usuario_id = ? AND estado = 'activo' LIMIT 1");
            $s->execute([$user['id']]);
            $cobrador = $s->fetch(PDO::FETCH_ASSOC) ?: null;
        }
    } catch (PDOException $e) { error_log('resolverCobrador E1: ' . $e->getMessage()); }

    // ESTRATEGIA 2: Buscar por nombre_completo exacto
    if (!$cobrador && !empty($user['nombre'])) {
        try {
            $s = $conn->prepare("SELECT id, nombre_completo, codigo FROM cobradores WHERE LOWER(TRIM(nombre_completo)) = LOWER(TRIM(?)) AND estado = 'activo' LIMIT 1");
            $s->execute([$user['nombre']]);
            $cobrador = $s->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) { error_log('resolverCobrador E2: ' . $e->getMessage()); }
    }

    // ESTRATEGIA 3: Buscar por primer nombre parcial
    if (!$cobrador && !empty($user['nombre'])) {
        try {
            $primerNombre = explode(' ', trim($user['nombre']))[0];
            $s = $conn->prepare("SELECT id, nombre_completo, codigo FROM cobradores WHERE LOWER(nombre_completo) LIKE LOWER(?) AND estado = 'activo' LIMIT 1");
            $s->execute(['%' . $primerNombre . '%']);
            $cobrador = $s->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) { error_log('resolverCobrador E3: ' . $e->getMessage()); }
    }

    // ESTRATEGIA 4: Buscar por nombre de usuario
    if (!$cobrador && !empty($user['usuario'])) {
        try {
            $s = $conn->prepare("SELECT id, nombre_completo, codigo FROM cobradores WHERE LOWER(nombre_completo) LIKE LOWER(?) AND estado = 'activo' LIMIT 1");
            $s->execute(['%' . $user['usuario'] . '%']);
            $cobrador = $s->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) { error_log('resolverCobrador E4: ' . $e->getMessage()); }
    }

    // ESTRATEGIA 5: Si hay solo 1 cobrador activo, usarlo
    if (!$cobrador) {
        try {
            $total = (int)$conn->query("SELECT COUNT(*) FROM cobradores WHERE estado = 'activo'")->fetchColumn();
            if ($total === 1) {
                $cobrador = $conn->query("SELECT id, nombre_completo, codigo FROM cobradores WHERE estado = 'activo' LIMIT 1")->fetch(PDO::FETCH_ASSOC) ?: null;
            }
        } catch (PDOException $e) { error_log('resolverCobrador E5: ' . $e->getMessage()); }
    }

    if (!$cobrador || (int)$cobrador['id'] === 0) {
        error_log('resolverCobradorPorSesion: no se encontró cobrador para usuario_id=' . $usuarioId);
        return false;
    }

    // Poblar las variables de sesión del portal cobrador
    $_SESSION['cobrador_portal_id']     = (int)$cobrador['id'];
    $_SESSION['cobrador_portal_nombre'] = $cobrador['nombre_completo'];
    $_SESSION['cobrador_portal_codigo'] = $cobrador['codigo'] ?? 'N/A';
    $_SESSION['cobrador_portal_rol']    = 'cobrador';
    $_SESSION['cobrador_portal_uid']    = (int)$user['id'];

    if (empty($_SESSION['csrf_token_cobrador'])) {
        $_SESSION['csrf_token_cobrador'] = bin2hex(random_bytes(32));
    }

    return true;
}

/* ============================================================
   verificarSesionCobrador()
   Verifica sesión activa de cobrador. Acepta tanto sesión del
   portal propio como sesión generada por el login principal.
   Si no hay sesión válida, redirige al login del portal.
   ============================================================ */
function verificarSesionCobrador(): void
{
    // ¿Sesión del portal cobrador propio? (login en cobrador/index.php)
    $porPortal = (
        !empty($_SESSION['cobrador_portal_id']) &&
        !empty($_SESSION['cobrador_portal_rol']) &&
        $_SESSION['cobrador_portal_rol'] === 'cobrador'
    );

    // ¿Sesión del login principal con rol cobrador? (login en login.php raíz)
    $porLoginPrincipal = (
        !empty($_SESSION['usuario_id']) &&
        ($_SESSION['rol'] ?? '') === 'cobrador'
    );

    if (!$porPortal && !$porLoginPrincipal) {
        // No hay sesión válida — guardar URL y redirigir al login
        if (
            !isset($_SESSION['cobrador_redirect_after_login']) &&
            !str_contains($_SERVER['REQUEST_URI'] ?? '', 'index.php')
        ) {
            $_SESSION['cobrador_redirect_after_login'] = $_SERVER['REQUEST_URI'];
        }
        header('Location: index.php');
        exit();
    }

    // Si llegó por login principal y faltan datos del portal, resolverlos
    if ($porLoginPrincipal && empty($_SESSION['cobrador_portal_id'])) {
        if (!resolverCobradorPorSesion()) {
            // No se pudo vincular al cobrador — enviar a login para que lo haga manualmente
            header('Location: index.php?error=sin_perfil_cobrador');
            exit();
        }
    }

    // Actualizar actividad
    $_SESSION['ultima_actividad'] = time();
}

/* ============================================================
   verificarSesionCobradorAjax()
   Para endpoints API — responde JSON en lugar de redirigir
   ============================================================ */
function verificarSesionCobradorAjax(): void
{
    $porPortal = (
        !empty($_SESSION['cobrador_portal_id']) &&
        ($_SESSION['cobrador_portal_rol'] ?? '') === 'cobrador'
    );
    $porLoginPrincipal = (
        !empty($_SESSION['usuario_id']) &&
        ($_SESSION['rol'] ?? '') === 'cobrador'
    );

    if (!$porPortal && !$porLoginPrincipal) {
        if (ob_get_level()) ob_clean();
        header('Content-Type: application/json; charset=utf-8');
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Sesión expirada. Por favor inicia sesión nuevamente.']);
        exit();
    }

    // Si llegó por login principal, resolver cobrador_portal_id si falta
    if ($porLoginPrincipal && empty($_SESSION['cobrador_portal_id'])) {
        resolverCobradorPorSesion();
    }
}

/* ============================================================
   getCobradorActual()
   Retorna datos del cobrador autenticado desde la BD
   ============================================================ */
function getCobradorActual(): array
{
    global $conn;
    $id = (int)($_SESSION['cobrador_portal_id'] ?? 0);
    if (!$id) return [];
    try {
        $stmt = $conn->prepare("SELECT * FROM cobradores WHERE id = ? AND estado = 'activo' LIMIT 1");
        $stmt->execute([$id]);
        return $stmt->fetch(PDO::FETCH_ASSOC) ?: [];
    } catch (PDOException $e) {
        error_log('getCobradorActual: ' . $e->getMessage());
        return [];
    }
}

/* ============================================================
   getMensajesNoLeidos()
   Retorna cantidad de mensajes sin leer. Seguro si tabla no existe.
   ============================================================ */
function getMensajesNoLeidos(): int
{
    global $conn;
    $id = (int)($_SESSION['cobrador_portal_id'] ?? 0);
    if (!$id) return 0;
    try {
        $stmt = $conn->prepare("
            SELECT COUNT(*) FROM cobrador_mensajes
            WHERE cobrador_id = ? AND leido = 0
        ");
        $stmt->execute([$id]);
        return (int)$stmt->fetchColumn();
    } catch (PDOException $e) {
        return 0;
    }
}

/* ============================================================
   FUNCIÓN: verificarAccesoFactura
   El cobrador puede acceder a facturas de 3 formas:
   1. La factura pertenece a un cliente asignado a él (cl.cobrador_id)
   2. La factura está en asignaciones_facturas para él
   3. La factura está en cobrador_facturas_autorizadas para él
   ============================================================ */
function verificarAccesoFactura(int $facturaId, int $cobradorId): bool
{
    global $conn;

    try {
        // ── VERIFICACIÓN PRINCIPAL: ¿El contrato de la factura tiene asignado este cobrador? ──
        $stmt = $conn->prepare("
            SELECT COUNT(*)
            FROM facturas f
            JOIN contratos c ON f.contrato_id = c.id
            WHERE f.id         = ?
              AND c.cobrador_id = ?
        ");
        $stmt->execute([$facturaId, $cobradorId]);
        if ((int)$stmt->fetchColumn() > 0) return true;

        // ── VERIFICACIÓN 2: ¿Está en asignaciones_facturas para este cobrador? ──
        $stmt = $conn->prepare("
            SELECT COUNT(*)
            FROM asignaciones_facturas
            WHERE factura_id  = ?
              AND cobrador_id = ?
              AND estado      = 'activa'
        ");
        $stmt->execute([$facturaId, $cobradorId]);
        if ((int)$stmt->fetchColumn() > 0) return true;

        // ── VERIFICACIÓN 3: ¿Tiene autorización especial? ──
        $stmt = $conn->prepare("
            SELECT COUNT(*)
            FROM cobrador_facturas_autorizadas
            WHERE factura_id  = ?
              AND cobrador_id = ?
              AND estado      = 'activa'
              AND (fecha_expiracion IS NULL OR fecha_expiracion > NOW())
        ");
        $stmt->execute([$facturaId, $cobradorId]);
        if ((int)$stmt->fetchColumn() > 0) return true;

        return false;

    } catch (PDOException $e) {
        error_log('verificarAccesoFactura: ' . $e->getMessage());
        return false;
    }
}

/* ============================================================
   registrarLogCobrador()
   Registra accesos en el log. Silencioso si tabla no existe.
   ============================================================ */
function registrarLogCobrador(int $cobradorId, string $accion): void
{
    global $conn;
    try {
        $conn->prepare("
            INSERT INTO cobrador_sesiones_log (cobrador_id, ip_address, user_agent, accion)
            VALUES (?, ?, ?, ?)
        ")->execute([
            $cobradorId,
            $_SERVER['REMOTE_ADDR'] ?? null,
            substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 255),
            $accion,
        ]);
    } catch (PDOException $e) {
        error_log('registrarLogCobrador: ' . $e->getMessage());
    }
}