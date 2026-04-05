<?php
require_once __DIR__ . '/config_cobrador.php';

// Registrar logout en log antes de destruir la sesión
if (!empty($_SESSION['cobrador_portal_id'])) {
    registrarLogCobrador((int)$_SESSION['cobrador_portal_id'], 'logout');
}

// Destruir TODAS las variables de sesión (cobrador portal + login principal).
// Es necesario limpiar también usuario_id / rol / usuario_nombre porque el cobrador
// pudo haber ingresado desde login.php (raíz), que establece esas variables.
// Si no se limpian, cobrador/index.php detecta rol='cobrador' activo y redirige
// de vuelta al dashboard sin completar el logout.
session_unset();
session_destroy();

// Reiniciar sesión limpia para poder mostrar el mensaje de logout en index.php
session_start();

header('Location: index.php?logout=1');
exit();