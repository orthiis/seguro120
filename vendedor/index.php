<?php
/* ============================================================
   vendedor/index.php — LOGIN PORTAL VENDEDOR
   Sistema ORTHIIS — Seguros de Vida
   ============================================================ */
if (!defined('DB_HOST')) {
    require_once __DIR__ . '/../config.php';
}
if (session_status() === PHP_SESSION_NONE) {
    $esHttps = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ||
               (isset($_SERVER['SERVER_PORT']) && (int)$_SERVER['SERVER_PORT'] === 443);
    ini_set('session.cookie_httponly', 1);
    ini_set('session.use_only_cookies', 1);
    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'secure'   => $esHttps,
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}

// Si ya hay sesión activa de vendedor → redirigir
if (
    (!empty($_SESSION['vendedor_portal_rol']) && $_SESSION['vendedor_portal_rol'] === 'vendedor') ||
    (!empty($_SESSION['usuario_id']) && ($_SESSION['rol'] ?? '') === 'vendedor')
) {
    header('Location: dashboard.php');
    exit();
}

$config = ['nombre_empresa' => 'ORTHIIS', 'logo_url' => '', 'telefono' => ''];
try {
    $stmtCfg = $conn->query(
        "SELECT nombre_empresa, logo_url, telefono FROM configuracion_sistema WHERE id = 1 LIMIT 1"
    );
    $config = $stmtCfg->fetch(PDO::FETCH_ASSOC) ?: $config;
} catch (PDOException $e) {
    error_log('vendedor/index.php: ' . $e->getMessage());
}

