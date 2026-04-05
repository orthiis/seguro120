-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 04-04-2026 a las 10:21:19
-- Versión del servidor: 11.4.10-MariaDB-cll-lve
-- Versión de PHP: 8.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `xygfyvca_segurov120`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciones_facturas`
--

CREATE TABLE `asignaciones_facturas` (
  `id` int(11) NOT NULL,
  `factura_id` int(11) NOT NULL,
  `cobrador_id` int(11) NOT NULL,
  `fecha_asignacion` date NOT NULL,
  `estado` enum('activa','completada','reasignada') DEFAULT 'activa',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `asignaciones_facturas`
--

INSERT INTO `asignaciones_facturas` (`id`, `factura_id`, `cobrador_id`, `fecha_asignacion`, `estado`, `created_at`, `updated_at`) VALUES
(27, 24, 1, '2026-04-03', 'activa', '2026-04-03 05:22:07', '2026-04-03 05:22:07'),
(28, 25, 1, '2026-04-03', 'activa', '2026-04-03 05:22:07', '2026-04-03 05:22:07'),
(29, 23, 1, '2026-04-04', 'activa', '2026-04-03 05:22:25', '2026-04-03 05:22:25'),
(30, 29, 1, '2026-04-06', 'activa', '2026-04-04 02:29:50', '2026-04-04 02:29:50'),
(31, 30, 1, '2026-04-09', 'activa', '2026-04-04 03:02:49', '2026-04-04 03:02:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `beneficiarios`
--

CREATE TABLE `beneficiarios` (
  `id` int(11) NOT NULL,
  `contrato_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `parentesco` varchar(50) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `beneficiarios`
--

