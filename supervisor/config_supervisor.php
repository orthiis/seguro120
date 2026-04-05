<?php
/* ============================================================
   supervisor/config_supervisor.php
   Configuración y verificación de sesión para el portal supervisor
   ============================================================ */
if (!ob_get_level()) { ob_start(); }
if (!defined('DB_HOST')) {
    require_once __DIR__ . '/../config.php';
}
if (session_status() !== PHP_SESSION_ACTIVE) {
    @session_start();
}
if (empty($_SESSION['csrf_token_supervisor'])) {
    $_SESSION['csrf_token_supervisor'] = bin2hex(random_bytes(32));
}

function verificarSesionSupervisor(): void
{
    // Verificar sesión supervisor directa (login desde portal supervisor)
    $porPortal = (
        !empty($_SESSION['supervisor_portal_rol']) &&
        $_SESSION['supervisor_portal_rol'] === 'supervisor'
    );
    // Verificar sesión compartida desde login principal
    $porLogin = (
        !empty($_SESSION['usuario_id']) &&
        !empty($_SESSION['rol']) &&
        $_SESSION['rol'] === 'supervisor'
    );
    if (!$porPortal && !$porLogin) {
        if (!isset($_SESSION['supervisor_redirect_after_login'])) {
            if (!str_contains($_SERVER['REQUEST_URI'] ?? '', 'index.php')) {
                $_SESSION['supervisor_redirect_after_login'] = $_SERVER['REQUEST_URI'];
            }
        }
        header('Location: index.php');
        exit();
    }
    // Actualizar actividad
    $_SESSION['ultima_actividad'] = time();
}

function verificarSesionSupervisorAjax(): void
{
    $porPortal = (
        !empty($_SESSION['supervisor_portal_rol']) &&
        $_SESSION['supervisor_portal_rol'] === 'supervisor'
    );
    $porLogin = (
        !empty($_SESSION['usuario_id']) &&
        ($_SESSION['rol'] ?? '') === 'supervisor'
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

function getNombreSupervisor(): string
{
    if (!empty($_SESSION['supervisor_portal_nombre'])) {
        return $_SESSION['supervisor_portal_nombre'];
    }
    return $_SESSION['usuario_nombre'] ?? 'Supervisor';
}
?>
