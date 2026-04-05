<?php
/* ============================================================
   vendedor/dashboard.php
   Sistema ORTHIIS — Seguros de Vida
   ============================================================ */
require_once __DIR__ . '/config_vendedor.php';
verificarSesionVendedor();

$nombreVendedor  = getNombreVendedor();
$vendedorUid     = $_SESSION['vendedor_portal_uid'] ?? $_SESSION['usuario_id'] ?? 0;

// Estadísticas básicas del vendedor
$totalClientes    = 0;
$totalContratos   = 0;
$contratosActivos = 0;

try {
    $totalClientes = (int)$conn->query("SELECT COUNT(*) FROM clientes")->fetchColumn();
} catch (PDOException $e) { error_log('vendedor/dashboard clientes: ' . $e->getMessage()); }

try {
    $totalContratos = (int)$conn->query("SELECT COUNT(*) FROM contratos")->fetchColumn();
    $contratosActivos = (int)$conn->query(
        "SELECT COUNT(*) FROM contratos WHERE estado = 'activo'"
    )->fetchColumn();
} catch (PDOException $e) { error_log('vendedor/dashboard contratos: ' . $e->getMessage()); }
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Portal Vendedor</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary:#B45309;--primary-light:#D97706;--primary-dark:#92400E;
            --sidebar-bg:#1c1c2e;--sidebar-text:#a0a8c0;
            --bg-body:#f0f4f8;--bg-card:#ffffff;
            --text-primary:#1e293b;--text-secondary:#64748b;
            --border-color:#e2e8f0;
            --shadow-sm:0 1px 3px rgba(0,0,0,.08);
            --shadow-md:0 4px 12px rgba(0,0,0,.10);
            --radius-md:12px;--radius-sm:8px;
        }
        *{margin:0;padding:0;box-sizing:border-box;}
        body{font-family:'Inter',sans-serif;background:var(--bg-body);
             display:flex;min-height:100vh;}
        /* ── Sidebar ── */
        .sidebar{width:240px;background:var(--sidebar-bg);position:fixed;
                 top:0;left:0;height:100vh;overflow-y:auto;
                 display:flex;flex-direction:column;z-index:100;}
        .sidebar-brand{padding:20px 16px;border-bottom:1px solid rgba(255,255,255,.08);
                       display:flex;align-items:center;gap:10px;}
        .brand-icon{width:36px;height:36px;background:var(--primary);border-radius:8px;
                    display:flex;align-items:center;justify-content:center;
                    color:white;font-size:16px;}
        .brand-text .brand-name{font-size:16px;font-weight:700;color:white;}
        .brand-text .brand-sub{font-size:11px;color:var(--sidebar-text);}
        .sidebar-nav{padding:12px 0;flex:1;}
        .nav-section-label{font-size:10px;font-weight:700;text-transform:uppercase;
                           letter-spacing:1.2px;color:#4a5568;padding:14px 18px 6px;}
        .nav-item{display:flex;align-items:center;gap:10px;padding:10px 18px;
                  color:var(--sidebar-text);text-decoration:none;font-size:13.5px;
                  font-weight:500;transition:all .3s ease;border-left:3px solid transparent;}
        .nav-item:hover{color:white;background:rgba(255,255,255,.06);}
        .nav-item.active{color:white;background:rgba(180,83,9,.18);
                         border-left-color:var(--primary);}
        .nav-icon{width:20px;text-align:center;}
        .sidebar-footer{padding:12px 16px;border-top:1px solid rgba(255,255,255,.08);}
        .user-info{display:flex;align-items:center;gap:10px;}
        .user-avatar{width:32px;height:32px;border-radius:50%;
                     background:linear-gradient(135deg,var(--primary),var(--primary-light));
                     display:flex;align-items:center;justify-content:center;
                     color:white;font-size:13px;font-weight:700;}
        .user-name{font-size:12px;color:white;font-weight:600;}
        .user-role{font-size:10px;color:var(--sidebar-text);}
        /* ── Layout ── */
        .main-content{margin-left:240px;flex:1;display:flex;flex-direction:column;}
        .topbar{background:var(--bg-card);border-bottom:1px solid var(--border-color);
                padding:0 24px;height:56px;display:flex;align-items:center;
                justify-content:space-between;position:sticky;top:0;z-index:50;}
        .topbar-title{font-size:15px;font-weight:600;color:var(--text-primary);}
        .btn-logout{background:none;border:1px solid var(--border-color);
                    color:var(--text-secondary);padding:6px 14px;border-radius:6px;
                    font-size:13px;cursor:pointer;text-decoration:none;
                    transition:all .3s ease;display:flex;align-items:center;gap:6px;}
        .btn-logout:hover{background:#fef2f2;border-color:#fecaca;color:#dc2626;}
        .page-content{padding:24px;flex:1;}
        /* ── Contenido ── */
        .welcome-banner{background:linear-gradient(135deg,var(--primary),var(--primary-light));
                        border-radius:var(--radius-md);padding:28px 32px;color:white;
                        margin-bottom:24px;}
        .welcome-banner h1{font-size:22px;font-weight:700;margin-bottom:6px;}
        .welcome-banner p{font-size:14px;opacity:.9;}
        .stats-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;}
        .stat-card{background:var(--bg-card);border-radius:var(--radius-md);
                   padding:20px 24px;box-shadow:var(--shadow-sm);
                   display:flex;align-items:center;gap:16px;}
        .stat-icon{width:48px;height:48px;border-radius:10px;
                   display:flex;align-items:center;justify-content:center;font-size:20px;}
        .stat-icon.orange{background:#fef3c7;color:#B45309;}
        .stat-icon.blue{background:#dbeafe;color:#1d4ed8;}
        .stat-icon.green{background:#d1fae5;color:#059669;}
        .stat-value{font-size:26px;font-weight:800;color:var(--text-primary);}
        .stat-label{font-size:12px;color:var(--text-secondary);margin-top:2px;}
        .coming-soon{background:var(--bg-card);border-radius:var(--radius-md);
                     padding:40px;text-align:center;box-shadow:var(--shadow-sm);
                     margin-top:24px;color:var(--text-secondary);}
        .coming-soon i{font-size:48px;margin-bottom:16px;opacity:.4;display:block;}
        .coming-soon h3{font-size:18px;font-weight:600;margin-bottom:8px;
                        color:var(--text-primary);}
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="fas fa-briefcase"></i></div>
        <div class="brand-text">
            <div class="brand-name">ORTHIIS</div>
            <div class="brand-sub">Portal Vendedor</div>
        </div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section-label">Principal</div>
        <a class="nav-item active" href="dashboard.php">
            <span class="nav-icon"><i class="fas fa-chart-pie"></i></span> Dashboard
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="user-info">
            <div class="user-avatar"><?php echo strtoupper(substr($nombreVendedor, 0, 1)); ?></div>
            <div>
                <div class="user-name"><?php echo htmlspecialchars($nombreVendedor); ?></div>
                <div class="user-role">Vendedor</div>
            </div>
        </div>
    </div>
</aside>
<div class="main-content">
    <div class="topbar">
        <span class="topbar-title">Dashboard</span>
        <a href="logout.php" class="btn-logout">
            <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
        </a>
    </div>
    <div class="page-content">
        <div class="welcome-banner">
            <h1>¡Bienvenido, <?php echo htmlspecialchars($nombreVendedor); ?>!</h1>
            <p>Resumen general del sistema — <?php echo date('d/m/Y'); ?></p>
        </div>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon orange"><i class="fas fa-users"></i></div>
                <div>
                    <div class="stat-value"><?php echo number_format($totalClientes); ?></div>
                    <div class="stat-label">Clientes Totales</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-file-contract"></i></div>
                <div>
                    <div class="stat-value"><?php echo number_format($totalContratos); ?></div>
                    <div class="stat-label">Contratos Totales</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                <div>
                    <div class="stat-value"><?php echo number_format($contratosActivos); ?></div>
                    <div class="stat-label">Contratos Activos</div>
                </div>
            </div>
        </div>
        <div class="coming-soon">
            <i class="fas fa-tools"></i>
            <h3>Módulo en Desarrollo</h3>
            <p>Las funcionalidades del portal vendedor estarán disponibles próximamente.</p>
        </div>
    </div>
</div>
</body>
</html>
