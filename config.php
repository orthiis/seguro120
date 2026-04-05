<?php
// config.php
define('DB_HOST', 'localhost');
define('DB_USER', 'xygfyvca_segurov120');
define('DB_PASS', '*Camil7172*');
define('DB_NAME', 'xygfyvca_segurov120');

// Configurar parámetros de sesión antes de iniciarla
ini_set('session.cookie_httponly', 1);
ini_set('session.use_only_cookies', 1);
session_set_cookie_params([
    'lifetime' => 0,
    'path' => '/',
    'domain' => '',
    'secure' => true,
    'httponly' => true
]);

// Iniciar sesión en todas las páginas
session_start();

try {
    $conn = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME, DB_USER, DB_PASS);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    error_log("Error de conexión: " . $e->getMessage());
    die("Error de conexión con la base de datos");
}


function verificarSesion() {
    // Verificar si existe la sesión
    if (!isset($_SESSION['usuario_id'])) {
        // Si estamos en una petición AJAX, enviar código de error específico
        if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && 
            strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
            header('HTTP/1.1 401 Unauthorized');
            exit('Sesion_expirada');
        }
        
        // Para peticiones normales, redirigir al login
        header('Location: login.php?mensaje=sesion_expirada');
        exit();
    }
    
    // Verificar si la sesión ha expirado
    if (isset($_SESSION['ultima_actividad']) && (time() - $_SESSION['ultima_actividad'] > 3600)) {
        // Destruir la sesión
        session_unset();
        session_destroy();
        
        // Si es una petición AJAX
        if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && 
            strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
            header('HTTP/1.1 401 Unauthorized');
            exit('Sesion_expirada');
        }
        
        // Para peticiones normales
        header('Location: login.php?mensaje=sesion_expirada');
        exit();
    }
    
    // Actualizar el tiempo de última actividad
    $_SESSION['ultima_actividad'] = time();
}

/**
 * Retorna la URL del dashboard según el rol de sesión activa
 */
function getDashboardByRol(): string {
    $rol = $_SESSION['rol'] ?? '';
    switch ($rol) {
        case 'cobrador':   return 'cobrador/dashboard.php';
        case 'vendedor':   return 'vendedor/dashboard.php';
        case 'supervisor': return 'supervisor/dashboard.php';
        default:           return 'dashboard.php';
    }
}

/**
 * Verifica que el usuario sea admin.
 * Si no lo es, redirige a su dashboard correspondiente.
 * Usar en todos los archivos de la raíz que son solo para admin.
 */
function verificarAdmin(): void {
    verificarSesion(); // primero verificar que hay sesión activa
    $rol = $_SESSION['rol'] ?? '';
    if ($rol === 'admin') {
        return; // acceso permitido
    }
    // Redirigir no-admin a su propio dashboard
    switch ($rol) {
        case 'cobrador':
            header('Location: cobrador/dashboard.php');
            break;
        case 'vendedor':
            header('Location: vendedor/dashboard.php');
            break;
        case 'supervisor':
            header('Location: supervisor/dashboard.php');
            break;
        default:
            session_unset();
            session_destroy();
            header('Location: login.php?mensaje=acceso_denegado');
            break;
    }
    exit();
}

/**
 * Obtiene el nombre completo del usuario actual desde la BD
 */
function getNombreUsuarioActual(PDO $conn): string {
    if (empty($_SESSION['usuario_id'])) return 'Usuario';
    try {
        $stmt = $conn->prepare("SELECT nombre FROM usuarios WHERE id = ? LIMIT 1");
        $stmt->execute([$_SESSION['usuario_id']]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row['nombre'] ?? $_SESSION['usuario_nombre'] ?? 'Usuario';
    } catch (PDOException $e) {
        return $_SESSION['usuario_nombre'] ?? 'Usuario';
    }
}
?>