INSERT INTO `beneficiarios` (`id`, `contrato_id`, `nombre`, `apellidos`, `parentesco`, `porcentaje`, `fecha_nacimiento`, `created_at`, `updated_at`) VALUES
(2, 2, 'María Elena', 'González de Pérez', 'Cónyuge', 60.00, '1987-06-20', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(3, 2, 'Carlos Junior', 'Pérez González', 'Hijo', 40.00, '2012-03-15', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(4, 3, 'Luis Alberto', 'González Herrera', 'Padre', 50.00, '1960-11-05', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(5, 3, 'Carmen Rosa', 'Martínez de González', 'Madre', 50.00, '1963-04-22', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(6, 4, 'Luisa María', 'Rosario de Féliz', 'Cónyuge', 70.00, '1980-08-14', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(7, 4, 'Pedro Antonio', 'Féliz Rosario Jr', 'Hijo', 30.00, '2008-02-28', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(8, 5, 'Roberto Manuel', 'Báez Reyes', 'Padre', 50.00, '1958-07-10', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(9, 5, 'Ana María', 'Hernández de Báez', 'Madre', 50.00, '1960-03-18', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(10, 6, 'Yanira Patricia', 'Matos Jiménez', 'Hermana', 60.00, '1998-05-25', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(11, 6, 'Rosa Elena', 'Jiménez de Matos', 'Madre', 40.00, '1965-09-30', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(12, 7, 'Pedro Carlos', 'Reyes Méndez', 'Padre', 60.00, '1962-12-01', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(13, 7, 'Luisa Antonia', 'Castillo de Reyes', 'Madre', 40.00, '1965-08-15', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(16, 9, 'María de los Ángeles', 'García Reyes', 'Madre', 70.00, '1968-08-05', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(17, 9, 'José Antonio', 'De los Santos Pérez', 'Padre', 30.00, '1965-02-17', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(18, 10, 'Carmen Rosa', 'Martínez de Díaz', 'Cónyuge', 60.00, '1982-05-20', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(19, 10, 'Francisco Javier', 'Díaz Martínez', 'Hijo', 40.00, '2010-09-15', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(20, 11, 'Roberto Manuel', 'Méndez Castillo', 'Cónyuge', 55.00, '1985-03-10', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(21, 11, 'Elena Gabriela', 'Méndez Taveras', 'Hija', 45.00, '2012-07-22', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(24, 13, 'Pedro Antonio', 'Soto Marmolejos', 'Cónyuge', 70.00, '1989-08-14', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(25, 13, 'Rosa Milagros', 'Almonte Peralta', 'Hermana', 30.00, '1994-01-11', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(28, 15, 'Antonio José', 'Peña Rosario', 'Cónyuge', 65.00, '1988-09-25', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(29, 15, 'Lucía Fernanda', 'Peña Núñez', 'Hija', 35.00, '2014-03-07', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(30, 16, 'Mercedes Alicia', 'Ramírez de Castillo', 'Cónyuge', 60.00, '1981-07-19', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(31, 16, 'José David', 'Castillo Ramírez Jr', 'Hijo', 40.00, '2009-12-01', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(32, 17, 'Ricardo Antonio', 'Féliz Taveras', 'Cónyuge', 100.00, '1975-04-22', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(37, 21, 'Felipe Antonio', 'Torres Hernández', 'Cónyuge', 100.00, '1970-01-15', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(38, 22, 'Altagracia María', 'Quezada de Fermín', 'Cónyuge', 100.00, '1991-03-18', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(39, 23, 'Ramón Antonio', 'Montero García', 'Cónyuge', 100.00, '1984-07-09', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(44, 26, 'Rosa Elena', 'Cepeda de Tavares', 'Cónyuge', 100.00, '1962-11-08', '2026-04-02 03:19:14', '2026-04-02 03:19:14'),
(45, 25, 'Manuel Antonio', 'Tejeda Espinal', 'Hermano', 100.00, '1960-05-30', '2026-04-02 03:19:30', '2026-04-02 03:19:30'),
(46, 24, 'Patricia Elena', 'Batista de Suero', 'Cónyuge', 60.00, '1976-08-23', '2026-04-02 03:19:43', '2026-04-02 03:19:43'),
(47, 24, 'Rafael Augusto', 'Suero Batista Jr', 'Hijo', 40.00, '2003-11-14', '2026-04-02 03:19:43', '2026-04-02 03:19:43'),
(48, 8, 'Carmen Altagracia', 'Vargas de Santana', 'Cónyuge', 65.00, '1977-04-14', '2026-04-02 03:20:41', '2026-04-02 03:20:41'),
(49, 8, 'Luis Carlos', 'Santana Vargas', 'Hijo', 35.00, '2005-09-22', '2026-04-02 03:20:41', '2026-04-02 03:20:41'),
(50, 14, 'Carlos Manuel', 'Ureña Pimentel Jr', 'Hijo', 40.00, '2015-06-10', '2026-04-02 03:21:05', '2026-04-02 03:21:05'),
(51, 14, 'María Eugenia', 'Pimentel de Ureña', 'Cónyuge', 60.00, '1985-02-28', '2026-04-02 03:21:05', '2026-04-02 03:21:05'),
(52, 20, 'Héctor Rafael', 'Salcedo Florentino Jr', 'Hijo', 30.00, '2007-09-08', '2026-04-03 03:41:40', '2026-04-03 03:41:40'),
(53, 20, 'Isabel María', 'Florentino de Salcedo', 'Cónyuge', 70.00, '1983-04-12', '2026-04-03 03:41:40', '2026-04-03 03:41:40'),
(54, 19, 'Eduardo José', 'Álvarez Montero', 'Cónyuge', 100.00, '1991-10-05', '2026-04-03 03:42:10', '2026-04-03 03:42:10'),
(55, 18, 'Carmen Luisa', 'Lara de Herrera', 'Cónyuge', 100.00, '1987-06-18', '2026-04-03 03:42:38', '2026-04-03 03:42:38'),
(56, 12, 'Miguel Ángel', 'Polanco Cruz Jr', 'Hijo', 40.00, '2008-04-05', '2026-04-03 04:47:29', '2026-04-03 04:47:29'),
(57, 12, 'Yolanda María', 'Cruz Sánchez', 'Cónyuge', 60.00, '1978-11-30', '2026-04-03 04:47:29', '2026-04-03 04:47:29'),
(58, 27, 'Mercedes', 'Reyes', 'Madre', 100.00, '1945-10-26', '2026-04-04 01:55:17', '2026-04-04 01:55:17'),
(59, 28, 'Marie Camil', 'Galvez', 'Hija', 50.00, '2014-04-09', '2026-04-04 02:59:15', '2026-04-04 02:59:15'),
(60, 28, 'Jomil', 'Peralta', 'Hija', 50.00, '2000-01-01', '2026-04-04 02:59:15', '2026-04-04 02:59:15'),
(62, 29, 'aaa', 'aaa', 'Hijo', 100.00, '2000-01-01', '2026-04-04 05:28:44', '2026-04-04 05:28:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `beneficios_planes`
--

CREATE TABLE `beneficios_planes` (
  `id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `monto_cobertura` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `codigo` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `cedula` varchar(13) NOT NULL,
  `telefono1` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `fecha_registro` datetime NOT NULL,
  `estado` enum('activo','inactivo','suspendido') DEFAULT 'activo',
  `notas` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `codigo`, `nombre`, `apellidos`, `cedula`, `telefono1`, `email`, `fecha_nacimiento`, `fecha_registro`, `estado`, `notas`, `created_at`, `updated_at`) VALUES
(2, '00002', 'Miguel Angel', 'Ortega Reyes', '001-1234567-8', '809-555-7878', 'orthiis1982@gmail.com', '1982-09-01', '2026-04-03 00:00:00', 'activo', 'Notas / Observaciones', '2026-04-02 03:14:27', '2026-04-04 02:31:06'),
(3, '00003', 'María Altagracia', 'González Martínez', '001-2345678-9', '809-581-2002', 'mgonzalez@hotmail.com', '1990-07-22', '2024-01-15 10:30:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(4, '00004', 'Pedro Antonio', 'Féliz Rosario', '002-3456789-1', '809-242-3003', 'pafeliz@gmail.com', '1978-11-08', '2024-02-05 08:45:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(5, '00005', 'Carmen Lucía', 'Báez Hernández', '003-4567890-2', '829-686-4004', 'clbaez@yahoo.com', '1982-05-30', '2024-02-20 11:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(6, '00006', 'Roberto Carlos', 'Matos Jiménez', '004-5678901-3', '809-261-5005', 'rcmatos@gmail.com', '1995-09-12', '2024-03-01 09:15:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(7, '00007', 'Ana Mercedes', 'Reyes Castillo', '005-6789012-4', '809-524-6006', 'amreyes@gmail.com', '1988-01-18', '2024-03-12 14:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(8, '00008', 'Luis Enrique', 'Santana Vargas', '006-7890123-5', '829-472-7007', 'lesantana@hotmail.com', '1975-06-25', '2024-04-01 10:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(9, '00009', 'Rosa Amelia', 'De los Santos García', '007-8901234-6', '809-556-8008', 'radesantos@gmail.com', '1993-12-03', '2024-04-15 08:30:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(10, '00010', 'Francisco Javier', 'Díaz Ramos', '008-9012345-7', '809-578-9009', 'fjdiaz@gmail.com', '1980-08-14', '2024-05-03 09:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(11, '00011', 'Elena Patricia', 'Taveras Méndez', '009-0123456-8', '829-588-0010', 'eptaveras@yahoo.com', '1987-04-07', '2024-05-20 11:30:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(12, '00012', 'Miguel Ángel', 'Polanco Cruz', '010-1234567-9', '809-296-1011', 'mapolanco@gmail.com', '1976-10-19', '2024-06-05 10:15:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(13, '00013', 'Juana Milagros', 'Almonte Soto', '011-2345678-1', '849-521-2012', 'jmalmonte@hotmail.com', '1992-02-28', '2024-06-18 09:45:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(14, '00014', 'Carlos Manuel', 'Ureña Pimentel', '012-3456789-2', '809-522-3013', 'cmurena@gmail.com', '1983-07-11', '2024-07-02 08:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(15, '00015', 'Lucía Esperanza', 'Núñez Peña', '013-4567890-3', '809-554-4014', 'lenunez@gmail.com', '1991-11-05', '2024-07-20 14:30:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(16, '00016', 'José David', 'Castillo Ramírez', '014-5678901-4', '829-579-5015', 'jdcastillo@yahoo.com', '1979-03-22', '2024-08-08 09:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(17, '00017', 'Yanira Beatriz', 'Ogando Féliz', '015-6789012-5', '809-584-6016', 'ybogando@gmail.com', '1977-09-30', '2024-08-25 10:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(18, '00018', 'Antonio Ramón', 'Herrera Lara', '016-7890123-6', '809-553-7017', 'arherrera@hotmail.com', '1985-05-16', '2024-09-10 11:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(19, '00019', 'Dolores Miledys', 'Acosta Álvarez', '017-8901234-7', '849-585-8018', 'dmacosta@gmail.com', '1994-01-27', '2024-09-28 09:30:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(20, '00020', 'Héctor Rafael', 'Salcedo Florentino', '018-9012345-8', '809-583-9019', 'hrsalcedo@gmail.com', '1981-12-09', '2024-10-15 08:15:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(21, '00021', 'Margarita Isabel', 'Beltre Torres', '019-0123456-9', '809-227-0020', 'mibeltre@yahoo.com', '1972-08-14', '2024-10-30 13:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(22, '00022', 'Víctor Manuel', 'Fermín Quezada', '020-1234567-1', '849-556-1021', 'vmfermin@gmail.com', '1989-06-03', '2024-11-12 10:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(23, '00023', 'Sonia Yolanda', 'Cabral Montero', '021-2345678-2', '809-582-2022', 'sycabral@hotmail.com', '1986-04-18', '2024-11-28 09:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(24, '00024', 'Rafael Augusto', 'Suero Batista', '022-3456789-3', '809-596-3023', 'rasuero@gmail.com', '1974-10-31', '2024-12-10 11:30:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(25, '00025', 'Gladys Antonia', 'Tejeda Espinal', '023-4567890-4', '809-247-4024', 'gatejeda@yahoo.com', '1955-02-14', '2025-01-08 09:00:00', 'activo', NULL, '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(26, '00026', 'Ernesto Leonidas', 'Tavares Cepeda', '024-5678901-5', '849-526-5025', 'eltavares@gmail.com', '1958-07-22', '2025-01-22 00:00:00', 'activo', '', '2026-04-02 03:14:27', '2026-04-04 01:49:30'),
(29, '00027', 'Camil', 'Peralta', '001-8885555-1', '809-555-1111', 'camil@gmail.com', '1986-10-05', '2026-04-04 00:00:00', 'activo', 'Nota de Clientes', '2026-04-04 02:56:08', '2026-04-04 02:56:08'),
(30, '00028', 'aaa', 'aaa', '000-1234545-5', '809-555-5555', 'aa@gmail.com', '2000-01-01', '2026-04-04 00:00:00', 'inactivo', 'Nota de clientes', '2026-04-04 04:29:11', '2026-04-04 13:02:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cobradores`
--

CREATE TABLE `cobradores` (
  `id` int(11) NOT NULL,
  `codigo` varchar(3) NOT NULL,
  `nombre_completo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_ingreso` date NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `usuario_id` int(11) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `cobradores`
--

INSERT INTO `cobradores` (`id`, `codigo`, `nombre_completo`, `descripcion`, `fecha_ingreso`, `estado`, `usuario_id`, `telefono`, `email`, `created_at`, `updated_at`) VALUES
(1, '001', 'Cobrador', '', '2024-11-19', 'activo', 3, NULL, NULL, '2024-11-19 18:41:01', '2026-03-29 06:01:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cobrador_facturas_autorizadas`
--

CREATE TABLE `cobrador_facturas_autorizadas` (
  `id` int(11) NOT NULL,
  `cobrador_id` int(11) NOT NULL,
  `factura_id` int(11) NOT NULL,
  `autorizado_por` int(11) NOT NULL,
  `fecha_autorizacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` datetime DEFAULT NULL,
  `estado` enum('activa','usada','expirada') NOT NULL DEFAULT 'activa',
  `motivo` text DEFAULT NULL,
  `impresa` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_impresion` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cobrador_mensajes`
--

CREATE TABLE `cobrador_mensajes` (
  `id` int(11) NOT NULL,
  `cobrador_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `asunto` varchar(150) NOT NULL,
  `mensaje` text NOT NULL,
  `prioridad` enum('normal','urgente','informativo') NOT NULL DEFAULT 'normal',
  `leido` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_envio` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_leido` datetime DEFAULT NULL,
  `cliente_visita_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `cobrador_mensajes`
--

INSERT INTO `cobrador_mensajes` (`id`, `cobrador_id`, `usuario_id`, `asunto`, `mensaje`, `prioridad`, `leido`, `fecha_envio`, `fecha_leido`, `cliente_visita_id`, `created_at`) VALUES
(1, 1, 1, 'Bienvenido al Portal del Cobrador', 'Hola Cobrador,\n\nTu portal de cobrador ha sido activado. Desde aquí podrás ver tus clientes asignados, revisar tus facturas pendientes, planear tu ruta diaria e imprimir comprobantes desde tu celular.\n\n¡Mucho éxito en tus cobros!', 'informativo', 1, '2026-03-29 06:01:46', '2026-03-30 22:19:31', NULL, '2026-03-29 06:01:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cobrador_rutas`
--

CREATE TABLE `cobrador_rutas` (
  `id` int(11) NOT NULL,
  `cobrador_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 0,
  `notas_ruta` varchar(255) DEFAULT NULL,
  `fecha` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `cobrador_rutas`
--

INSERT INTO `cobrador_rutas` (`id`, `cobrador_id`, `cliente_id`, `orden`, `notas_ruta`, `fecha`, `created_at`, `updated_at`) VALUES
(26, 1, 18, 0, NULL, '2026-04-02', '2026-04-03 03:57:08', '2026-04-03 03:57:08'),
(27, 1, 20, 1, NULL, '2026-04-02', '2026-04-03 03:57:08', '2026-04-03 03:57:08'),
(28, 1, 19, 2, NULL, '2026-04-02', '2026-04-03 03:57:08', '2026-04-03 03:57:08'),
(51, 1, 29, 0, NULL, '2026-04-03', '2026-04-04 03:04:55', '2026-04-04 03:04:55'),
(52, 1, 2, 1, NULL, '2026-04-03', '2026-04-04 03:04:55', '2026-04-04 03:04:55'),
(53, 1, 25, 2, NULL, '2026-04-03', '2026-04-04 03:04:55', '2026-04-04 03:04:55'),
(54, 1, 24, 3, NULL, '2026-04-03', '2026-04-04 03:04:55', '2026-04-04 03:04:55'),
(55, 1, 26, 4, NULL, '2026-04-03', '2026-04-04 03:04:55', '2026-04-04 03:04:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cobrador_sesiones_log`
--

CREATE TABLE `cobrador_sesiones_log` (
  `id` int(11) NOT NULL,
  `cobrador_id` int(11) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `accion` enum('login','logout','login_fallido') NOT NULL DEFAULT 'login',
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `cobrador_sesiones_log`
--

INSERT INTO `cobrador_sesiones_log` (`id`, `cobrador_id`, `ip_address`, `user_agent`, `accion`, `fecha_hora`) VALUES
(1, 1, '66.98.16.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'logout', '2026-04-01 23:18:44'),
(2, 1, '66.98.16.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'logout', '2026-04-01 23:21:18'),
(3, 1, '66.98.16.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'logout', '2026-04-03 22:22:14'),
(4, 1, '66.98.16.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'logout', '2026-04-03 22:29:28'),
(5, 1, '66.98.16.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'logout', '2026-04-03 22:54:52'),
(6, 1, '66.98.16.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'logout', '2026-04-03 23:05:49'),
(7, 1, '172.111.36.78', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1', 'logout', '2026-04-04 00:00:19'),
(8, 1, '66.98.16.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'logout', '2026-04-04 01:37:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion_sistema`
--

CREATE TABLE `configuracion_sistema` (
  `id` int(11) NOT NULL,
  `nombre_empresa` varchar(100) NOT NULL,
  `rif` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `celular` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `moneda` varchar(10) DEFAULT 'USD',
  `dias_gracia_pago` int(11) DEFAULT 5,
  `formato_factura` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `configuracion_sistema`
--

INSERT INTO `configuracion_sistema` (`id`, `nombre_empresa`, `rif`, `direccion`, `telefono`, `celular`, `email`, `logo_url`, `moneda`, `dias_gracia_pago`, `formato_factura`, `created_at`, `updated_at`) VALUES
(1, 'MM Lab Studio', '133-30417-1', 'Av. Aniana Vargas #31 módulo 2, Plaza Aniana Vargas, Bonao, R.D.', '829-296-9899', '849-495-3232', 'contacto@sefure.com', 'uploads/logo_1734567095.png', 'USD', 5, '', '2024-11-13 22:26:35', '2026-03-28 01:24:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contratos`
--

CREATE TABLE `contratos` (
  `id` int(11) NOT NULL,
  `numero_contrato` varchar(20) DEFAULT NULL,
  `cliente_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `monto_mensual` decimal(10,2) NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `dia_cobro` int(11) NOT NULL,
  `telefono1` varchar(15) DEFAULT NULL COMMENT 'Teléfono Principal del contrato',
  `telefono2` varchar(15) DEFAULT NULL COMMENT 'Teléfono 2 del contrato',
  `no_whatsapp` varchar(15) DEFAULT NULL COMMENT 'No. WhatsApp del contrato',
  `direccion` text DEFAULT NULL COMMENT 'Dirección del contrato',
  `cobrador_id` int(11) DEFAULT NULL COMMENT 'Cobrador asignado al contrato',
  `estado` enum('activo','cancelado','suspendido') DEFAULT 'activo',
  `vendedor_id` int(11) DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `ubicacion_lat` decimal(10,8) DEFAULT NULL COMMENT 'Latitud GPS del contrato',
  `ubicacion_lng` decimal(11,8) DEFAULT NULL COMMENT 'Longitud GPS del contrato',
  `ubicacion_ref` varchar(255) DEFAULT NULL COMMENT 'Referencia textual de la ubicación',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `contratos`
--

INSERT INTO `contratos` (`id`, `numero_contrato`, `cliente_id`, `plan_id`, `fecha_inicio`, `fecha_fin`, `monto_mensual`, `monto_total`, `dia_cobro`, `telefono1`, `telefono2`, `no_whatsapp`, `direccion`, `cobrador_id`, `estado`, `vendedor_id`, `notas`, `ubicacion_lat`, `ubicacion_lng`, `ubicacion_ref`, `created_at`, `updated_at`) VALUES
(2, '00002', 2, 1, '2024-01-20', '2026-04-20', 30.00, 360.00, 20, '809-223-1001', '849-223-1001', '809-223-1001', 'Calle El Conde #45, Zona Colonial, Santo Domingo, D.N.', 1, 'activo', 2, NULL, 18.49120000, -69.92780000, 'Zona Colonial, Santo Domingo, D.N.', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(3, '00003', 3, 1, '2024-02-01', '2025-02-01', 30.00, 360.00, 1, '809-581-2002', '849-581-2002', '809-581-2002', 'Av. Juan Pablo Duarte #122, Santiago de los Caballeros', 1, 'activo', 1, NULL, 19.45620000, -70.69150000, 'Av. Juan Pablo Duarte, Santiago', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(4, '00004', 4, 1, '2024-02-15', '2025-02-15', 30.00, 360.00, 15, '809-242-3003', NULL, '809-242-3003', 'Calle Restauración #78, Concepción de La Vega', 1, 'activo', 2, NULL, 19.22650000, -70.52340000, 'Calle Restauración, Concepción de La Vega', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(5, '00005', 5, 1, '2024-03-01', '2026-04-01', 30.00, 360.00, 1, '829-686-4004', '809-686-4004', '829-686-4004', 'Av. Circunvalación #55, San Pedro de Macorís', 1, 'activo', 2, NULL, 18.46750000, -69.30980000, 'Av. Circunvalación, San Pedro de Macorís', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(6, '00006', 6, 1, '2024-03-15', '2025-03-15', 30.00, 360.00, 15, '809-261-5005', '849-261-5005', '809-261-5005', 'Calle Beller #90, Puerto Plata', 1, 'activo', 1, NULL, 19.79810000, -70.68320000, 'Calle Beller, Puerto Plata', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(7, '00007', 7, 1, '2024-03-25', '2025-03-25', 30.00, 360.00, 25, '809-524-6006', NULL, '809-524-6006', 'Calle Anacaona #33, Barahona', 1, 'activo', 1, NULL, 18.21430000, -71.09560000, 'Calle Anacaona, Barahona', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(8, '00008', 8, 1, '2024-04-10', '2025-04-10', 30.00, 360.00, 10, '829-472-7007', '849-472-7007', '829-472-7007', 'Av. Constitución #200, San Cristóbal', 1, 'activo', 1, '', 18.47520041, -69.82532501, 'Av. Constitución, San Cristóbal', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(9, '00009', 9, 1, '2024-04-25', '2025-04-25', 30.00, 360.00, 25, '809-556-8008', NULL, '809-556-8008', 'Calle Altagracia #15, La Romana', 1, 'activo', 2, NULL, 18.43200000, -68.96830000, 'Calle Altagracia, La Romana', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(10, '00010', 10, 2, '2024-05-15', '2025-05-15', 50.00, 600.00, 15, '809-578-9009', '849-578-9009', '809-578-9009', 'Calle Duarte #67, Moca, Espaillat', 1, 'activo', 1, NULL, 19.39900000, -70.51650000, 'Calle Duarte, Moca, Espaillat', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(11, '00011', 11, 2, '2024-06-01', '2025-06-01', 50.00, 600.00, 1, '829-588-0010', '809-588-0010', '829-588-0010', 'Av. 27 de Febrero #88, San Francisco de Macorís', 1, 'activo', 1, NULL, 19.30300000, -70.25200000, 'Av. 27 de Febrero, San Francisco de Macorís', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(12, '00012', 12, 2, '2024-06-20', '2025-06-20', 50.00, 600.00, 20, '809-296-1011', NULL, '809-296-1011', 'Calle Sánchez #102, Bonao, Monseñor Nouel', 1, 'activo', 2, '', 18.47622436, -69.82476711, 'Calle Sánchez, Bonao, Monseñor Nouel', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(13, '00013', 13, 2, '2024-07-01', '2025-07-01', 50.00, 600.00, 1, '849-521-2012', '809-521-2012', '849-521-2012', 'Calle Mella #55, Azua de Compostela', 1, 'activo', 1, NULL, 18.45860000, -70.73000000, 'Calle Mella, Azua de Compostela', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(14, '00014', 14, 2, '2024-07-15', '2025-07-15', 50.00, 600.00, 15, '809-522-3013', '829-522-3013', '809-522-3013', 'Av. Independencia #77, Baní, Peravia', 1, 'activo', 1, '', 18.46681528, -69.81854439, 'Av. Independencia, Baní, Peravia', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(15, '00015', 15, 2, '2024-08-01', '2025-08-01', 50.00, 600.00, 1, '809-554-4014', NULL, '809-554-4014', 'Calle El Seibo #22, Higüey, La Altagracia', 1, 'activo', 2, NULL, 18.62240000, -68.70190000, 'Calle El Seibo, Higüey, La Altagracia', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(16, '00016', 16, 2, '2024-08-20', '2025-08-20', 50.00, 600.00, 20, '829-579-5015', '849-579-5015', '829-579-5015', 'Calle Padre Billini #44, Monte Cristi', 1, 'activo', 1, NULL, 19.86570000, -71.64510000, 'Calle Padre Billini, Monte Cristi', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(17, '00017', 17, 3, '2024-09-05', '2025-09-05', 75.00, 900.00, 5, '809-584-6016', '849-584-6016', '809-584-6016', 'Av. 30 de Marzo #150, Nagua, María Trinidad Sánchez', 1, 'activo', 2, NULL, 19.38670000, -69.84080000, 'Av. 30 de Marzo, Nagua, María Trinidad Sánchez', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(18, '00018', 18, 3, '2024-09-25', '2025-09-25', 75.00, 900.00, 25, '809-553-7017', NULL, '809-553-7017', 'Calle Nueva #88, Hato Mayor del Rey, El Seibo', 1, 'activo', 2, '', 18.47024405, -69.83495951, 'Calle Nueva, Hato Mayor del Rey, El Seibo', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(19, '00019', 19, 3, '2024-10-10', '2025-10-10', 75.00, 900.00, 10, '849-585-8018', '809-585-8018', '849-585-8018', 'Av. Libertad #33, Cotuí, Sánchez Ramírez', 1, 'activo', 1, '', 18.47181117, -69.83133316, 'Av. Libertad, Cotuí, Sánchez Ramírez', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(20, '00020', 20, 3, '2024-10-25', '2025-10-25', 75.00, 900.00, 25, '809-583-9019', '829-583-9019', '809-583-9019', 'Calle del Sol #200, Santiago de los Caballeros', 1, 'activo', 2, '', 18.47874794, -69.82794285, 'Calle del Sol, Santiago de los Caballeros', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(21, '00021', 21, 3, '2024-11-10', '2025-11-10', 75.00, 900.00, 10, '809-227-0020', NULL, '809-227-0020', 'Av. Tiradentes #450, Naco, Santo Domingo, D.N.', 1, 'activo', 1, NULL, 18.50050000, -69.91650000, 'Av. Tiradentes, Naco, Santo Domingo, D.N.', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(22, '00022', 22, 4, '2024-11-25', '2025-11-25', 60.00, 720.00, 25, '849-556-1021', '809-556-1021', '849-556-1021', 'Calle Libertad #88, La Romana', 1, 'activo', 1, NULL, 18.43660000, -68.95750000, 'Calle Libertad, La Romana', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(23, '00023', 23, 4, '2024-12-10', '2026-04-10', 60.00, 720.00, 10, '809-582-2022', '849-582-2022', '809-582-2022', 'Av. Las Carreras #77, Santiago de los Caballeros', 1, 'activo', 2, NULL, 19.46540000, -70.67540000, 'Av. Las Carreras, Santiago de los Caballeros', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(24, '00024', 24, 4, '2024-12-25', '2025-12-25', 60.00, 720.00, 25, '809-596-3023', NULL, '809-596-3023', 'Calle Rosa Duarte #12, Los Minas, Santo Domingo Este', 1, 'activo', 1, '', 18.47469925, -69.84798431, 'Calle Rosa Duarte, Los Minas, Santo Domingo Este', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(25, '00025', 25, 5, '2025-01-20', '2026-01-20', 45.00, 540.00, 20, '809-247-4024', '829-247-4024', '809-247-4024', 'Calle Mella #30, Concepción de La Vega', 1, 'activo', 1, '', 18.48821233, -69.86000061, 'Calle Mella, Concepción de La Vega', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(26, '00026', 26, 5, '2025-02-05', '2026-02-05', 45.00, 540.00, 5, '849-526-5025', '809-526-5025', '849-526-5025', 'Calle Independencia #66, San Pedro de Macorís', 1, 'activo', 2, '', 18.47316522, -69.86643791, 'Calle Independencia, San Pedro de Macorís', '2026-04-02 03:14:27', '2026-04-04 01:43:23'),
(27, '00027', 2, 2, '2026-04-04', '2026-05-03', 600.00, 600.00, 4, '809-555-1', '809-555-2', '809-555-3', 'Calle 1era #999', 1, 'activo', 1, 'Notas', 18.46904008, -69.82682705, 'Casa De Color Azul', '2026-04-04 01:55:17', '2026-04-04 02:41:33'),
(28, '00028', 29, 2, '2026-04-04', '2026-05-03', 600.00, 600.00, 4, '809-555-1', '809-555-2', '809-555-3', 'direccion de contrato', 1, 'activo', 1, 'Nota de contrato', 18.48031499, -69.82747078, 'Referencia de contrato', '2026-04-04 02:59:15', '2026-04-04 02:59:15'),
(29, '00029', 30, 2, '2026-04-04', '2026-05-03', 1000.00, 1000.00, 5, '809-111-1111', '809-222-2222', '809-333-3333', 'Dirección de Contrato', 1, 'activo', 1, 'Nota de Contrato', 18.46853095, -69.82794285, 'Referencia de Contrato', '2026-04-04 04:33:26', '2026-04-04 05:28:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dependientes`
--

CREATE TABLE `dependientes` (
  `id` int(11) NOT NULL,
  `contrato_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `relacion` varchar(50) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `identificacion` varchar(20) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `fecha_registro` date NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `plan_id` int(11) NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `dependientes`
--

INSERT INTO `dependientes` (`id`, `contrato_id`, `nombre`, `apellidos`, `relacion`, `fecha_nacimiento`, `identificacion`, `telefono`, `fecha_registro`, `email`, `plan_id`, `estado`, `created_at`, `updated_at`) VALUES
(2, 10, 'Carmen Rosa', 'Martínez de Díaz', 'Esposa', '1982-05-20', '100-1234567-8', '809-578-9101', '2024-05-15', 'crmdiaz@gmail.com', 2, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(3, 10, 'Francisco Javier', 'Díaz Martínez', 'Hijo', '2010-09-15', '100-2345678-9', NULL, '2024-05-15', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(4, 11, 'Roberto Manuel', 'Méndez Castillo', 'Esposo', '1985-03-10', '101-3456789-1', '829-588-0110', '2024-06-01', 'rmendez@gmail.com', 2, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(5, 11, 'Elena Gabriela', 'Méndez Taveras', 'Hija', '2012-07-22', '101-4567890-2', NULL, '2024-06-01', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(6, 12, 'Yolanda María', 'Cruz Sánchez', 'Esposa', '1978-11-30', '102-5678901-3', '809-296-1115', '2024-06-20', 'ymcruz@gmail.com', 2, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(7, 12, 'Miguel Ángel', 'Polanco Cruz Jr', 'Hijo', '2008-04-05', '102-6789012-4', NULL, '2024-06-20', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(8, 12, 'Ana Patricia', 'Polanco Cruz', 'Hija', '2012-01-18', '102-7890123-5', NULL, '2024-06-20', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(9, 13, 'Pedro Antonio', 'Soto Marmolejos', 'Esposo', '1989-08-14', '103-8901234-6', '849-521-2118', '2024-07-01', 'pasoto@gmail.com', 2, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(10, 14, 'María Eugenia', 'Pimentel de Ureña', 'Esposa', '1985-02-28', '104-9012345-7', '809-522-3119', '2024-07-15', 'mepimentel@gmail.com', 2, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(11, 14, 'Carlos Manuel', 'Ureña Pimentel Jr', 'Hijo', '2015-06-10', '104-0123456-8', NULL, '2024-07-15', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(12, 15, 'Antonio José', 'Peña Rosario', 'Esposo', '1988-09-25', '105-1234567-9', '809-554-4121', '2024-08-01', 'ajpena@gmail.com', 2, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(13, 15, 'Lucía Fernanda', 'Peña Núñez', 'Hija', '2014-03-07', '105-2345678-1', NULL, '2024-08-01', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(14, 16, 'Mercedes Alicia', 'Ramírez de Castillo', 'Esposa', '1981-07-19', '106-3456789-2', '829-579-5123', '2024-08-20', 'maramirez@gmail.com', 2, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(15, 16, 'José David', 'Castillo Ramírez Jr', 'Hijo', '2009-12-01', '106-4567890-3', NULL, '2024-08-20', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(16, 16, 'María José', 'Castillo Ramírez', 'Hija', '2013-05-15', '106-5678901-4', NULL, '2024-08-20', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(17, 17, 'Ricardo Antonio', 'Féliz Taveras', 'Esposo', '1975-04-22', '107-6789012-5', '809-584-6126', '2024-09-05', 'rafeliz@gmail.com', 3, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(18, 17, 'Ricardo Junior', 'Féliz Ogando', 'Hijo', '2005-08-14', '107-7890123-6', '849-584-6127', '2024-09-05', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(19, 17, 'Yanira Beatriz', 'Féliz Ogando', 'Hija', '2008-11-30', '107-8901234-7', NULL, '2024-09-05', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(20, 18, 'Carmen Luisa', 'Lara de Herrera', 'Esposa', '1987-06-18', '108-9012345-8', '809-553-7119', '2024-09-25', 'cllara@gmail.com', 3, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(21, 18, 'Antonio Ramón', 'Herrera Lara Jr', 'Hijo', '2010-03-25', '108-0123456-9', NULL, '2024-09-25', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(22, 19, 'Eduardo José', 'Álvarez Montero', 'Esposo', '1991-10-05', '109-1234567-1', '849-585-8121', '2024-10-10', 'ejalvarez@gmail.com', 3, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(23, 19, 'Dolores Miledys', 'Álvarez Acosta', 'Hija', '2016-02-14', '109-2345678-2', NULL, '2024-10-10', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(24, 19, 'Eduardo José', 'Álvarez Acosta Jr', 'Hijo', '2019-07-30', '109-3456789-3', NULL, '2024-10-10', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(25, 20, 'Isabel María', 'Florentino de Salcedo', 'Esposa', '1983-04-12', '110-4567890-4', '809-583-9124', '2024-10-25', 'imflorentino@gmail.com', 3, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(26, 20, 'Héctor Rafael', 'Salcedo Florentino Jr', 'Hijo', '2007-09-08', '110-5678901-5', '849-583-9125', '2024-10-25', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(27, 20, 'Isabel María', 'Salcedo Florentino', 'Hija', '2011-12-20', '110-6789012-6', NULL, '2024-10-25', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(28, 21, 'Felipe Antonio', 'Torres Hernández', 'Esposo', '1970-01-15', '111-7890123-7', '809-227-0127', '2024-11-10', 'fatorres@gmail.com', 3, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(29, 21, 'Felipe Manuel', 'Torres Beltre', 'Hijo', '2002-06-22', '111-8901234-8', '849-227-0128', '2024-11-10', 'fmtorres@gmail.com', 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(30, 22, 'Altagracia María', 'Quezada de Fermín', 'Esposa', '1991-03-18', '112-9012345-9', '849-556-1129', '2024-11-25', 'amquezada@gmail.com', 4, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(31, 22, 'Víctor Manuel', 'Fermín Quezada Jr', 'Hijo', '2015-10-25', '112-0123456-1', NULL, '2024-11-25', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(32, 23, 'Ramón Antonio', 'Montero García', 'Esposo', '1984-07-09', '113-1234567-2', '809-582-2131', '2024-12-10', 'ramontero@gmail.com', 4, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(33, 23, 'Sonia Gabriela', 'Montero Cabral', 'Hija', '2012-04-17', '113-2345678-3', NULL, '2024-12-10', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(34, 24, 'Patricia Elena', 'Batista de Suero', 'Esposa', '1976-08-23', '114-3456789-4', '809-596-3133', '2024-12-25', 'pebatista@gmail.com', 4, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(35, 24, 'Rafael Augusto', 'Suero Batista Jr', 'Hijo', '2003-11-14', '114-4567890-5', '849-596-3134', '2024-12-25', 'rasueroJr@gmail.com', 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(36, 24, 'María Patricia', 'Suero Batista', 'Hija', '2006-03-28', '114-5678901-6', NULL, '2024-12-25', NULL, 1, 'activo', '2026-04-02 03:14:27', '2026-04-02 03:14:27'),
(37, 28, 'Jomil', 'Peralta', 'Hija', '2000-01-01', '001-4567894-5', '', '2026-04-04', '', 2, 'activo', '2026-04-04 03:00:56', '2026-04-04 03:00:56'),
(38, 28, 'Marie Camil', 'Galvez', 'Hija', '2014-04-09', '', '', '2026-04-04', '', 2, 'activo', '2026-04-04 03:01:21', '2026-04-04 03:01:21'),
(39, 29, 'RRR', 'RRR', 'Hijo', '2000-01-01', '222-2222222-2', '', '2026-04-04', '', 2, 'activo', '2026-04-04 04:34:26', '2026-04-04 04:34:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuentos`
--

CREATE TABLE `descuentos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo` enum('porcentaje','monto_fijo') NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `descuentos`
--

INSERT INTO `descuentos` (`id`, `nombre`, `descripcion`, `tipo`, `valor`, `fecha_inicio`, `fecha_fin`, `estado`, `created_at`, `updated_at`) VALUES
(1, 'Descuento Pronto Pago', 'Descuento por pago anticipado', 'porcentaje', 10.00, '2024-01-01', '2024-12-31', 'activo', '2024-11-13 22:26:35', '2024-11-13 22:26:35'),
(2, 'Descuento Familiar', 'Descuento para planes familiares', 'porcentaje', 15.00, '2024-01-01', '2024-12-31', 'activo', '2024-11-13 22:26:35', '2024-11-13 22:26:35'),
(3, 'Descuento Especial', 'Descuento de temporada', 'monto_fijo', 25.00, '2024-03-01', '2024-03-31', 'activo', '2024-11-13 22:26:35', '2024-11-13 22:26:35'),
(4, 'Descuento Adulto Mayor', 'Descuento para mayores de 60', 'porcentaje', 20.00, '2024-01-01', '2024-12-31', 'activo', '2024-11-13 22:26:35', '2024-11-13 22:26:35'),
(5, 'Descuento Empleado', 'Descuento para empleados', 'porcentaje', 25.00, '2024-01-01', '2024-12-31', 'activo', '2024-11-13 22:26:35', '2024-11-13 22:26:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuentos_aplicados`
--

CREATE TABLE `descuentos_aplicados` (
  `id` int(11) NOT NULL,
  `contrato_id` int(11) NOT NULL,
  `descuento_id` int(11) NOT NULL,
  `fecha_aplicacion` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int(11) NOT NULL,
  `numero_factura` varchar(7) NOT NULL,
  `cuota` int(11) NOT NULL,
  `mes_factura` varchar(7) NOT NULL,
  `contrato_id` int(11) NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `monto_pendiente` decimal(10,2) DEFAULT 0.00,
  `estado` enum('pendiente','pagada','vencida','anulada','incompleta') DEFAULT 'pendiente',
  `notas` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `cantidad_dependientes` int(11) DEFAULT 0,
  `tiene_geriatrico` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`id`, `numero_factura`, `cuota`, `mes_factura`, `contrato_id`, `fecha_emision`, `fecha_vencimiento`, `monto`, `monto_pendiente`, `estado`, `notas`, `created_at`, `updated_at`, `cantidad_dependientes`, `tiene_geriatrico`) VALUES
(1, '0000001', 1, '04/2026', 2, '2026-04-01', '2026-04-20', 360.00, 0.00, 'pagada', NULL, '2026-04-02 03:15:34', '2026-04-02 03:21:55', 0, 0),
(2, '0000002', 1, '04/2026', 3, '2026-04-01', '2026-04-01', 360.00, 0.00, 'vencida', NULL, '2026-04-02 03:15:34', '2026-04-03 05:20:51', 0, 0),
(3, '0000003', 1, '04/2026', 4, '2026-04-01', '2026-04-15', 360.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(4, '0000004', 1, '04/2026', 5, '2026-04-01', '2026-04-01', 360.00, 0.00, 'pagada', NULL, '2026-04-02 03:15:34', '2026-04-02 03:22:07', 0, 0),
(5, '0000005', 1, '04/2026', 6, '2026-04-01', '2026-04-15', 360.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(6, '0000006', 1, '04/2026', 7, '2026-04-01', '2026-04-25', 360.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(7, '0000007', 1, '04/2026', 8, '2026-04-01', '2026-04-10', 360.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(8, '0000008', 1, '04/2026', 9, '2026-04-01', '2026-04-25', 360.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(9, '0000009', 1, '04/2026', 10, '2026-04-01', '2026-04-15', 600.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(10, '0000010', 1, '04/2026', 11, '2026-04-01', '2026-04-01', 600.00, 0.00, 'vencida', NULL, '2026-04-02 03:15:34', '2026-04-03 05:20:51', 0, 0),
(11, '0000011', 1, '04/2026', 12, '2026-04-01', '2026-04-20', 600.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(12, '0000012', 1, '04/2026', 13, '2026-04-01', '2026-04-01', 600.00, 0.00, 'vencida', NULL, '2026-04-02 03:15:34', '2026-04-03 05:20:51', 0, 0),
(13, '0000013', 1, '04/2026', 14, '2026-04-01', '2026-04-15', 600.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(14, '0000014', 1, '04/2026', 15, '2026-04-01', '2026-04-01', 600.00, 0.00, 'vencida', NULL, '2026-04-02 03:15:34', '2026-04-03 05:20:51', 0, 0),
(15, '0000015', 1, '04/2026', 16, '2026-04-01', '2026-04-20', 600.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(16, '0000016', 1, '04/2026', 17, '2026-04-01', '2026-04-05', 900.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(17, '0000017', 1, '04/2026', 18, '2026-04-01', '2026-04-25', 900.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(18, '0000018', 1, '04/2026', 19, '2026-04-01', '2026-04-10', 900.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(19, '0000019', 1, '04/2026', 20, '2026-04-01', '2026-04-25', 900.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(20, '0000020', 1, '04/2026', 21, '2026-04-01', '2026-04-10', 900.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(21, '0000021', 1, '04/2026', 22, '2026-04-01', '2026-04-25', 720.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(22, '0000022', 1, '04/2026', 23, '2026-04-01', '2026-04-10', 720.00, 0.00, 'pagada', NULL, '2026-04-02 03:15:34', '2026-04-02 03:22:29', 0, 0),
(23, '0000023', 1, '04/2026', 24, '2026-04-01', '2026-04-25', 720.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(24, '0000024', 1, '04/2026', 25, '2026-04-01', '2026-04-20', 540.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(25, '0000025', 1, '04/2026', 26, '2026-04-01', '2026-04-05', 540.00, 0.00, 'pendiente', NULL, '2026-04-02 03:15:34', '2026-04-02 03:15:34', 0, 0),
(26, '0000026', 2, '05/2026', 2, '2026-05-01', '2026-05-20', 360.00, 0.00, 'pendiente', NULL, '2026-04-04 01:55:47', '2026-04-04 01:55:47', 0, 0),
(27, '0000027', 2, '05/2026', 5, '2026-05-01', '2026-05-01', 360.00, 0.00, 'pendiente', NULL, '2026-04-04 01:55:47', '2026-04-04 01:55:47', 0, 0),
(28, '0000028', 2, '05/2026', 23, '2026-05-01', '2026-05-10', 720.00, 0.00, 'pendiente', NULL, '2026-04-04 01:55:47', '2026-04-04 01:55:47', 0, 0),
(29, '0000029', 1, '04/2026', 27, '2026-04-03', '2026-04-04', 600.00, 0.00, 'pendiente', NULL, '2026-04-04 01:55:47', '2026-04-04 01:55:47', 0, 0),
(30, '0000030', 1, '04/2026', 28, '2026-04-03', '2026-04-04', 600.00, 0.00, 'pendiente', NULL, '2026-04-04 03:02:24', '2026-04-04 03:02:24', 0, 0),
(31, '0000031', 1, '04/2026', 29, '2026-04-04', '2026-04-05', 1000.00, 0.00, 'pendiente', NULL, '2026-04-04 04:34:47', '2026-04-04 04:34:47', 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `generacion_facturas_lock`
--

CREATE TABLE `generacion_facturas_lock` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `timestamp` datetime NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `generacion_facturas_lock`
--

INSERT INTO `generacion_facturas_lock` (`id`, `usuario_id`, `timestamp`, `estado`) VALUES
(1, 1, '2026-04-01 23:15:34', 'inactivo'),
(2, 1, '2026-04-03 21:55:47', 'inactivo'),
(3, 1, '2026-04-03 23:02:24', 'inactivo'),
(4, 1, '2026-04-04 00:34:47', 'inactivo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `generacion_lote_lock`
--

CREATE TABLE `generacion_lote_lock` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `timestamp` datetime NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_cambios_plan`
--

CREATE TABLE `historial_cambios_plan` (
  `id` int(11) NOT NULL,
  `contrato_id` int(11) NOT NULL,
  `plan_anterior_id` int(11) NOT NULL,
  `plan_nuevo_id` int(11) NOT NULL,
  `fecha_cambio` datetime NOT NULL,
  `motivo` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_cambios_plan_dependientes`
--

CREATE TABLE `historial_cambios_plan_dependientes` (
  `id` int(11) NOT NULL,
  `dependiente_id` int(11) NOT NULL,
  `plan_anterior_id` int(11) NOT NULL,
  `plan_nuevo_id` int(11) NOT NULL,
  `fecha_cambio` datetime NOT NULL,
  `motivo` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_reasignaciones`
--

CREATE TABLE `historial_reasignaciones` (
  `id` int(11) NOT NULL,
  `asignacion_id` int(11) NOT NULL,
  `cobrador_anterior_id` int(11) NOT NULL,
  `fecha_anterior` date NOT NULL,
  `cobrador_nuevo_id` int(11) NOT NULL,
  `fecha_nueva` date NOT NULL,
  `motivo` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs_sistema`
--

CREATE TABLE `logs_sistema` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `accion` varchar(100) NOT NULL,
  `tabla_afectada` varchar(50) DEFAULT NULL,
  `registro_id` int(11) DEFAULT NULL,
  `detalles` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `logs_sistema`
--

INSERT INTO `logs_sistema` (`id`, `usuario_id`, `accion`, `tabla_afectada`, `registro_id`, `detalles`, `ip_address`, `created_at`) VALUES
(1, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-02 03:17:58'),
(2, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-02 03:23:15'),
(3, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-03 03:56:05'),
(4, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-04 01:57:57'),
(5, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-04 02:29:11'),
(6, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-04 02:29:54'),
(7, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-04 02:30:00'),
(8, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-04 03:02:55'),
(9, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-04 05:30:28'),
(10, 1, 'logout', NULL, NULL, 'Cierre de sesión exitoso', '66.98.16.139', '2026-04-04 05:40:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` int(11) NOT NULL,
  `factura_id` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` datetime NOT NULL,
  `metodo_pago` enum('efectivo','transferencia','cheque') NOT NULL,
  `referencia_pago` varchar(50) DEFAULT NULL,
  `cobrador_id` int(11) DEFAULT NULL,
  `estado` enum('procesado','anulado') DEFAULT 'procesado',
  `notas` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipo_pago` enum('total','abono') DEFAULT 'total'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `factura_id`, `monto`, `fecha_pago`, `metodo_pago`, `referencia_pago`, `cobrador_id`, `estado`, `notas`, `created_at`, `tipo_pago`) VALUES
(1, 1, 360.00, '2026-04-01 23:21:55', 'efectivo', '', 1, 'procesado', '', '2026-04-02 03:21:55', 'total'),
(2, 4, 360.00, '2026-04-01 23:22:07', 'efectivo', '', 1, 'procesado', '', '2026-04-02 03:22:07', 'total'),
(3, 22, 720.00, '2026-04-01 23:22:29', 'efectivo', '', 1, 'procesado', '', '2026-04-02 03:22:29', 'total');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `id` int(11) NOT NULL,
  `codigo` varchar(20) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_base` decimal(10,2) NOT NULL,
  `cobertura_maxima` decimal(10,2) DEFAULT NULL,
  `edad_minima` int(11) DEFAULT NULL,
  `edad_maxima` int(11) DEFAULT NULL,
  `periodo_carencia` int(11) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id`, `codigo`, `nombre`, `descripcion`, `precio_base`, `cobertura_maxima`, `edad_minima`, `edad_maxima`, `periodo_carencia`, `estado`, `created_at`, `updated_at`) VALUES
(1, 'PLAN001', 'Basico', 'Plan de cobertura básica', 0.00, 25000.00, 1, 65, 180, 'activo', '2024-11-13 22:26:35', '2025-01-04 02:34:17'),
(2, 'PLAN002', 'Familiar', 'Plan de cobertura familiar', 0.00, 35000.00, 1, 65, 180, 'activo', '2024-11-13 22:26:35', '2025-01-04 02:34:58'),
(3, 'PLAN003', 'Premium', 'Plan de cobertura premium', 0.00, 50000.00, 1, 65, 180, 'activo', '2024-11-13 22:26:35', '2025-01-04 02:35:04'),
(4, 'PLAN004', 'Especial', 'Plan de cobertura Especial', 0.00, 43000.00, 1, 65, 180, 'activo', '2024-11-13 22:26:35', '2025-01-04 02:35:09'),
(5, 'PLAN005', 'Geriátrico', 'Plan especial para adultos mayores', 0.00, 25000.00, 65, 75, 180, 'activo', '2024-11-13 22:26:35', '2025-01-04 02:34:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `referencias_clientes`
--

CREATE TABLE `referencias_clientes` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `relacion` varchar(50) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `direccion` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reportes_auditoria`
--

CREATE TABLE `reportes_auditoria` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `accion` varchar(50) NOT NULL,
  `detalles` text NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `fecha_hora` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reportes_historial`
--

CREATE TABLE `reportes_historial` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `tipo_reporte` varchar(50) NOT NULL,
  `parametros` text NOT NULL,
  `fecha_generacion` datetime NOT NULL,
  `tiempo_generacion` decimal(10,2) DEFAULT NULL,
  `registros_procesados` int(11) DEFAULT NULL,
  `estado` enum('completado','error','en_proceso') DEFAULT 'en_proceso',
  `mensaje_error` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reportes_notas`
--

CREATE TABLE `reportes_notas` (
  `id` int(11) NOT NULL,
  `reporte_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `nota` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `supervisor_sesiones_log`
--

CREATE TABLE `supervisor_sesiones_log` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `accion` enum('login','logout') DEFAULT 'login',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `rol` enum('admin','vendedor','cobrador','supervisor') NOT NULL DEFAULT 'cobrador',
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `ultimo_acceso` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `password`, `nombre`, `email`, `rol`, `estado`, `ultimo_acceso`, `created_at`, `updated_at`) VALUES
(1, 'orthiis', '$2y$10$MtBzI1F931yaEFKAZddVMui.KML5Nw2VBGgXrBj9bZ0bbl85bdoJa', 'Miguel Angel', 'orthiis1982@gmail.com', 'admin', 'activo', '2026-04-04 08:58:38', '2024-11-12 23:22:51', '2026-04-04 12:58:38'),
(2, 'vendedor1', '$2y$10$MtBzI1F931yaEFKAZddVMui.KML5Nw2VBGgXrBj9bZ0bbl85bdoJa', 'Vendedor', 'vendedor@mmlabstudio.com', 'vendedor', 'activo', '2026-04-01 18:17:44', '2024-11-13 22:26:35', '2026-04-01 18:17:44'),
(3, 'cobrador1', '$2y$10$MtBzI1F931yaEFKAZddVMui.KML5Nw2VBGgXrBj9bZ0bbl85bdoJa', 'Cobrador', 'cobrador@mmlabstudio.com', 'cobrador', 'activo', '2026-04-04 01:40:59', '2024-11-13 22:26:35', '2026-04-04 05:40:59'),
(4, 'supervisor1', '$2y$10$vodm2j5NjOher66uC/hMlOguwhBQlIEBeRlszEcqOLktnbfXGw6SG', 'Supervisor', 'supervisor@mmlabstudio.com', 'supervisor', 'activo', '2026-03-31 14:01:58', '2024-11-13 22:26:35', '2026-03-31 14:01:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedores`
--

CREATE TABLE `vendedores` (
  `id` int(11) NOT NULL,
  `codigo` varchar(3) NOT NULL,
  `nombre_completo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_ingreso` date NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `vendedores`
--

INSERT INTO `vendedores` (`id`, `codigo`, `nombre_completo`, `descripcion`, `fecha_ingreso`, `estado`, `created_at`, `updated_at`) VALUES
(1, '001', 'Vendedor1', 'Vendedor1', '2024-11-19', 'activo', '2024-11-19 18:40:20', '2025-01-01 19:03:43'),
(2, '002', 'Vendedor2', 'Vendedor2', '2025-02-07', 'activo', '2025-02-07 21:56:45', '2025-02-07 21:56:45'),
(3, '003', 'Vendedor3', 'Vendedor3', '2025-02-12', 'activo', '2025-02-12 08:32:40', '2025-02-12 08:32:40');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedor_sesiones_log`
--

CREATE TABLE `vendedor_sesiones_log` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `accion` enum('login','logout') DEFAULT 'login',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asignaciones_facturas`
--
ALTER TABLE `asignaciones_facturas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `factura_id` (`factura_id`),
  ADD KEY `cobrador_id` (`cobrador_id`),
  ADD KEY `idx_af_cobrador_estado` (`cobrador_id`,`estado`),
  ADD KEY `idx_cobrador_estado` (`cobrador_id`,`estado`);

--
-- Indices de la tabla `beneficiarios`
--
ALTER TABLE `beneficiarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contrato_id` (`contrato_id`);

--
-- Indices de la tabla `beneficios_planes`
--
ALTER TABLE `beneficios_planes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD UNIQUE KEY `cedula` (`cedula`);

--
-- Indices de la tabla `cobradores`
--
ALTER TABLE `cobradores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `fk_cobrador_usuario` (`usuario_id`),
  ADD KEY `idx_cobradores_usuario_id` (`usuario_id`);

--
-- Indices de la tabla `cobrador_facturas_autorizadas`
--
ALTER TABLE `cobrador_facturas_autorizadas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_cobrador_factura` (`cobrador_id`,`factura_id`),
  ADD KEY `idx_cobrador_estado` (`cobrador_id`,`estado`),
  ADD KEY `idx_factura_id` (`factura_id`),
  ADD KEY `idx_autorizado_por` (`autorizado_por`);

--
-- Indices de la tabla `cobrador_mensajes`
--
ALTER TABLE `cobrador_mensajes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cobrador_leido` (`cobrador_id`,`leido`),
  ADD KEY `idx_usuario_id` (`usuario_id`),
  ADD KEY `idx_fecha_envio` (`fecha_envio`);

--
-- Indices de la tabla `cobrador_rutas`
--
ALTER TABLE `cobrador_rutas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_cobrador_cliente_fecha` (`cobrador_id`,`cliente_id`,`fecha`),
  ADD KEY `idx_cobrador_fecha` (`cobrador_id`,`fecha`),
  ADD KEY `fk_ruta_cliente` (`cliente_id`);

--
-- Indices de la tabla `cobrador_sesiones_log`
--
ALTER TABLE `cobrador_sesiones_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cobrador_fecha` (`cobrador_id`,`fecha_hora`);

--
-- Indices de la tabla `configuracion_sistema`
--
ALTER TABLE `configuracion_sistema`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_contrato` (`numero_contrato`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `plan_id` (`plan_id`),
  ADD KEY `vendedor_id` (`vendedor_id`),
  ADD KEY `idx_contratos_ubicacion` (`ubicacion_lat`,`ubicacion_lng`),
  ADD KEY `idx_contratos_cobrador_id` (`cobrador_id`);

--
-- Indices de la tabla `dependientes`
--
ALTER TABLE `dependientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `identificacion` (`identificacion`),
  ADD KEY `plan_id` (`plan_id`),
  ADD KEY `contrato_id` (`contrato_id`);

--
-- Indices de la tabla `descuentos`
--
ALTER TABLE `descuentos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `descuentos_aplicados`
--
ALTER TABLE `descuentos_aplicados`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contrato_id` (`contrato_id`),
  ADD KEY `descuento_id` (`descuento_id`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_contrato_mes` (`contrato_id`,`mes_factura`),
  ADD UNIQUE KEY `idx_contrato_cuota` (`contrato_id`,`cuota`),
  ADD UNIQUE KEY `numero_factura` (`numero_factura`),
  ADD UNIQUE KEY `numero_factura_unique` (`numero_factura`),
  ADD KEY `contrato_id` (`contrato_id`),
  ADD KEY `idx_estado_facturas` (`estado`),
  ADD KEY `idx_fecha_emision` (`fecha_emision`),
  ADD KEY `idx_factura_estado` (`estado`),
  ADD KEY `idx_contrato_estado_id` (`contrato_id`,`estado`,`id`),
  ADD KEY `idx_f_vencimiento` (`fecha_vencimiento`),
  ADD KEY `idx_f_estado_contrato` (`estado`,`contrato_id`);

--
-- Indices de la tabla `generacion_facturas_lock`
--
ALTER TABLE `generacion_facturas_lock`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `generacion_lote_lock`
--
ALTER TABLE `generacion_lote_lock`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `historial_cambios_plan`
--
ALTER TABLE `historial_cambios_plan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contrato_id` (`contrato_id`),
  ADD KEY `plan_anterior_id` (`plan_anterior_id`),
  ADD KEY `plan_nuevo_id` (`plan_nuevo_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `historial_cambios_plan_dependientes`
--
ALTER TABLE `historial_cambios_plan_dependientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dependiente_id` (`dependiente_id`),
  ADD KEY `plan_anterior_id` (`plan_anterior_id`),
  ADD KEY `plan_nuevo_id` (`plan_nuevo_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `historial_reasignaciones`
--
ALTER TABLE `historial_reasignaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asignacion_id` (`asignacion_id`);

--
-- Indices de la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `factura_id` (`factura_id`),
  ADD KEY `cobrador_id` (`cobrador_id`),
  ADD KEY `idx_pago_tipo` (`tipo_pago`),
  ADD KEY `idx_factura_estado_pago` (`factura_id`,`estado`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `referencias_clientes`
--
ALTER TABLE `referencias_clientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Indices de la tabla `reportes_auditoria`
--
ALTER TABLE `reportes_auditoria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `reportes_historial`
--
ALTER TABLE `reportes_historial`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `reportes_notas`
--
ALTER TABLE `reportes_notas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reporte_id` (`reporte_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `supervisor_sesiones_log`
--
ALTER TABLE `supervisor_sesiones_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_supervisor_log_uid` (`usuario_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- Indices de la tabla `vendedores`
--
ALTER TABLE `vendedores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `vendedor_sesiones_log`
--
ALTER TABLE `vendedor_sesiones_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vendedor_log_uid` (`usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asignaciones_facturas`
--
ALTER TABLE `asignaciones_facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `beneficiarios`
--
ALTER TABLE `beneficiarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT de la tabla `beneficios_planes`
--
ALTER TABLE `beneficios_planes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `cobradores`
--
ALTER TABLE `cobradores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `cobrador_facturas_autorizadas`
--
ALTER TABLE `cobrador_facturas_autorizadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cobrador_mensajes`
--
ALTER TABLE `cobrador_mensajes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `cobrador_rutas`
--
ALTER TABLE `cobrador_rutas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT de la tabla `cobrador_sesiones_log`
--
ALTER TABLE `cobrador_sesiones_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `configuracion_sistema`
--
ALTER TABLE `configuracion_sistema`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `contratos`
--
ALTER TABLE `contratos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `dependientes`
--
ALTER TABLE `dependientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `descuentos`
--
ALTER TABLE `descuentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `descuentos_aplicados`
--
ALTER TABLE `descuentos_aplicados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `generacion_facturas_lock`
--
ALTER TABLE `generacion_facturas_lock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `generacion_lote_lock`
--
ALTER TABLE `generacion_lote_lock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_cambios_plan`
--
ALTER TABLE `historial_cambios_plan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_cambios_plan_dependientes`
--
ALTER TABLE `historial_cambios_plan_dependientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_reasignaciones`
--
ALTER TABLE `historial_reasignaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `planes`
--
ALTER TABLE `planes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `referencias_clientes`
--
ALTER TABLE `referencias_clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `reportes_auditoria`
--
ALTER TABLE `reportes_auditoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `reportes_historial`
--
ALTER TABLE `reportes_historial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `reportes_notas`
--
ALTER TABLE `reportes_notas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `supervisor_sesiones_log`
--
ALTER TABLE `supervisor_sesiones_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `vendedores`
--
ALTER TABLE `vendedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `vendedor_sesiones_log`
--
ALTER TABLE `vendedor_sesiones_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asignaciones_facturas`
--
ALTER TABLE `asignaciones_facturas`
  ADD CONSTRAINT `fk_asignacion_cobrador` FOREIGN KEY (`cobrador_id`) REFERENCES `cobradores` (`id`),
  ADD CONSTRAINT `fk_asignacion_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`);

--
-- Filtros para la tabla `beneficiarios`
--
ALTER TABLE `beneficiarios`
  ADD CONSTRAINT `beneficiarios_ibfk_1` FOREIGN KEY (`contrato_id`) REFERENCES `contratos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `beneficios_planes`
--
ALTER TABLE `beneficios_planes`
  ADD CONSTRAINT `beneficios_planes_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `planes` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cobradores`
--
ALTER TABLE `cobradores`
  ADD CONSTRAINT `fk_cobrador_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `cobrador_facturas_autorizadas`
--
ALTER TABLE `cobrador_facturas_autorizadas`
  ADD CONSTRAINT `fk_aut_cobrador` FOREIGN KEY (`cobrador_id`) REFERENCES `cobradores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_aut_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_aut_usuario` FOREIGN KEY (`autorizado_por`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cobrador_mensajes`
--
ALTER TABLE `cobrador_mensajes`
  ADD CONSTRAINT `fk_msg_cobrador` FOREIGN KEY (`cobrador_id`) REFERENCES `cobradores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_msg_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cobrador_rutas`
--
ALTER TABLE `cobrador_rutas`
  ADD CONSTRAINT `fk_ruta_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ruta_cobrador` FOREIGN KEY (`cobrador_id`) REFERENCES `cobradores` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cobrador_sesiones_log`
--
ALTER TABLE `cobrador_sesiones_log`
  ADD CONSTRAINT `fk_sesion_cobrador` FOREIGN KEY (`cobrador_id`) REFERENCES `cobradores` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD CONSTRAINT `contratos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `contratos_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `planes` (`id`),
  ADD CONSTRAINT `contratos_ibfk_3` FOREIGN KEY (`vendedor_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_contratos_cobrador` FOREIGN KEY (`cobrador_id`) REFERENCES `cobradores` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `dependientes`
--
ALTER TABLE `dependientes`
  ADD CONSTRAINT `dependientes_ibfk_1` FOREIGN KEY (`contrato_id`) REFERENCES `contratos` (`id`),
  ADD CONSTRAINT `dependientes_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `planes` (`id`);

--
-- Filtros para la tabla `descuentos_aplicados`
--
ALTER TABLE `descuentos_aplicados`
  ADD CONSTRAINT `descuentos_aplicados_ibfk_1` FOREIGN KEY (`contrato_id`) REFERENCES `contratos` (`id`),
  ADD CONSTRAINT `descuentos_aplicados_ibfk_2` FOREIGN KEY (`descuento_id`) REFERENCES `descuentos` (`id`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`contrato_id`) REFERENCES `contratos` (`id`);

--
-- Filtros para la tabla `generacion_facturas_lock`
--
ALTER TABLE `generacion_facturas_lock`
  ADD CONSTRAINT `generacion_facturas_lock_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `historial_cambios_plan`
--
ALTER TABLE `historial_cambios_plan`
  ADD CONSTRAINT `historial_cambios_plan_ibfk_1` FOREIGN KEY (`contrato_id`) REFERENCES `contratos` (`id`),
  ADD CONSTRAINT `historial_cambios_plan_ibfk_2` FOREIGN KEY (`plan_anterior_id`) REFERENCES `planes` (`id`),
  ADD CONSTRAINT `historial_cambios_plan_ibfk_3` FOREIGN KEY (`plan_nuevo_id`) REFERENCES `planes` (`id`),
  ADD CONSTRAINT `historial_cambios_plan_ibfk_4` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `historial_cambios_plan_dependientes`
--
ALTER TABLE `historial_cambios_plan_dependientes`
  ADD CONSTRAINT `hist_cambios_dep_ibfk_1` FOREIGN KEY (`dependiente_id`) REFERENCES `dependientes` (`id`),
  ADD CONSTRAINT `hist_cambios_dep_ibfk_2` FOREIGN KEY (`plan_anterior_id`) REFERENCES `planes` (`id`),
  ADD CONSTRAINT `hist_cambios_dep_ibfk_3` FOREIGN KEY (`plan_nuevo_id`) REFERENCES `planes` (`id`),
  ADD CONSTRAINT `hist_cambios_dep_ibfk_4` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `historial_reasignaciones`
--
ALTER TABLE `historial_reasignaciones`
  ADD CONSTRAINT `fk_historial_asignacion` FOREIGN KEY (`asignacion_id`) REFERENCES `asignaciones_facturas` (`id`);

--
-- Filtros para la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  ADD CONSTRAINT `logs_sistema_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`),
  ADD CONSTRAINT `pagos_ibfk_2` FOREIGN KEY (`cobrador_id`) REFERENCES `cobradores` (`id`);

--
-- Filtros para la tabla `referencias_clientes`
--
ALTER TABLE `referencias_clientes`
  ADD CONSTRAINT `referencias_clientes_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reportes_auditoria`
--
ALTER TABLE `reportes_auditoria`
  ADD CONSTRAINT `reportes_auditoria_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `reportes_historial`
--
ALTER TABLE `reportes_historial`
  ADD CONSTRAINT `reportes_historial_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `reportes_notas`
--
ALTER TABLE `reportes_notas`
  ADD CONSTRAINT `reportes_notas_ibfk_1` FOREIGN KEY (`reporte_id`) REFERENCES `reportes_historial` (`id`),
  ADD CONSTRAINT `reportes_notas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

DELIMITER $$
--
-- Eventos
--
CREATE EVENT `evt_actualizar_vencidas` ON SCHEDULE EVERY 1 DAY STARTS '2026-03-28 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL sp_actualizar_facturas_vencidas()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
