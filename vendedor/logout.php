<?php
/* vendedor/logout.php */
if (!defined('DB_HOST')) {
    require_once __DIR__ . '/../config.php';
}
if (session_status() === PHP_SESSION_NONE) {
    @session_start();
}
session_unset();
session_destroy();
header('Location: index.php?mensaje=logout_exitoso');
exit();
?>
