<?php
/* ============================================================
   cobrador/clientes.php — VERSIÓN CORREGIDA
   Muestra TODOS los clientes del cobrador (sin filtro de estado)
   ============================================================ */
$paginaActualTitulo = 'Mis Clientes';
require_once __DIR__ . '/header_cobrador.php';

$cobradorId = (int)$_SESSION['cobrador_portal_id'];

// Contar TODOS los clientes del cobrador (activos + inactivos + suspendidos)
// El cobrador necesita ver todos para gestionar cobros pendientes
$totalClientes = 0;
try {
    $s = $conn->prepare("
        SELECT COUNT(DISTINCT cl.id)
        FROM clientes cl
        JOIN contratos c ON c.cliente_id = cl.id AND c.cobrador_id = ? AND c.estado = 'activo'
    ");
    $s->execute([$cobradorId]);
    $totalClientes = (int)$s->fetchColumn();
} catch (PDOException $e) {
    error_log('clientes count: ' . $e->getMessage());
}
?>

<div class="app-content">

  <div class="page-header">
    <div class="page-title">Mis Clientes</div>
    <div class="page-subtitle" id="subtituloClientes">
      <?= number_format($totalClientes) ?> cliente(s) asignado(s)
    </div>
  </div>

  <!-- Barra de búsqueda sticky -->
  <div class="search-sticky">
    <div class="search-bar">
      <i class="fas fa-search"></i>
      <input type="text" id="searchInput"
             placeholder="Buscar por nombre, apellido o N° contrato..."
             autocomplete="off" autocorrect="off"
             autocapitalize="off" spellcheck="false">
      <div class="spinner" id="searchSpinner" style="display:none;"></div>
    </div>
    <div class="search-count" id="searchCount"></div>
  </div>

  <!-- Contenedor de tarjetas -->
  <div id="clientesContainer"></div>

  <!-- Estado vacío -->
  <div class="empty-state" id="emptyState" style="display:none;">
    <i class="fas fa-users"></i>
    <h3>Sin resultados</h3>
    <p>No se encontraron clientes con ese criterio de búsqueda.</p>
  </div>

  <!-- Botón cargar más -->
  <div id="btnCargarMasWrap" style="text-align:center;padding:16px 0;display:none;">
    <button class="btn btn-secondary" onclick="cargarMas()">
      <i class="fas fa-plus"></i> Cargar más clientes
    </button>
  </div>

</div><!-- /.app-content -->

<script>
/* ═══════════════════════════════════════════════════════════
   ESTADO GLOBAL
═══════════════════════════════════════════════════════════ */
var currentOffset = 0;
var currentQuery  = '';
var isLoading     = false;
var hayMas        = false;
var POR_PAGINA    = 20;
var totalGlobal   = 0;

/* ═══════════════════════════════════════════════════════════
   UTILIDADES
═══════════════════════════════════════════════════════════ */
function esc(str) {
    if (str === null || str === undefined) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function el(tag, props, children) {
    var elem = document.createElement(tag);
    if (props) {
        Object.keys(props).forEach(function(k) {
            if (k === 'style') {
                elem.style.cssText = props[k];
            } else if (k === 'class') {
                elem.className = props[k];
            } else if (k === 'html') {
                elem.innerHTML = props[k];
            } else if (k === 'text') {
                elem.textContent = props[k];
            } else {
                elem.setAttribute(k, props[k]);
            }
        });
    }
    if (children) {
        (Array.isArray(children) ? children : [children]).forEach(function(c) {
            if (c) elem.appendChild(typeof c === 'string' ? document.createTextNode(c) : c);
        });
    }
    return elem;
}

/* ═══════════════════════════════════════════════════════════
   CREAR TARJETA DE CLIENTE
═══════════════════════════════════════════════════════════ */
function crearTarjetaCliente(cl) {
    var nombre    = ((cl.nombre || '') + ' ' + (cl.apellidos || '')).trim();
    var iniciales = '';
    if (cl.nombre    && cl.nombre.length)    iniciales += cl.nombre[0].toUpperCase();
    if (cl.apellidos && cl.apellidos.length) iniciales += cl.apellidos[0].toUpperCase();

    var tels = [cl.telefono1, cl.no_whatsapp || cl.telefono2]
        .map(function(t) { return (t || '').trim(); })
        .filter(function(t) { return t.length > 0; });

    var contratos   = Array.isArray(cl.contratos)   ? cl.contratos   : [];
    var referencias = Array.isArray(cl.referencias) ? cl.referencias : [];
    var estaActivo  = !cl.estado || cl.estado === 'activo';

    /* ── CARD ── */
    var card = el('div', { class: 'client-card' });

    /* ── HEADER ── */
    var header = el('div', {
        class: 'client-card-header',
        style: 'cursor:pointer;'
    });

    /* Avatar */
    var avatar = el('div', {
        class: 'client-avatar',
        style: estaActivo
            ? ''
            : 'background:var(--gray-200);color:var(--gray-500);'
    });
    avatar.textContent = iniciales || '?';
    header.appendChild(avatar);

    /* Info */
    var info = el('div', { style: 'flex:1;min-width:0;' });

    var nameEl = el('div', { class: 'client-name' });
    nameEl.textContent = nombre;

    /* Badge estado inactivo */
    if (!estaActivo) {
        var badgeEstado = el('span', {
            style: 'font-size:10px;background:var(--gray-200);color:var(--gray-600);' +
                   'padding:1px 6px;border-radius:8px;margin-left:6px;'
        });
        badgeEstado.textContent = cl.estado || 'inactivo';
        nameEl.appendChild(badgeEstado);
    }
    info.appendChild(nameEl);

    /* Contratos como chips */
    if (contratos.length > 0) {
        var metaDiv = el('div', { class: 'client-meta' });
        contratos.forEach(function(c) {
            var chip = el('span', {
                class: 'client-meta-item',
                style: 'background:var(--accent-light);color:var(--accent-text);' +
                       'padding:2px 8px;border-radius:10px;font-size:11px;'
            });
            chip.innerHTML = '<i class="fas fa-file-contract" style="font-size:9px;margin-right:3px;"></i>';
            chip.appendChild(document.createTextNode(c.numero_contrato || ''));
            metaDiv.appendChild(chip);
        });

        if (contratos[0] && contratos[0].dia_cobro) {
            var diaChip = el('span', {
                class: 'client-meta-item',
                style: 'font-size:11px;color:var(--text-muted);'
            });
            diaChip.innerHTML = '<i class="fas fa-calendar-day" style="margin-right:2px;"></i> Día ' + contratos[0].dia_cobro;
            metaDiv.appendChild(diaChip);
        }
        info.appendChild(metaDiv);
    }

    header.appendChild(info);

    /* Chevron */
    var chevron = el('i', {
        class: 'fas fa-chevron-down',
        style: 'color:var(--gray-400);font-size:12px;transition:transform .25s;' +
               'flex-shrink:0;margin-left:8px;'
    });
    header.appendChild(chevron);

    /* Toggle expandir/colapsar */
    header.addEventListener('click', function() {
        var isExpanded = card.classList.toggle('expanded');
        body.style.display = isExpanded ? 'block' : 'none';
        chevron.style.transform = isExpanded ? 'rotate(180deg)' : '';
    });

    card.appendChild(header);

    /* ── BODY (oculto por defecto) ── */
    var body = el('div', {
        class: 'client-card-body',
        style: 'display:none;padding:8px 16px 12px;border-top:1px solid var(--gray-100);'
    });

    /* Fila helper */
    function fila(labelHtml, valorTexto) {
        var row = el('div', { class: 'client-detail-row' });
        var lbl = el('span', { class: 'client-detail-label', html: labelHtml });
        var val = el('span', { class: 'client-detail-value', text: valorTexto });
        row.appendChild(lbl);
        row.appendChild(val);
        return row;
    }

    /* Dirección */
    body.appendChild(fila(
        '<i class="fas fa-map-marker-alt"></i> Dirección',
        cl.direccion || 'No registrada'
    ));

    /* Referencia de ubicación del contrato (si existe) */
    if (cl.ubicacion_ref) {
        body.appendChild(fila(
            '<i class="fas fa-info-circle"></i> Ref. Ubicación',
            cl.ubicacion_ref
        ));
    }

    /* Botones de navegación GPS (si tiene coordenadas) */
    if (cl.ubicacion_lat && cl.ubicacion_lng) {
        var navRow = el('div', {
            class: 'client-detail-row',
            style: 'margin-top:6px;'
        });
        var navLbl = el('span', {
            class: 'client-detail-label',
            html: '<i class="fas fa-map"></i> Navegar'
        });
        navRow.appendChild(navLbl);

        var navBtns = el('div', {
            style: 'display:flex;gap:6px;flex-wrap:wrap;'
        });

        var btnMaps = el('a', {
            href: 'https://www.google.com/maps?q=' + cl.ubicacion_lat + ',' + cl.ubicacion_lng,
            target: '_blank',
            rel: 'noopener noreferrer',
            class: 'btn btn-sm',
            style: 'font-size:11px;background:#EFF6FF;color:#1D4ED8;',
            html: '<i class="fas fa-map"></i> Maps'
        });
        navBtns.appendChild(btnMaps);

        var btnWaze = el('a', {
            href: 'https://waze.com/ul?ll=' + cl.ubicacion_lat + ',' + cl.ubicacion_lng + '&navigate=yes',
            target: '_blank',
            rel: 'noopener noreferrer',
            class: 'btn btn-sm',
            style: 'font-size:11px;background:#EFF6FF;color:#1D4ED8;',
            html: '<i class="fas fa-route"></i> Waze'
        });
        navBtns.appendChild(btnWaze);

        navRow.appendChild(navBtns);
        body.appendChild(navRow);
    }

    /* Teléfonos */
    tels.forEach(function(tel, i) {
        var telNum = tel.replace(/\D/g, '');
        var row = el('div', { class: 'client-detail-row' });

        var lbl = el('span', {
            class: 'client-detail-label',
            html: '<i class="fas fa-phone"></i> Tel. ' + (i + 1)
        });
        row.appendChild(lbl);

        var val = el('span', {
            class: 'client-detail-value',
            style: 'display:flex;align-items:center;gap:6px;flex-wrap:wrap;'
        });
        val.appendChild(document.createTextNode(tel));

        var bCall = el('a', {
            href: 'tel:' + telNum,
            class: 'btn btn-sm',
            style: 'min-height:26px;padding:0 8px;background:var(--success-light);' +
                   'color:var(--success-text);font-size:11px;',
            html: '<i class="fas fa-phone"></i>'
        });
        val.appendChild(bCall);

        var waNum = (cl.no_whatsapp && String(cl.no_whatsapp).trim())
                    ? String(cl.no_whatsapp).replace(/\D/g, '')
                    : telNum;
        var bWa = el('a', {
            href: 'https://wa.me/1' + waNum,
            target: '_blank',
            rel: 'noopener noreferrer',
            class: 'btn btn-sm',
            style: 'min-height:26px;padding:0 8px;background:#dcfce7;' +
                   'color:#15803d;font-size:11px;',
            html: '<i class="fab fa-whatsapp"></i>'
        });
        val.appendChild(bWa);

        row.appendChild(val);
        body.appendChild(row);
    });

    /* Contratos */
    if (contratos.length > 0) {
        var secCont = el('div', {
            class: 'section-title',
            style: 'margin-top:10px;',
            html: '<i class="fas fa-file-contract"></i> Contratos'
        });
        body.appendChild(secCont);

        contratos.forEach(function(c) {
            var box = el('div', {
                style: 'background:var(--gray-50);border-radius:var(--radius-sm);' +
                       'padding:10px;margin-bottom:6px;border:1px solid var(--border);'
            });

            var rowC = el('div', {
                style: 'display:flex;justify-content:space-between;align-items:center;'
            });
            var numC = el('span', {
                style: 'font-size:12px;font-weight:700;color:var(--accent);',
                text: c.numero_contrato || ''
            });
            var diaC = el('span', {
                style: 'font-size:11px;color:var(--text-muted);'
            });
            diaC.innerHTML = 'Día cobro: <strong>' + (c.dia_cobro || '-') + '</strong>';
            rowC.appendChild(numC);
            rowC.appendChild(diaC);
            box.appendChild(rowC);

            if (c.plan_nombre) {
                var planDiv = el('div', {
                    style: 'font-size:11px;color:var(--text-muted);margin-top:4px;'
                });
                planDiv.innerHTML = '<i class="fas fa-umbrella" style="font-size:9px;margin-right:3px;"></i>';
                planDiv.appendChild(document.createTextNode(c.plan_nombre));
                box.appendChild(planDiv);
            }

            body.appendChild(box);
        });
    }

    /* Referencias */
    var secRef = el('div', {
        class: 'section-title',
        style: 'margin-top:10px;',
        html: '<i class="fas fa-address-book"></i> Referencias'
    });
    body.appendChild(secRef);

    if (referencias.length > 0) {
        referencias.forEach(function(r) {
            var rBox = el('div', {
                style: 'background:var(--gray-50);border-radius:var(--radius-sm);' +
                       'padding:10px;margin-bottom:6px;border:1px solid var(--border);'
            });

            var rNom = el('div', {
                style: 'font-size:13px;font-weight:600;color:var(--gray-800);',
                text: r.nombre || ''
            });
            rBox.appendChild(rNom);

            var rRel = el('div', {
                style: 'font-size:12px;color:var(--text-muted);margin-top:2px;',
                text: [r.relacion, r.telefono].filter(Boolean).join(' · ')
            });
            rBox.appendChild(rRel);

            if (r.telefono) {
                var rTelLink = el('a', {
                    href: 'tel:' + r.telefono.replace(/\D/g, ''),
                    style: 'font-size:11px;color:var(--accent);text-decoration:none;' +
                           'display:inline-flex;align-items:center;gap:3px;margin-top:4px;',
                    html: '<i class="fas fa-phone" style="font-size:9px;"></i> Llamar referencia'
                });
                rBox.appendChild(rTelLink);
            }

            if (r.direccion) {
                var rDir = el('div', {
                    style: 'font-size:11px;color:var(--text-muted);margin-top:3px;'
                });
                rDir.innerHTML = '<i class="fas fa-map-marker-alt" style="font-size:9px;margin-right:2px;"></i>';
                rDir.appendChild(document.createTextNode(r.direccion));
                rBox.appendChild(rDir);
            }

            body.appendChild(rBox);
        });
    } else {
        body.appendChild(el('div', {
            style: 'font-size:12px;color:var(--text-muted);padding:4px 0;',
            text: 'Sin referencias registradas.'
        }));
    }

    card.appendChild(body);

    /* ── ACCIONES ── */
    var actions = el('div', {
        class: 'client-card-actions',
        style: 'display:flex;gap:8px;padding:10px 14px;flex-wrap:wrap;' +
               'border-top:1px solid var(--gray-100);background:var(--gray-50);'
    });

    if (tels.length > 0) {
        var tel0 = tels[0].replace(/\D/g, '');
        var msgWa = 'Hola ' + nombre + ', le contactamos de ORTHIIS Seguros.';

        actions.appendChild(el('a', {
            href: 'tel:' + tel0,
            class: 'btn btn-success btn-sm',
            style: 'flex:1;',
            html: '<i class="fas fa-phone"></i> Llamar'
        }));

        var waNum = (cl.no_whatsapp && String(cl.no_whatsapp).trim())
                    ? String(cl.no_whatsapp).replace(/\D/g, '')
                    : tel0;
        actions.appendChild(el('a', {
            href: 'https://wa.me/1' + waNum + '?text=' + encodeURIComponent(msgWa),
            target: '_blank',
            rel: 'noopener noreferrer',
            class: 'btn btn-sm',
            style: 'flex:1;background:#16a34a;color:#fff;',
            html: '<i class="fab fa-whatsapp"></i> WA'
        }));
    }

    actions.appendChild(el('a', {
        href: 'facturas.php?cliente_id=' + cl.id,
        class: 'btn btn-primary btn-sm',
        style: 'flex:1;',
        html: '<i class="fas fa-file-invoice"></i> Facturas'
    }));

    /* Botón GPS en acciones si tiene coordenadas */
    if (cl.ubicacion_lat && cl.ubicacion_lng) {
        var btnGpsAction = el('button', {
            class: 'btn btn-secondary btn-sm',
            style: 'flex:1;',
            html: '<i class="fas fa-directions"></i> GPS'
        });
        (function(lat, lng, nom) {
            btnGpsAction.addEventListener('click', function() {
                if (typeof navegarConApp === 'function') {
                    navegarConApp(lat, lng, nom);
                } else {
                    window.open('https://www.google.com/maps?q=' + lat + ',' + lng, '_blank');
                }
            });
        })(cl.ubicacion_lat, cl.ubicacion_lng, nombre);
        actions.appendChild(btnGpsAction);
    }

    card.appendChild(actions);
    return card;
}

/* ═══════════════════════════════════════════════════════════
   RENDER
═══════════════════════════════════════════════════════════ */
function renderClientes(clientes, append) {
    var container  = document.getElementById('clientesContainer');
    var emptyState = document.getElementById('emptyState');
    var btnMasWrap = document.getElementById('btnCargarMasWrap');
    var countEl    = document.getElementById('searchCount');

    if (!append) {
        while (container.firstChild) container.removeChild(container.firstChild);
    }

    if (!clientes || clientes.length === 0) {
        if (!append) {
            emptyState.style.display = 'block';
            btnMasWrap.style.display  = 'none';
            countEl.textContent = 'Sin resultados';
        }
        return;
    }

    emptyState.style.display = 'none';

    var fragment = document.createDocumentFragment();
    clientes.forEach(function(cl) {
        try {
            fragment.appendChild(crearTarjetaCliente(cl));
        } catch(err) {
            console.error('Error tarjeta cliente ID=' + cl.id, err);
        }
    });
    container.appendChild(fragment);
}

/* ═══════════════════════════════════════════════════════════
   FETCH
═══════════════════════════════════════════════════════════ */
function buscarClientes(q, append) {
    if (isLoading) return;
    append = !!append;

    if (!append) {
        currentOffset = 0;
        var container = document.getElementById('clientesContainer');
        while (container.firstChild) container.removeChild(container.firstChild);
        var spinWrap = document.createElement('div');
        spinWrap.className = 'loading-overlay';
        spinWrap.id = 'mainSpinner';
        spinWrap.innerHTML = '<div class="spinner"></div>';
        container.appendChild(spinWrap);
        document.getElementById('btnCargarMasWrap').style.display = 'none';
    }

    isLoading = true;
    document.getElementById('searchSpinner').style.display = '';

    var url = 'api/get_clientes.php'
            + '?q='      + encodeURIComponent(q)
            + '&offset=' + currentOffset;

    fetch(url, { credentials: 'same-origin' })
        .then(function(resp) {
            // Leer como texto primero para detectar errores de PHP antes del JSON
            return resp.text();
        })
        .then(function(text) {
            var mainSpin = document.getElementById('mainSpinner');
            if (mainSpin) mainSpin.parentNode.removeChild(mainSpin);

            // Intentar parsear JSON
            var data;
            try {
                data = JSON.parse(text);
            } catch(e) {
                // El texto no es JSON válido — PHP generó un error
                console.error('Respuesta no es JSON:', text.substring(0, 500));
                showToast('Error del servidor. Ver consola para detalles.', 'error');
                return;
            }

            if (!data.success) {
                showToast('Error: ' + (data.message || 'No se pudieron cargar los clientes'), 'error');
                console.error('API error:', data.message);
                return;
            }

            var clientes = data.clientes || [];
            totalGlobal  = data.total    || 0;

            renderClientes(clientes, append);

            currentOffset += clientes.length;
            hayMas = clientes.length >= POR_PAGINA;

            document.getElementById('btnCargarMasWrap').style.display = hayMas ? 'block' : 'none';
            document.getElementById('searchCount').textContent =
                'Mostrando ' + currentOffset + ' de ' + totalGlobal + ' cliente(s)';
        })
        .catch(function(err) {
            var mainSpin = document.getElementById('mainSpinner');
            if (mainSpin) mainSpin.parentNode.removeChild(mainSpin);
            console.error('Fetch error:', err);
            showToast('Error de conexión. Verifica tu red.', 'error');
        })
        .finally(function() {
            isLoading = false;
            document.getElementById('searchSpinner').style.display = 'none';
        });
}

function cargarMas() {
    if (!hayMas || isLoading) return;
    buscarClientes(currentQuery, true);
}

/* Búsqueda con debounce */
var debTimer;
document.getElementById('searchInput').addEventListener('input', function() {
    clearTimeout(debTimer);
    currentQuery = this.value.trim();
    debTimer = setTimeout(function() {
        buscarClientes(currentQuery, false);
    }, 400);
});

document.getElementById('searchInput').addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        this.value = '';
        currentQuery = '';
        buscarClientes('', false);
    }
});

