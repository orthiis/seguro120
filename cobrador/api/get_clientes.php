<?php
/* ============================================================
   cobrador/api/get_clientes.php
   FIX: cobrador_id ahora vive en contratos, no en clientes.
   LIMIT/OFFSET se pasan directo como int en el SQL
   (MariaDB no acepta placeholders ? para LIMIT con PDO emulado)
   ============================================================ */
ob_start();
if (!defined('DB_HOST')) require_once __DIR__ . '/../../config.php';
ob_clean();

require_once __DIR__ . '/../config_cobrador.php';
verificarSesionCobradorAjax();

header('Content-Type: application/json; charset=utf-8');

$cobradorId = (int)$_SESSION['cobrador_portal_id'];
$q          = trim($_GET['q'] ?? '');
$offset     = max(0, (int)($_GET['offset'] ?? 0));
$porPagina  = 20;

try {
    /* ── Paso 1: IDs de clientes por número de contrato ── */
    $idsContrato = [];
    if ($q !== '') {
        $s = $conn->prepare("
            SELECT DISTINCT c.cliente_id
            FROM contratos c
            WHERE c.cobrador_id = ?
              AND c.numero_contrato LIKE ?
              AND c.estado = 'activo'
            LIMIT 300
        ");
        $s->execute([$cobradorId, "%$q%"]);
        $idsContrato = $s->fetchAll(PDO::FETCH_COLUMN);
    }

    /* ── Paso 2: IDs de clientes que tienen contrato con este cobrador ── */
    /* Subconsulta para evitar duplicados por múltiples contratos */
    $subCobrador = "(SELECT DISTINCT c2.cliente_id FROM contratos c2
                     WHERE c2.cobrador_id = $cobradorId AND c2.estado = 'activo')";

    $condiciones = "cl.id IN $subCobrador AND cl.estado = 'activo'";
    $bindParams  = [];

    if ($q !== '') {
        $like = "%$q%";
        if (!empty($idsContrato)) {
            $ph = implode(',', array_fill(0, count($idsContrato), '?'));
            $condiciones .= " AND (
                cl.nombre LIKE ? OR cl.apellidos LIKE ?
                OR CONCAT(cl.nombre,' ',cl.apellidos) LIKE ?
                OR cl.codigo LIKE ?
                OR cl.id IN ($ph)
            )";
            $bindParams[] = $like;
            $bindParams[] = $like;
            $bindParams[] = $like;
            $bindParams[] = $like;
            foreach ($idsContrato as $cid) $bindParams[] = (int)$cid;
        } else {
            $condiciones .= " AND (
                cl.nombre LIKE ? OR cl.apellidos LIKE ?
                OR CONCAT(cl.nombre,' ',cl.apellidos) LIKE ?
                OR cl.codigo LIKE ?
            )";
            $bindParams[] = $like;
            $bindParams[] = $like;
            $bindParams[] = $like;
            $bindParams[] = $like;
        }
    }

    /* ── Paso 3: Total ── */
    $stmtT = $conn->prepare("SELECT COUNT(*) FROM clientes cl WHERE $condiciones");
    $stmtT->execute($bindParams);
    $total = (int)$stmtT->fetchColumn();

    /* ── Paso 4: Listado ── */
    $limitInt  = (int)$porPagina;
    $offsetInt = (int)$offset;

    $stmtL = $conn->prepare("
        SELECT cl.id, cl.codigo, cl.nombre, cl.apellidos, cl.estado
        FROM clientes cl
        WHERE $condiciones
        ORDER BY cl.nombre ASC, cl.apellidos ASC
        LIMIT $limitInt OFFSET $offsetInt
    ");
    $stmtL->execute($bindParams);
    $clientes = $stmtL->fetchAll(PDO::FETCH_ASSOC);

    /* ── Paso 5: Contratos (con datos de contacto) y referencias ── */
    $stmtC = $conn->prepare("
        SELECT c.numero_contrato, c.dia_cobro, c.estado,
               c.telefono1, c.telefono2, c.no_whatsapp, c.direccion,
               c.ubicacion_lat, c.ubicacion_lng, c.ubicacion_ref,
               p.nombre AS plan_nombre
        FROM contratos c
        JOIN planes p ON p.id = c.plan_id
        WHERE c.cliente_id = ? AND c.estado = 'activo' AND c.cobrador_id = ?
        ORDER BY c.numero_contrato ASC LIMIT 5
    ");
    $stmtR = $conn->prepare("
        SELECT nombre, relacion, telefono, direccion
        FROM referencias_clientes
        WHERE cliente_id = ? ORDER BY id ASC LIMIT 3
    ");

    foreach ($clientes as &$cl) {
        $stmtC->execute([$cl['id'], $cobradorId]);
        $contratos         = $stmtC->fetchAll(PDO::FETCH_ASSOC);
        $cl['contratos']   = $contratos;

        /* Datos de contacto del primer contrato activo del cobrador */
        $primerContrato    = $contratos[0] ?? [];
        $cl['telefono1']   = $primerContrato['telefono1']   ?? '';
        $cl['telefono2']   = $primerContrato['telefono2']   ?? '';
        $cl['no_whatsapp'] = $primerContrato['no_whatsapp'] ?? '';
        $cl['telefono3']   = ''; /* ya no existe en clientes */
        $cl['direccion']   = $primerContrato['direccion']   ?? '';

        $stmtR->execute([$cl['id']]);
        $cl['referencias'] = $stmtR->fetchAll(PDO::FETCH_ASSOC);

        /* Propagar ubicación del primer contrato activo con coordenadas */
        $cl['ubicacion_lat'] = null;
        $cl['ubicacion_lng'] = null;
        $cl['ubicacion_ref'] = null;
        foreach ($contratos as $ct) {
            if (!empty($ct['ubicacion_lat']) && !empty($ct['ubicacion_lng'])) {
                $cl['ubicacion_lat'] = $ct['ubicacion_lat'];
                $cl['ubicacion_lng'] = $ct['ubicacion_lng'];
                $cl['ubicacion_ref'] = $ct['ubicacion_ref'];
                break;
            }
        }
    }
    unset($cl);

    echo json_encode([
        'success'    => true,
        'clientes'   => $clientes,
        'total'      => $total,
        'offset'     => $offset,
        'por_pagina' => $porPagina,
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    error_log('get_clientes cobrador PDO: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success'  => false,
        'message'  => 'Error: ' . $e->getMessage(),
        'clientes' => [], 'total' => 0,
    ]);
}