$error   = '';
$usuario = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuario  = trim($_POST['usuario'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($usuario) || empty($password)) {
        $error = 'Por favor ingresa tu usuario y contraseña.';
    } else {
        try {
            $stmt = $conn->prepare(
                "SELECT id, usuario, password, nombre, email, estado, rol
                 FROM usuarios WHERE usuario = ? LIMIT 1"
            );
            $stmt->execute([$usuario]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$user) {
                $error = 'Usuario o contraseña incorrectos.';
            } elseif ($user['rol'] !== 'vendedor') {
                $error = 'Este portal es exclusivo para vendedores.';
            } elseif ($user['estado'] !== 'activo') {
                $error = 'Tu cuenta está inactiva. Contacta a la oficina.';
            } elseif (!password_verify($password, $user['password'])) {
                $error = 'Usuario o contraseña incorrectos.';
            } else {
                session_regenerate_id(true);
                $_SESSION['vendedor_portal_rol']    = 'vendedor';
                $_SESSION['vendedor_portal_uid']    = (int)$user['id'];
                $_SESSION['vendedor_portal_nombre'] = $user['nombre'];
                $_SESSION['usuario_id']             = (int)$user['id'];
                $_SESSION['usuario_nombre']         = $user['usuario'];
                $_SESSION['rol']                    = 'vendedor';
                $_SESSION['ultima_actividad']       = time();
                if (empty($_SESSION['csrf_token_vendedor'])) {
                    $_SESSION['csrf_token_vendedor'] = bin2hex(random_bytes(32));
                }
                try {
                    $conn->prepare("UPDATE usuarios SET ultimo_acceso = NOW() WHERE id = ?")
                         ->execute([$user['id']]);
                } catch (PDOException $e) {
                    error_log('update ultimo_acceso vendedor: ' . $e->getMessage());
                }
                $redirect = $_SESSION['vendedor_redirect_after_login'] ?? 'dashboard.php';
                unset($_SESSION['vendedor_redirect_after_login']);
                header('Location: ' . ($redirect ?: 'dashboard.php'));
                exit();
            }
        } catch (PDOException $e) {
            error_log('vendedor/index.php PDO: ' . $e->getMessage());
            $error = 'Error interno. Por favor intente nuevamente.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal Vendedor — <?php echo htmlspecialchars($config['nombre_empresa']); ?></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #B45309; --primary-light: #D97706; --primary-dark: #92400E;
            --bg-body: #f0f4f8; --bg-card: #ffffff;
            --text-primary: #1e293b; --text-secondary: #64748b;
            --border-color: #e2e8f0; --danger: #ef4444;
            --shadow-lg: 0 10px 30px rgba(0,0,0,.12);
            --radius-lg: 16px; --transition: all .3s ease;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-body);
               min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-wrapper { width: 100%; max-width: 420px; padding: 20px; }
        .login-card { background: var(--bg-card); border-radius: var(--radius-lg);
                      box-shadow: var(--shadow-lg); overflow: hidden; }
        .login-header { background: linear-gradient(135deg, var(--primary), var(--primary-light));
                        padding: 32px 40px; text-align: center; color: white; }
        .login-header .icon { width: 60px; height: 60px; background: rgba(255,255,255,.2);
                              border-radius: 50%; display: flex; align-items: center;
                              justify-content: center; font-size: 24px; margin: 0 auto 12px; }
        .login-header h1 { font-size: 22px; font-weight: 700; }
        .login-header p  { font-size: 13px; opacity: .85; margin-top: 4px; }
        .login-body { padding: 32px 40px; }
        .alert-error { background: #fef2f2; border: 1px solid #fecaca; color: #dc2626;
                       padding: 12px 16px; border-radius: 8px; font-size: 14px;
                       display: flex; align-items: center; gap: 8px; margin-bottom: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600;
                            color: var(--text-primary); margin-bottom: 6px; }
        .form-group input { width: 100%; padding: 11px 14px; border: 1.5px solid var(--border-color);
                            border-radius: 8px; font-size: 14px; font-family: inherit;
                            transition: var(--transition); outline: none; }
        .form-group input:focus { border-color: var(--primary);
                                  box-shadow: 0 0 0 3px rgba(180,83,9,.15); }
        .btn-login { width: 100%; padding: 13px; background: linear-gradient(135deg,var(--primary),var(--primary-light));
                     color: white; border: none; border-radius: 8px; font-size: 15px;
                     font-weight: 600; cursor: pointer; transition: var(--transition); }
        .btn-login:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(180,83,9,.3); }
        .login-footer { text-align: center; padding: 16px 40px 28px;
                        font-size: 13px; color: var(--text-secondary); }
        .login-footer a { color: var(--primary); text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
<div class="login-wrapper">
    <div class="login-card">
        <div class="login-header">
            <div class="icon"><i class="fas fa-briefcase"></i></div>
            <h1>Portal Vendedor</h1>
            <p><?php echo htmlspecialchars($config['nombre_empresa']); ?> — Sistema de Seguros</p>
        </div>
        <div class="login-body">
            <?php if ($error): ?>
                <div class="alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <?php echo htmlspecialchars($error); ?>
                </div>
            <?php endif; ?>
            <?php if (isset($_GET['mensaje']) && $_GET['mensaje'] === 'logout_exitoso'): ?>
                <div style="background:#f0fdf4;border:1px solid #bbf7d0;color:#166534;
                            padding:12px 16px;border-radius:8px;font-size:14px;
                            display:flex;align-items:center;gap:8px;margin-bottom:20px;">
                    <i class="fas fa-check-circle"></i> Sesión cerrada correctamente.
                </div>
            <?php endif; ?>
            <form method="POST" autocomplete="off">
                <div class="form-group">
                    <label for="usuario"><i class="fas fa-user"></i> Usuario</label>
                    <input type="text" id="usuario" name="usuario" required
                           value="<?php echo htmlspecialchars($usuario); ?>"
                           placeholder="Tu nombre de usuario" autofocus>
                </div>
                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> Contraseña</label>
                    <input type="password" id="password" name="password" required
                           placeholder="Tu contraseña">
                </div>
                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                </button>
            </form>
        </div>
        <div class="login-footer">
            <a href="../login.php"><i class="fas fa-arrow-left"></i> Volver al login principal</a>
        </div>
    </div>
</div>
</body>
</html>