/* Carga inicial */
buscarClientes('', false);

/* ══════════════════════════════════════════════════════
   NAVEGACIÓN GPS — Modal de opciones (igual que facturas.php)
══════════════════════════════════════════════════════ */
function navegarConApp(lat, lng, nombreCliente) {
    var mapsUrl      = 'https://www.google.com/maps?q=' + lat + ',' + lng;
    var wazeUrl      = 'https://waze.com/ul?ll=' + lat + ',' + lng + '&navigate=yes';
    var appleMapsUrl = 'https://maps.apple.com/?daddr=' + lat + ',' + lng + '&dirflg=d';
    function esc(s) { return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

    var overlay = document.createElement('div');
    overlay.id = 'navOverlayCliente';
    overlay.style.cssText =
        'position:fixed;inset:0;background:rgba(0,0,0,.5);' +
        'z-index:9999;display:flex;align-items:flex-end;justify-content:center;';

    overlay.innerHTML =
        '<div style="background:#fff;border-radius:16px 16px 0 0;padding:20px;' +
        'width:100%;max-width:480px;padding-bottom:calc(20px + env(safe-area-inset-bottom));">' +
        '<div style="text-align:center;margin-bottom:16px;">' +
        '<div style="font-weight:700;font-size:16px;">Navegar hacia</div>' +
        '<div style="font-size:13px;color:#666;margin-top:4px;">' + esc(nombreCliente) + '</div>' +
        '</div>' +
        '<div style="display:flex;flex-direction:column;gap:10px;">' +

        '<a href="' + mapsUrl + '" target="_blank" ' +
        'style="display:flex;align-items:center;gap:12px;padding:14px 16px;' +
        'border-radius:12px;background:#f3f4f6;text-decoration:none;color:#111;">' +
        '<img src="https://www.google.com/favicon.ico" style="width:28px;height:28px;border-radius:6px;">' +
        '<div><div style="font-weight:600;font-size:14px;">Google Maps</div>' +
        '<div style="font-size:12px;color:#666;">Abrir en Google Maps</div></div></a>' +

        '<a href="' + wazeUrl + '" target="_blank" ' +
        'style="display:flex;align-items:center;gap:12px;padding:14px 16px;' +
        'border-radius:12px;background:#f3f4f6;text-decoration:none;color:#111;">' +
        '<div style="width:28px;height:28px;border-radius:6px;background:#00D4FF;' +
        'display:flex;align-items:center;justify-content:center;font-size:16px;">&#128663;</div>' +
        '<div><div style="font-weight:600;font-size:14px;">Waze</div>' +
        '<div style="font-size:12px;color:#666;">Abrir en Waze</div></div></a>' +

        '<a href="' + appleMapsUrl + '" target="_blank" ' +
        'style="display:flex;align-items:center;gap:12px;padding:14px 16px;' +
        'border-radius:12px;background:#f3f4f6;text-decoration:none;color:#111;">' +
        '<div style="width:28px;height:28px;border-radius:6px;background:#000;' +
        'display:flex;align-items:center;justify-content:center;font-size:16px;">&#127757;</div>' +
        '<div><div style="font-weight:600;font-size:14px;">Apple Maps</div>' +
        '<div style="font-size:12px;color:#666;">Para iPhone / iPad</div></div></a>' +
        '</div>' +
        '<button onclick="document.getElementById(\'navOverlayCliente\').remove()" ' +
        'style="width:100%;margin-top:14px;padding:13px;border-radius:10px;' +
        'border:1px solid #e5e7eb;background:#fff;font-size:14px;cursor:pointer;' +
        'color:#374151;font-weight:500;">Cancelar</button>' +
        '</div>';

    document.body.appendChild(overlay);
    overlay.addEventListener('click', function(e) {
        if (e.target === overlay) overlay.remove();
    });
}
</script>

</body>
</html>