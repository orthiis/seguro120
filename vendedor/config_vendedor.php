<?php
/* ============================================================
   vendedor/config_vendedor.php
   Configuración y verificación de sesión para el portal vendedor
   ============================================================ */
if (!ob_get_level()) { ob_start(); }
if (!defined('DB_HOST')) {
    require_once __DIR__ . '/../config.php';
}
if (session_status() !== PHP_SESSION_ACTIVE) {
    @session_start();
}
if (empty($_SESSION['csrf_token_vendedor'])) {
    $_SESSION['csrf_token_vendedor'] = bin2hex(random_bytes(32));
}

function verificarSesionVendedor(): void
{
    // Verificar sesión vendedor directa (login desde portal vendedor)
    $porPortal = (
        !empty($_SESSION['vendedor_portal_rol']) &&
        $_SESSION['vendedor_portal_rol'] === 'vendedor'
    );
    // Verificar sesión compartida desde login principal
    $porLogin = (
        !empty($_SESSION['usuario_id']) &&
        !empty($_SESSION['rol']) &&
        $_SESSION['rol'] === 'vendedor'
    );
    if (!$porPortal && !$porLogin) {
        if (!isset($_SESSION['vendedor_redirect_after_login'])) {
            if (!str_contains($_SERVER['REQUEST_URI'] ?? '', 'index.php')) {
                $_SESSION['vendedor_redirect_after_login'] = $_SERVER['REQUEST_URI'];
            }
        }
        header('Location: index.php');
        exit();
    }
    // Actualizar actividad
    $_SESSION['ultima_actividad'] = time();
}

function verificarSesionVendedorAjax(): void
{
    $porPortal = (
        !empty($_SESSION['vendedor_portal_rol']) &&
        $_SESSION['vendedor_portal_rol'] === 'vendedor'
    );
    $porLogin = (
        !empty($_SESSION['usuario_id']) &&
        ($_SESSION['rol'] ?? '') === 'vendedor'
    );
    if (!$porPortal && !$porLogin) {
        if (ob_get_level()) ob_clean();
        header('Content-Type: application/json; charset=utf-8');
        http_response_code(401);
        echo json_encode([
            'success' => false,
            'message' => 'Sesión expirada. Por favor inicia sesión nuevamente.'
        ]);
        exit();
    }
}

function getNombreVendedor(): string
{
    if (!empty($_SESSION['vendedor_portal_nombre'])) {
        return $_SESSION['vendedor_portal_nombre'];
    }
    return $_SESSION['usuario_nombre'] ?? 'Vendedor';
}
?>
