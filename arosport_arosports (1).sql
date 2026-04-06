-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 06-04-2026 a las 12:52:58
-- Versión del servidor: 5.7.23-23
-- Versión de PHP: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `arosport_arosports`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrador`
--

CREATE TABLE `administrador` (
  `id_Administrador` int(10) UNSIGNED NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_franccionamientoclub` int(11) DEFAULT NULL,
  `tipo_casa` varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  `num_casa` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `super_admin` int(11) DEFAULT '0',
  `id_status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `administrador`
--

INSERT INTO `administrador` (`id_Administrador`, `id_usuario`, `id_franccionamientoclub`, `tipo_casa`, `num_casa`, `super_admin`, `id_status`) VALUES
(1, 1057, 1, '', '', 0, NULL),
(2, 1058, 2, '', '', 0, NULL),
(3, 1084, 2, '', '', 0, NULL),
(4, 1090, 2, '', '', 0, NULL),
(7, 1093, 5, '', '', 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banners`
--

CREATE TABLE `banners` (
  `id` int(11) NOT NULL,
  `imagen` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(150) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `url_destino` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `estatus` tinyint(1) DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `orden` int(11) NOT NULL DEFAULT '0',
  `tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `id_promotor` int(11) DEFAULT NULL,
  `estado` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pais` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `banners`
--

INSERT INTO `banners` (`id`, `imagen`, `nombre`, `url_destino`, `estatus`, `fecha_creacion`, `fecha_modificacion`, `orden`, `tipo`, `precio`, `id_promotor`, `estado`, `pais`) VALUES
(28, 'static/uploads/banners/banner_20250717_091042480.png', '', 'https://www.instagram.com/theclubpadel.puebla?igsh=MW91M3JoZHFrZnhsdQ==', 2, '2025-07-17 15:10:42', '2026-01-25 16:59:30', 0, 'global', NULL, NULL, NULL, NULL),
(29, 'static/uploads/banners/banner_20250717_091323489.jpg', '', 'https://www.instagram.com/theclubpadel.qro/?igsh=MWFvNzV6NGw5YnFiMA%3D%3D#', 2, '2025-07-17 15:13:23', '2026-01-25 16:59:30', 0, 'global', NULL, NULL, NULL, NULL),
(30, 'static/uploads/banners/banner_20250729_144416728.jpg', '', NULL, 0, '2025-07-29 20:44:16', '2026-02-17 01:34:54', 0, 'global', NULL, NULL, NULL, NULL),
(31, 'static/uploads/banners/banner_20250729_144737070.jpg', '', '', 2, '2025-07-29 20:47:37', '2026-01-25 18:13:36', 0, 'estatal', 0.00, 6, 'Durango', 'Mexico'),
(32, 'static/uploads/banners/banner_20250729_145336799.png', '', '', 2, '2025-07-29 20:53:36', '2026-01-25 16:59:30', 0, 'global', NULL, NULL, NULL, NULL),
(34, 'static/uploads/banners/banner_20260113_132630_69669c6637e5f.jpeg', '', '', 1, '2026-01-13 19:26:30', '2026-01-25 16:52:48', 0, 'global', 15000.00, 9, NULL, NULL),
(35, 'static/uploads/banners/banner_20260114_115848_6967d95800f8a.mp4', '', '', 1, '2026-01-14 17:58:48', '2026-01-28 17:50:09', 0, 'global', 15000.00, 9, NULL, NULL),
(38, 'static/uploads/banners/banner_20260115_150240_696955f05bbe8.mp4', '', '', 1, '2026-01-15 21:02:40', '2026-01-28 17:50:09', 0, 'global', 15000.00, 6, NULL, NULL),
(39, 'static/uploads/banners/banner_20260125_094138_697639b233d0b.jpg', '', 'https://thebrandindustry.com/es', 1, '2026-01-25 15:41:38', '2026-01-25 16:07:47', 0, 'global', 0.00, 6, NULL, NULL),
(40, 'static/uploads/banners/banner_20260317_184012_4115.png', 'Canam 50Q', 'https://www.50qmotorsadventure.com/', 1, '2026-03-18 00:40:12', '2026-03-18 00:40:12', 0, 'global', 5000.00, 9, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificaciones`
--

CREATE TABLE `calificaciones` (
  `id_calif` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `calif_bien` int(11) DEFAULT NULL,
  `calif_mal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cambios_grupos_torneo`
--

CREATE TABLE `cambios_grupos_torneo` (
  `id_cambio` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `categoria_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subcategoria_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grupo_origen_index` int(11) NOT NULL,
  `grupo_destino_index` int(11) NOT NULL,
  `pareja_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pareja_destino_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_operacion` enum('mover','intercambiar') COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp_storage` bigint(20) DEFAULT NULL,
  `datos_grupos_completos` longtext COLLATE utf8mb4_unicode_ci,
  `fecha_cambio` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aplicacion` timestamp NULL DEFAULT NULL,
  `estado` enum('registrado','aplicado','revertido') COLLATE utf8mb4_unicode_ci DEFAULT 'registrado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cambios_grupo_padel`
--

CREATE TABLE `cambios_grupo_padel` (
  `id` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `categoria_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subcategoria_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `equipo_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grupo_origen` int(11) NOT NULL,
  `grupo_destino` int(11) NOT NULL,
  `fecha_cambio` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `canchas`
--

CREATE TABLE `canchas` (
  `id_canchas` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `can_nombre` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `can_deporte` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `can_tipo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `can_descripcion` text COLLATE utf8_unicode_ci,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `can_reserva` int(11) DEFAULT NULL,
  `id_status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `canchas`
--

INSERT INTO `canchas` (`id_canchas`, `id_fraccionamientoclub`, `can_nombre`, `can_deporte`, `can_tipo`, `can_descripcion`, `fecha_creacion`, `can_reserva`, `id_status`) VALUES
(1, 2, 'Cancha Grupo Pasta (1)', 'padel', 'cubierta', '', '2026-03-01 09:00:00', 1, 1),
(2, 2, 'Cancha WeAdvice (2)', 'padel', 'cubierta', '', '2026-03-01 09:01:00', 1, 1),
(3, 2, 'Cancha Estadio Lyncott (3)', 'padel', 'cubierta', '', '2026-03-01 09:02:00', 1, 1),
(4, 2, 'Cancha Qronos (4)', 'padel', 'cubierta', '', '2026-03-01 09:03:00', 1, 1),
(5, 2, 'Cancha z 5 (5)', 'padel', 'cubierta', '', '2026-03-01 09:04:00', 1, 1),
(6, 2, 'Cancha 6 (6)', 'padel', 'cubierta', '', '2026-03-01 09:05:00', 1, 1),
(7, 1, 'Developer', 'padel', 'indoor', '', '2026-03-01 09:06:00', 1, 1),
(8, 1, 'Mensualidad', 'padel', 'indoor', '', '2026-04-03 12:59:56', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `canchasTorneo`
--

CREATE TABLE `canchasTorneo` (
  `idCanchasTorneo` int(11) NOT NULL,
  `idCancha` int(11) NOT NULL,
  `idTorneo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `categoria` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `categoria`, `estatus`) VALUES
(1, 'Open', 1),
(2, 'Primera', 1),
(3, 'Segunda', 1),
(4, 'Tercera', 1),
(5, 'Cuarta', 1),
(6, 'Quinta', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoriasTorneo`
--

CREATE TABLE `categoriasTorneo` (
  `idCategoriasTorneo` int(11) NOT NULL,
  `id_nivelJuego` int(11) NOT NULL,
  `parejasH` int(11) DEFAULT NULL,
  `parejasM` int(11) DEFAULT NULL,
  `parejasMIX` int(11) DEFAULT NULL,
  `id_torneos` int(11) NOT NULL,
  `parejasHfinales` int(11) DEFAULT NULL,
  `parejasMfinales` int(11) DEFAULT NULL,
  `parejasMIXfinales` int(11) DEFAULT NULL,
  `parejasHgrupos` int(11) DEFAULT NULL,
  `parejasMgrupos` int(11) DEFAULT NULL,
  `parejasMIXgrupos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_finazas`
--

CREATE TABLE `categorias_finazas` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tipo` enum('ingreso','egreso') COLLATE utf8_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8_unicode_ci,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `status` enum('activa','inactiva') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `club_metodo_pago`
--

CREATE TABLE `club_metodo_pago` (
  `id` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `id_metodo` int(11) NOT NULL,
  `estatus` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `coaches`
--

CREATE TABLE `coaches` (
  `id` int(11) NOT NULL,
  `coa_nombres` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `coa_apellidos` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `coa_telefono` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `coa_correo` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `coa_foto` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_status` int(11) NOT NULL DEFAULT '2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `coaches`
--

INSERT INTO `coaches` (`id`, `coa_nombres`, `id_fraccionamientoclub`, `coa_apellidos`, `coa_telefono`, `coa_correo`, `coa_foto`, `id_status`) VALUES
(1, 'Sergio', 2, 'Gonzalez', '4461544479', 'sergiodanielgonzalezavila@gmail.com', NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `coach_prices`
--

CREATE TABLE `coach_prices` (
  `id` int(11) NOT NULL,
  `coach_id` int(11) NOT NULL,
  `tipo` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `cantidad_personas` int(11) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `moneda` enum('MXN','USD','EUR','') COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `coach_prices`
--

INSERT INTO `coach_prices` (`id`, `coach_id`, `tipo`, `cantidad_personas`, `precio`, `moneda`) VALUES
(5, 1, 'clase', 1, 700.00, 'MXN'),
(6, 1, 'clase', 2, 800.00, 'MXN'),
(7, 1, 'clase', 3, 900.00, 'MXN'),
(8, 1, 'clase', 4, 1000.00, 'MXN'),
(9, 1, 'academia', NULL, 300.00, 'MXN');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `codigos_prueba`
--

CREATE TABLE `codigos_prueba` (
  `id` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'club',
  `dias_gratis` int(11) NOT NULL,
  `estatus` tinyint(4) NOT NULL DEFAULT '1',
  `id_usuario_creacion` int(11) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `usado_por_usuario_id` int(11) DEFAULT NULL,
  `usado_por_customer_id` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usado_en` datetime DEFAULT NULL,
  `trial_inicio` datetime DEFAULT NULL,
  `trial_fin` datetime DEFAULT NULL,
  `stripe_subscription_id` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_price_id` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `codigos_prueba`
--

INSERT INTO `codigos_prueba` (`id`, `codigo`, `categoria`, `dias_gratis`, `estatus`, `id_usuario_creacion`, `fecha_registro`, `fecha_actualizacion`, `usado_por_usuario_id`, `usado_por_customer_id`, `usado_en`, `trial_inicio`, `trial_fin`, `stripe_subscription_id`, `stripe_price_id`) VALUES
(1, 'FSKZN2', 'club', 7, 3, 76, '2026-03-24 00:42:22', '2026-03-24 01:06:38', 1057, 'cus_UCobxnOFZAeu0f', '2026-03-24 01:06:38', '2026-03-24 01:06:37', '2026-03-31 01:06:37', 'sub_1TEP2vJxH4equOwCOHGwE6tZ', 'price_1SntuyJxH4equOwCXrTl5Qll'),
(2, '9TU5CC', 'club', 15, 1, 76, '2026-03-24 12:59:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, '85MX9Y', 'club', 30, 3, 76, '2026-03-24 13:57:16', '2026-03-25 09:50:59', 1058, 'cus_UDKMX0M2nHBm2g', '2026-03-25 09:50:59', '2026-03-25 09:50:57', '2026-04-24 09:50:57', 'sub_1TEthtJxH4equOwCdhh4KDav', 'price_1SntuyJxH4equOwCXrTl5Qll'),
(4, '5W5SGW', 'club', 60, 3, 76, '2026-04-03 11:20:09', '2026-04-03 11:22:52', 1057, 'cus_UCobxnOFZAeu0f', '2026-04-03 11:22:52', '2026-04-03 11:22:51', '2026-06-02 11:22:51', 'sub_1TIBQlJxH4equOwChD7x8kKg', 'price_1SntuyJxH4equOwCXrTl5Qll');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cortes_caja`
--

CREATE TABLE `cortes_caja` (
  `id_corte` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `total_ingresos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_egresos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `saldo_final` decimal(12,2) NOT NULL DEFAULT '0.00',
  `observaciones` text,
  `status` enum('pendiente','cerrado','aprobado') NOT NULL DEFAULT 'pendiente',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cortes_caja_detalles`
--

CREATE TABLE `cortes_caja_detalles` (
  `id_detalle_corte` int(11) NOT NULL,
  `id_corte` int(11) NOT NULL,
  `id_club_metodo_pago` int(11) NOT NULL,
  `metodo_pago_nombre` varchar(100) NOT NULL,
  `ingresos_sistema` decimal(12,2) NOT NULL DEFAULT '0.00',
  `egresos_sistema` decimal(12,2) NOT NULL DEFAULT '0.00',
  `balance_sistema` decimal(12,2) NOT NULL DEFAULT '0.00',
  `monto_real_contado` decimal(12,2) NOT NULL DEFAULT '0.00',
  `diferencia` decimal(12,2) NOT NULL DEFAULT '0.00',
  `notas` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cortes_caja_movimientos`
--

CREATE TABLE `cortes_caja_movimientos` (
  `id_relacion` int(11) NOT NULL,
  `id_corte` int(11) NOT NULL,
  `id_detalle_corte` int(11) DEFAULT NULL,
  `tipo_movimiento` enum('ingreso','egreso') NOT NULL,
  `id_movimiento` int(11) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `nota` text,
  `id_club_metodo_pago` int(11) NOT NULL,
  `metodo_pago_nombre` varchar(100) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `categoria_nombre` varchar(100) DEFAULT NULL,
  `concepto` varchar(255) DEFAULT NULL,
  `fecha_movimiento` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direccion`
--

CREATE TABLE `direccion` (
  `id_direccion` int(11) NOT NULL,
  `calle` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_ext` int(11) DEFAULT NULL,
  `num_int` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `colonia` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cp` int(5) DEFAULT NULL,
  `latitud` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `longitud` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `descripcion` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `estado` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pais` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `direccion`
--

INSERT INTO `direccion` (`id_direccion`, `calle`, `num_ext`, `num_int`, `colonia`, `cp`, `latitud`, `longitud`, `descripcion`, `id_status`, `id_usuario`, `estado`, `pais`) VALUES
(1, 'Los tulipanes', 125, '', '', 0, NULL, NULL, NULL, NULL, 1057, 'Guanajuato', 'Mexico'),
(2, 'Avenida Palma Canaria', 6400, '', 'Valle Comercial Juriquilla', 76100, '20.688438550037993', '-100.43959553203305', NULL, NULL, 1058, 'Querétaro', 'Mexico'),
(4, 'Avenida Palma Canaria', 6400, NULL, '', 76100, '20.68814437079969', '-100.43965483655326', 'Ubicación actualizada por el usuario', NULL, 1060, 'queretaro', 'mexico'),
(6, 'Ellis Street', 1800, NULL, '', 94115, '37.785834', '-122.406417', 'Ubicación actualizada por el usuario', NULL, 1079, 'california', 'united states'),
(7, 'Ellis Street', 1800, NULL, '', 94115, '37.785834', '-122.406417', 'Ubicación actualizada por el usuario', NULL, 1080, 'california', 'united states'),
(8, 'Santa Cecilia', 902, NULL, '', 76100, '20.6884652', '-100.4399975', 'Ubicación actualizada por el usuario', NULL, 1082, 'queretaro', 'mexico'),
(9, '', 0, NULL, '', 76269, '20.650578385643396', '-100.30634612814832', 'Ubicación actualizada por el usuario', NULL, 1083, 'queretaro', 'mexico'),
(10, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.688139523167983', '-100.43972831355747', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(11, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.68816973328017', '-100.4396908470479', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(12, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.688167291254796', '-100.43969334473287', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(13, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.688156621730705', '-100.43970471282574', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(14, '', 0, '', 'Zibatá', 76269, '20.67699382013476', '-100.3219647193638', 'Avenida Valle de Legarda número 6, Privada de', 1, NULL, 'queretaro', 'mexico'),
(15, '', 0, '', 'Zibatá', 76269, '20.6769964683998', '-100.32196823334975', 'Avenida Valle de Legarda número 6, Privada de', 1, NULL, 'queretaro', 'mexico'),
(16, '', 0, '', 'Zibatá', 76269, '20.676998382798995', '-100.3219988512284', 'Avenida Valle de Legarda número 6, Privada de', 1, NULL, 'queretaro', 'mexico'),
(17, 'Calle Valle Zalain', 11, '', 'Zibatá', 76269, '20.677933404676224', '-100.32209969536684', 'C. Valle Zalain 11, 76269 Zibatá, Qro., Méxic', 1, NULL, 'queretaro', 'mexico'),
(18, 'Calle Valle Zalain', 11, '', 'Zibatá', 76269, '20.677933441471108', '-100.32209969812375', 'C. Valle Zalain 11, 76269 Zibatá, Qro., Méxic', 1, NULL, 'queretaro', 'mexico'),
(19, 'Calle Valle Zalain', 11, NULL, '', 76269, '20.677927607098283', '-100.32205160514802', 'Ubicación actualizada por el usuario', NULL, 1085, 'queretaro', 'mexico'),
(20, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.688166097605894', '-100.439723000469', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(21, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.688165607039107', '-100.4397247942537', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(22, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.688096497921773', '-100.43967018978387', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(23, 'Hacienda Santa Barbara', 115, NULL, 'El Jacal', 76180, '20.566306805471516', '-100.41212200405548', 'Ubicación actualizada por el usuario', NULL, 1088, 'queretaro', 'mexico'),
(24, 'Hacienda Santa Barbara', 115, '', 'El Jacal', 76180, '20.566258902722208', '-100.41207475186069', 'Hacienda Sta. Barbara 115, El Jacal, 76180 Sa', 1, NULL, 'queretaro', 'mexico'),
(25, 'Montes', 710, '15D', 'Villas de Santiago', 76148, NULL, NULL, NULL, NULL, 1091, 'Queretaro de Arteaga', 'México'),
(26, 'Hacienda Santa Barbara', 115, '', 'El Jacal', 76180, '20.566300676806897', '-100.41213238539444', 'Hacienda Sta. Barbara 115, El Jacal, 76180 Sa', 1, NULL, 'queretaro', 'mexico'),
(27, '', 0, '', '', 0, NULL, NULL, NULL, NULL, 1092, '', ''),
(28, 'Montes', 710, '15D', 'Villas de Santiago', 76148, NULL, NULL, NULL, NULL, 1093, 'Queretaro de Arteaga', 'México'),
(29, 'Avenida Palma Canaria', 6400, '', 'Juriquilla', 76100, '20.68808277554937', '-100.43971714483222', 'Av. Palma Canaria 6400, 76100 Juriquilla, Qro', 1, NULL, 'queretaro', 'mexico'),
(30, 'Hacienda Santillán', 104, '', 'Las Torres', 76180, '20.565836752067025', '-100.41238844940519', 'Hacienda Santillán 104, Las Torres, 76180 San', 1, NULL, 'queretaro', 'mexico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `directorio_clubes`
--

CREATE TABLE `directorio_clubes` (
  `id_directorio_club` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `telefonos` text,
  `ciudad` varchar(120) NOT NULL,
  `pais` varchar(120) NOT NULL DEFAULT '',
  `estado` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `directorio_clubes`
--

INSERT INTO `directorio_clubes` (`id_directorio_club`, `nombre`, `direccion`, `url`, `telefonos`, `ciudad`, `pais`, `estado`) VALUES
(1, 'Padel Courts Querétaro', 'Fray Junipero 16950, Parque industrial Sotavento int. 8 y 9', NULL, '[\"4425976911\"]', 'Querétaro', '', 'Querétaro'),
(2, 'Intercepta', 'Zibata', NULL, '[\"4427100453\"]', 'Querétaro', '', 'Querétaro'),
(3, 'Glass Cube Juriquilla', 'Av. Palma Canaria Juriquilla', NULL, '[\"5518056164\"]', 'Querétaro', '', 'Querétaro'),
(4, 'The Club Padel & Academy Qro', 'Av. Palma Canaria 6400, Juriquilla', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(5, 'Backspin', 'Cumbres del lago Juriquilla', NULL, '[\"5551004489\"]', 'Querétaro', '', 'Querétaro'),
(6, 'Padel 22', 'Cumbres del lago Juriquilla', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(7, 'All 4 padel Qro', 'The Hub, Centro Sur', NULL, '[\"4423373600\",\"4422513850\"]', 'Querétaro', '', 'Querétaro'),
(8, 'Padel Quintana', 'Bernardo Quintana', NULL, '[\"4423725746\"]', 'Querétaro', '', 'Querétaro'),
(9, 'Femac', 'Lomas del Campanario Norte', NULL, '[\"5551050642\"]', 'Querétaro', '', 'Querétaro'),
(10, 'Finca Ancestral', '', NULL, '[\"4423387452\"]', 'Querétaro', '', 'Querétaro'),
(11, 'Evolution Qro', 'El Refugio', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(12, 'Bunker', 'Fray Junipero', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(13, 'Braveus', 'Huimilpan', NULL, '[\"4422725281\"]', 'Querétaro', '', 'Querétaro'),
(14, 'Smash Padel Club Qro', 'Av. De la Luz Satelite', NULL, '[\"5537074047\"]', 'Querétaro', '', 'Querétaro'),
(15, 'Palace Padel Club', 'Av. Fray Eulalio Hernandez rivera 101, Corregidora', NULL, '[\"4421491628\"]', 'Querétaro', '', 'Querétaro'),
(16, 'Club Campestre', 'El Campestre', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(17, 'Club La Loma', 'Fray Junipero', NULL, '[\"44226205288\"]', 'Querétaro', '', 'Querétaro'),
(18, 'Club Casablanca', 'Real de Juriquilla', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(19, 'Club Cima Diamante', 'Bernardo Quintana', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(20, 'Top Padel', 'Corregidora', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(21, 'Palma Sur', 'Centro Sur', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(22, 'La Saca', 'Corregidora', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(23, 'Legacy Padel', 'Privada el Condado Carretera a Huimilpan', NULL, '[\"4423188978\"]', 'Querétaro', '', 'Querétaro'),
(24, 'Rústico El Once', 'Amealco', NULL, '[\"4421128615\"]', 'Querétaro', '', 'Querétaro'),
(25, 'Josefa', 'Corregidora', NULL, '[\"5549504240\"]', 'Querétaro', '', 'Querétaro'),
(26, 'El Dorado', 'Fray Junipero', NULL, '[]', 'Querétaro', '', 'Querétaro'),
(27, 'MAS padel queretaro', 'Terra Park Centenario, bodega 64C, Querétaro', NULL, '[\"4461313275\"]', 'Querétaro', '', 'Querétaro'),
(28, 'Sunset Padel Clubs', 'Ejido Modelo, Centro histórico', NULL, '[\"4424671983\"]', 'Querétaro', '', 'Querétaro'),
(29, 'Club Regency', 'Jurica Regency', NULL, '[\"4422499717\"]', 'Querétaro', '', 'Querétaro'),
(30, 'Abollengo Padel Club', '', NULL, '[\"5527374505\"]', 'Querétaro', '', 'Querétaro'),
(31, 'Padelario', 'Capital Sur, por el Conin', NULL, '[\"4425922093\",\"4423277161\"]', 'Querétaro', '', 'Querétaro'),
(32, 'Club Pedregal', 'Olivo 107, Pedregal de Hacienda Grande, Centro Tequisquiapan', NULL, '[\"4141140012\"]', 'Querétaro', '', 'Querétaro'),
(33, 'Glass Cube Corregidora', '', NULL, '[\"5518056164\"]', 'Querétaro', '', 'Querétaro'),
(34, 'Padel Titanes', 'Afuera de Arco de Piedra, complejo deportivo', NULL, '[\"5551021253\"]', 'Querétaro', '', 'Querétaro'),
(35, 'Box Padel Qro', 'Centro Expositor Qro', NULL, '[\"4427231614\",\"5570107800\"]', 'Querétaro', '', 'Querétaro'),
(36, 'La Capilla Club Deportivo', '', NULL, '[\"4423150954\"]', 'San Miguel de Allende', '', 'Guanajuato'),
(37, 'Holly Life Club', '', NULL, '[\"4423150954\"]', 'San Miguel de Allende', '', 'Guanajuato'),
(38, 'Padel Club San Miguel', '', NULL, '[\"3471100010\"]', 'San Miguel de Allende', '', 'Guanajuato'),
(39, 'Bandeja Club', 'Blvd. Jose Maria Morelos 3550-A', NULL, '[\"4774079312\"]', 'Leon', '', 'Guanajuato'),
(40, 'Capital Padel León', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(41, 'Club Britania', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(42, 'Club Campestre León', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(43, 'Club Cumbres', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(44, 'Continental Padel Club', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(45, 'El Bosque Country Club', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(46, 'Focus Sports Club', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(47, 'IDD Montevideo', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(48, 'MachPoint Leon', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(49, 'Mayorazgo Padel Club', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(50, 'Nebra Residencias', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(51, 'Padel Mania', 'Blvd. La Luz 3307', NULL, '[]', 'Leon', '', 'Guanajuato'),
(52, 'Padel Norte', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(53, 'Padel Park Gran Jardin', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(54, 'Padel Zone', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(55, 'Padelista Forever Social Club', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(56, 'Palmas Padel', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(57, 'Peninsula', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(58, 'Pro Padel', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(59, 'Quinta Padel', 'Blvd. San Pedro 108, San Isidro Nte, 37510, Leon', NULL, '[\"4721489070\"]', 'Leon', '', 'Guanajuato'),
(60, 'Revo 4.0 Padel Club', 'Malecón del Río 1443', NULL, '[]', 'Leon', '', 'Guanajuato'),
(61, 'Smash X Padel', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(62, 'SouthSide Padel Club', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(63, 'Sports Park Padel', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(64, 'The Padel Club Molino', 'Calle Viznaga s/n, col. La Patiña 37000, Leon', NULL, '[\"4777542879\"]', 'Leon', '', 'Guanajuato'),
(65, 'Win Padel Center', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(66, 'Mayorazgo Padel Club', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(67, 'Bandeja', 'Ancorada 5010A, Zona Club Deportiva, 37287, Leon, Gto.', NULL, '[\"4777867528\"]', 'Leon', '', 'Guanajuato'),
(68, 'Padel Los Naranjos', 'Blvd. Jose Maria Morelos 2303, Los Naranjos, Leon, Gto.', NULL, '[\"4779221506\"]', 'Leon', '', 'Guanajuato'),
(69, 'Club Padel Zur', '', NULL, '[]', 'Leon', '', 'Guanajuato'),
(70, 'Padel Cygnus', 'Calle Nueva Italia 609 y 611 San Cristobal, Col. Del Predio', NULL, '[\"7774988888\"]', 'Cuernavaca', '', 'Morelos'),
(71, 'Forza Padel Club', 'Av. San Diego 100, Delicias, 62330', NULL, '[\"7771340167\"]', 'Cuernavaca', '', 'Morelos'),
(72, 'Squadra Padel House', 'Río Usumacinta, Vista Hermosa', NULL, '[\"7774972481\"]', 'Cuernavaca', '', 'Morelos'),
(73, 'Más 3 Padel', 'Sonora 726, Zona 1, col. Lomas de Vista Hermosa, Cuernavaca', NULL, '[\"7777014990\"]', 'Cuernavaca', '', 'Morelos'),
(74, 'Green Ball Padel Oaxtepec', 'Cerrada Morelos s/n Col. 19 de febrero, Cuatla, Morelos', NULL, '[\"7351681791\"]', 'Cuernavaca', '', 'Morelos'),
(75, 'Nero', 'Blvd. Colosio', NULL, '[\"7713573210\"]', 'Pachuca', '', 'Hidalgo'),
(76, '2D3 Padel Indoor', '', NULL, '[]', 'Pachuca', '', 'Hidalgo'),
(77, 'Vintage Padel', 'Samuel Carro 202, Revolución Pachuca', NULL, '[\"7713568768\"]', 'Pachuca', '', 'Hidalgo'),
(78, 'Sky Padel', '', NULL, '[]', 'Pachuca', '', 'Hidalgo'),
(79, 'Zone Pachuca', 'Blvd. Valle de San Javier 109, Pachuca', NULL, '[\"7711111991\"]', 'Pachuca', '', 'Hidalgo'),
(80, 'The Club Padel & Academy Puebla', 'Av. Del Castillo Lomas de Angelopolis', NULL, '[\"2221332627\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(81, 'Atica', 'Atlixcayatl 7211 Lomas de Angelopolis', NULL, '[\"2214223264\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(82, 'Padel State Club Deportivo', 'Guadalupe Victoria 204 Tlaxcalancingo', NULL, '[]', 'Puebla/Tlaxcala', '', 'Puebla'),
(83, 'Match Point Padel Club', 'A. Casiopea 403 Altixcayatl', NULL, '[\"2225635457\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(84, 'Din Padel Club', 'Cholula, Puebla', NULL, '[\"2219182919\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(85, 'Urban Padel', '', NULL, '[\"2225481566\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(86, 'Star Padel', '', NULL, '[\"2216546934\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(87, 'Invicto Padel', 'Av. Del Sol 9, Reserva Atlixcayotl, Tlaxcalancingo, Puebla', NULL, '[\"22228099609\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(88, 'V Padel Puebla y Pickleball', 'Puebla lateral Lomas de Angelopolis', NULL, '[\"2221110524\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(89, 'Padelex by Miky Bejarano', '', NULL, '[]', 'Puebla/Tlaxcala', '', 'Puebla'),
(90, 'Pad Pad', 'Av. 41 pte 752, Gabriel Pastor, Puebla', NULL, '[]', 'Puebla/Tlaxcala', '', 'Puebla'),
(91, 'Pro Master Padel', 'Lateral Sur Recta a Cholula 3500, San Andres Cholula', NULL, '[\"2211499442\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(92, 'Padel Zone TLX', 'Tlaxcala', NULL, '[\"2463343973\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(93, 'Padel 4 Life', 'Blvd. Municipio Libre 3033, col. Camino Real, Puebla', NULL, '[\"2202960287\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(94, 'Opal Padel', 'Outlet City Center Angelopolis', NULL, '[\"2211466685\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(95, 'La Cueva Padel Tehuacan', 'Av. Jose Garci-Crespo 1410, col. Buenos aires, Tehuacan', NULL, '[\"2381016978\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(96, 'U Padel Puebla', 'Av. Las Torres 703-1, San Martinito, 72810, Tlaxcalancingo, Puebla', NULL, '[\"2294633713\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(97, 'Padel Lomas', '', NULL, '[]', 'Puebla/Tlaxcala', '', 'Puebla'),
(98, 'Hit Padel', 'Calle 12 de mayo 110, Santa Anita Huiloc, Apizaco, Tlaxcala', NULL, '[\"próximamente\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(99, 'Código Padel', 'Calle Solares 61, Cuautlancingo, Puebla', NULL, '[\"2224919736\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(100, 'Padel 29', 'Apizaco (Santa Anita), Tlaxcala', NULL, '[\"2411327387\"]', 'Puebla/Tlaxcala', '', 'Puebla'),
(101, 'B Padel', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(102, 'Padel Co Polanco', 'Lago Andromaco 17 y 23, Polanco', NULL, '[\"5651166924\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(103, 'Padel Co Reforma', 'Mariano Escobedo 726, Reforma', NULL, '[\"5534155166\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(104, 'Cana Indoor Padel Lomas Verdes', 'Av. Lomas Verdes 1200', NULL, '[\"5551947277\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(105, 'Contrapared', '', NULL, '[\"5591361070\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(106, 'Padel Vibes Club', 'calle Dr. Enrique Gonzalez Martin 220, col. Cuauthemoc, CDMX', NULL, '[\"5532043947\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(107, 'My Padel Tepepan', 'Prol. Av. 5 de mayo 17', NULL, '[\"5531005565\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(108, 'Spider Padel', 'CDMX Sur Pedregal', NULL, '[\"5591807759\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(109, 'Santa Pala Club de Padel', 'Louisiana 44, Napoles, Benito Juarez, CDMX', NULL, '[\"5568716260\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(110, 'Underground Padel', 'Calzada de la Naranja 168, Alce Blanco, CDMX', NULL, '[\"5568867837\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(111, 'Reves Padel Chapultepec', 'San Miguel Chapultepec', NULL, '[\"5522575710\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(112, 'Cerv Padel Club', '', NULL, '[\"5593855461\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(113, 'Padel Club Oriente', '', NULL, '[\"5517322356\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(114, 'Esta Padel Indoor Club Polanco', 'Lago Ladoga 210, Miguel Hidalgo, CDMX', NULL, '[\"5613767234\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(115, 'Padel District Pedregal', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(116, 'Mundo Padel Acoxpa', '', NULL, '[\"5638189989\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(117, 'Mundo Padel Coapa', '', NULL, '[\"5638189989\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(118, 'Esta Padel Tlalpan', 'Calzada de Tlalpan 3375, CDMX', NULL, '[\"5591922718\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(119, 'Mundo Padel Satelite', '', NULL, '[\"5638189989\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(120, 'Padel On Pedregal', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(121, 'Gran Padel', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(122, 'Altapadel CDMX', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(123, 'Lobo Padel Club', '', NULL, '[\"5518124468\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(124, 'Padel Town Coyoacan', 'Calle Inglaterra 139, Coyoacan, Mexico', NULL, '[\"5656818105\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(125, 'Palma Pádel CDMX', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(126, 'Padel Life Churubusco', 'Circuito Río Churubusco', NULL, '[\"5516954404\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(127, 'Reves Club Padel Texcoco', 'Camino del Ejido 3, Xocotlan, Texcoco, México', NULL, '[\"5959528032\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(128, 'Padelito Warehouse', 'Pelícanos 96, Granjas Modernas, Gustavo A Madero', NULL, '[\"5530416741\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(129, 'Padel del Valle', 'Romero de Terreros 813, CDMX', NULL, '[\"5539616707\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(130, 'Padelito Rooftop', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(131, 'Inpeak Condesa', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(132, 'Hack Padel', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(133, 'Padel Shot Encinos', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(134, 'Cuatro Padel and Pickleball', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(135, 'Club de Yaqui', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(136, 'Scorpion Padel', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(137, 'Padel Club el Molino', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(138, 'Padelista Padel Social', 'Juan Salvador Agraz 15, CDMX', NULL, '[\"5530121239\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(139, 'Golden Point Interlomas', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(140, 'Club deportivo Padelite', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(141, 'All4padel', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(142, 'Club de Padel DV', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(143, 'Baaxal Padel México', 'Ahuehuetes Norte 317, Bosques de las Lomas, Miguel Hidalgo', NULL, '[\"5579800332\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(144, 'Sportika Padel Center', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(145, 'Pala Padel Club', 'Blvd. Chiluca-Espiritu Santo 80B, Rancho Blanco, 52934, CDMX', NULL, '[\"5529092586\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(146, 'Vairo Padel Club', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(147, 'Padelicious', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(148, 'Centro Libanes', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(149, 'Golden Point Indoor', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(150, '20x10 Padel Pedregal', 'Camino Sta. Teresa 305- Puerta 1, Charra Tlalpan, CDMX', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(151, 'Padelhood MX', 'Av. Constituyentes 701, 16 de septiembre, Miguel Hidalgo', NULL, '[\"5518453410\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(152, 'Underground Padel', '', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(153, 'El Rey Padel', 'Texcoco, México', NULL, '[\"5951253875\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(154, 'SPC Indoor Padel', 'Paño Cabeza, Blvd. Chiluca-Espiritu Santo Zona Esmeralda', NULL, '[\"17223679532\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(155, 'Club Alva', 'Calle a Huexotla cp 56220, Texcoco San Luis Huexotla Estado de México', NULL, '[\"55610540096\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(156, 'Go Padel Club', 'C. Reforma 45, San Pedro Atzompa, Ojo de Agua, Tecamac', NULL, '[\"5563284594\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(157, 'Punto R', 'Av. San Jeronimo 32, San Angel, Coyoacan, Mexico', NULL, '[\"5586768414\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(158, 'Mundo Padel Coacalco', '5 de febrero 2, Coacalco', NULL, '[\"5638189989\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(159, 'Epic Padel MX', 'Próximamente en Querétaro y Puebla', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(160, 'All4padel Interlomas', 'Edificio Alterna interlomas (Dentro del gym Fitsi)', NULL, '[\"5511907903\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(161, 'Gran Slam Padel Club', 'Andrea del Sarto 16, col. Mixcoac, Mexico City', NULL, '[\"5572250323\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(162, 'Break Point Indoor Padel', 'Av. Porfirio Díaz 18, Estado de México', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(163, 'DV Club de Padel', 'Antonio Dovalí Jaime 95, Santa Fe, Alvaro Obregon', NULL, '[\"5523327156\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(164, 'My Padel', 'Cerrada Lago Erne 19, Reforma Pensil, Miguel Hidalgo', NULL, '[\"5591949136\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(165, 'Zona Raquet Esmeralda', 'Zona Esmeralda', NULL, '[\"5580805737\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(166, 'Club Futurama México', 'Santa Ana 111, Torres Lindavista 07798, Gustavo Madero, CDMX', NULL, '[\"5544998941\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(167, 'Padelcito', 'Viaducto Tlalpan 1003, La Joya', NULL, '[\"5517063833\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(168, 'Deportivo Oceania', 'Venustiano Carranza, CDMX', NULL, '[\"5532259416\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(169, 'Fit Padel Alberca Olímpica', 'Calle Riff s/n, Gral. Anaya, Benito Juarez, esquina Churubusco', NULL, '[\"5568864973\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(170, 'Padel Tepepan', 'Prolongación Abasolo 80, Mexico City', NULL, '[]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(171, 'Padelium', 'En el sur de la CDMX Sacalum Mz 68 Lote 14, entre Sinache y Popolina', NULL, '[\"5657164032\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(172, 'Barak Padel', 'Jacarandas 25, Cuautitlan Izcalli', NULL, '[\"5560639119\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(173, 'M&O Padel Club', 'Calle Independencia s/n casi esquina con calle la Paz, Chimalhuacan', NULL, '[\"5634383006\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(174, 'Cedros Padel Club', 'Cedros 18, Fraccionamiento Las Delicias, Atlautla', NULL, '[\"5535179323\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(175, 'Oasis Padel & Social Club', 'Blvd. Hernan Cortez, Manzana 011, Lomas Verdes 6ta Sección, Naucalpan', NULL, '[\"5548479467\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(176, '2 And 2', 'Bosque del Lago, Cuautitlan Izcalli', NULL, '[\"5552048290\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(177, 'MK Padel Club', 'Av. De los Pinos 72, San Clemente Sur, Alvaro Obregon, CDMX', NULL, '[\"5513721160\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(178, 'Padel & Friends Mx', 'Privada del romance, mza 10, Bosque Real, Naucalpan de Juarez, CDMX', NULL, '[\"5579950174\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(179, 'InterPadel MX', 'Espacio Interlomas, Av. Jesus del Monte 37, Mexico', NULL, '[\"5526892687\"]', 'CDMX/Edo de Mex', '', 'Ciudad de México'),
(180, 'Padel Corner Indoor', 'San Franscisco S/N El Milagro, Zona Huinala, Apodaca, Nuevo Leon', NULL, '[\"8186860975\"]', 'Monterrey', '', 'Nuevo León'),
(181, 'Sky Racquet', 'Auriga, San Pedro', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(182, 'Padel Boss', 'Dr Atl S/N, San Pedro Garza García', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(183, 'Cordillera Padel Club', 'Av. Alfonso Reyes 148 Residencial Cordillera, Sta Catarina', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(184, 'Padel Park Indoor', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(185, 'Padel Club Santa Maria', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(186, 'Padel Capital Monterrey', 'Monterrret, Nuevo Leon', NULL, '[\"8115388895\"]', 'Monterrey', '', 'Nuevo León'),
(187, 'Padel Central', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(188, 'Padel Nation', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(189, 'Padel GM Carretera Nacional', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(190, 'Santo Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(191, 'Padelarium', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(192, 'Abu Indoor Padel club', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(193, 'Padel 10.20', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(194, 'Power Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(195, 'Padel Siete Seis', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(196, 'Padel Club Esfera', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(197, 'Padel & Pickle GM', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(198, 'TB Padel Club', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(199, 'Padel Room Monterrey', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(200, 'Hacienda Santiago Padel Club', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(201, 'La Zona Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(202, 'San Emiliano Padel Campastre', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(203, 'Athletic Padel Club', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(204, 'Padel Allende', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(205, 'Woodland Padel Club', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(206, 'Club de Padel Montemorelos', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(207, 'Three Padel', 'Av. Santo Domingo 695, San Nicolas de los Garza', NULL, '[\"6148782629\"]', 'Monterrey', '', 'Nuevo León'),
(208, 'Royale Padel Indoor', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(209, 'Padel GM Cumbres', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(210, 'GOTT Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(211, 'Padel GM Valle Oriente', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(212, 'Padel Domo', 'Distrito Domo, Santa Catarina, Nuevo Leon', NULL, '[\"8116908076\"]', 'Monterrey', '', 'Nuevo León'),
(213, 'Republica Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(214, 'Numa Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(215, 'Padel Palo Blanco', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(216, 'Padel Camp', 'San Pedro, Garza García', NULL, '[\"8120305100\"]', 'Monterrey', '', 'Nuevo León'),
(217, 'Cuatro Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(218, 'Padel Point', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(219, 'Padel Chepevera', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(220, 'City Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(221, 'Maxima Padel & Pickleball', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(222, 'Club Sonoma', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(223, 'Padel Spot Kalcho', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(224, 'Padel Nia', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(225, 'We Padel San Nicolas', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(226, 'Pick and Padel Community', 'Cumbres Poniente', NULL, '[\"8115780599\"]', 'Monterrey', '', 'Nuevo León'),
(227, 'Padel G8', 'Av. Cumbres Madeiras 8993', NULL, '[\"8128603686\"]', 'Monterrey', '', 'Nuevo León'),
(228, 'SB Padel', '', NULL, '[]', 'Monterrey', '', 'Nuevo León'),
(229, 'Padel Factory', '', NULL, '[\"3331748166\"]', 'Guadalajara', '', 'Jalisco'),
(230, 'Smash X Pickle & Padel', '', NULL, '[]', 'Guadalajara', '', 'Jalisco'),
(231, '777 Padel Club', 'Privada del Carmen 1391, Av del servidor público, Zapopan', NULL, '[]', 'Guadalajara', '', 'Jalisco'),
(232, 'Padel Imperial', 'Av. Antiguo Copalita S/N Lote 7, Zapopan', NULL, '[\"3320331237\"]', 'Guadalajara', '', 'Jalisco'),
(233, 'Padel Club GDL', 'Zapopan', NULL, '[\"5544971454\"]', 'Guadalajara', '', 'Jalisco'),
(234, 'Padel Family GDL', 'Zappopan', NULL, '[\"3338008234\"]', 'Guadalajara', '', 'Jalisco'),
(235, 'Carbono Padel Club', 'Andares, Zapopan', NULL, '[\"3343556176\"]', 'Guadalajara', '', 'Jalisco'),
(236, 'Urban Padel Life', 'Av. De las Rosas 171, Col. Chapalita', NULL, '[\"3334868183\"]', 'Guadalajara', '', 'Jalisco'),
(237, 'Grand Padel Guadalajara', 'calle Cristobal Colon 209, Gdl', NULL, '[\"689424407\"]', 'Guadalajara', '', 'Jalisco'),
(238, 'Club Padel Vibora GDL', 'Av. Circunvalación del Bosque 138, Zapopan', NULL, '[\"3330623417\"]', 'Guadalajara', '', 'Jalisco'),
(239, 'Ciudad de la Raqueta Guadalajara', 'calle Victoria Kent 13, Gdl', NULL, '[\"949887006\"]', 'Guadalajara', '', 'Jalisco'),
(240, 'Fair Play Padel', 'calle Francisco de Medina y Mendoza 16, Cabanillas', NULL, '[\"645090909\"]', 'Guadalajara', '', 'Jalisco'),
(241, 'Padel Cabanillas Golf', 'calle Paraje de la Dehesa s/n Cabanillas del Campo', NULL, '[\"646391237\"]', 'Guadalajara', '', 'Jalisco'),
(242, 'Spider Padel', '', NULL, '[]', 'Guadalajara', '', 'Jalisco'),
(243, 'Padel Santa Anita', 'Av. Ramon Corona 658, 45640 San Agustin, Jalisco', NULL, '[\"3326357957\",\"3318504959\"]', 'Guadalajara', '', 'Jalisco'),
(244, 'Goat Padel Club', '', NULL, '[\"8714586610\"]', 'Guadalajara', '', 'Jalisco'),
(245, 'X3 Padel Club', 'Calzada de los Paraisos 13, Zapopan Jalisco', NULL, '[\"3346746719\"]', 'Guadalajara', '', 'Jalisco'),
(246, 'Padel & Beer Club de Padel', 'Av. Guadalupe 4782, Zapopan', NULL, '[]', 'Guadalajara', '', 'Jalisco'),
(247, 'Wolf Padel Club', 'Av. Normalistas 3106, San Elías 44246 Guadalajara', NULL, '[\"3330479935\"]', 'Guadalajara', '', 'Jalisco'),
(248, 'Slice Padel Club', 'Calzada Central 16-A Zapopan, Jalisco', NULL, '[\"3315269635\"]', 'Guadalajara', '', 'Jalisco'),
(249, 'Punto Raqueta', 'Zapotlanejo, Jalisco', NULL, '[\"3335899383\",\"3731010730\"]', 'Guadalajara', '', 'Jalisco'),
(250, 'Padel Siete', 'Siete Colinas 1682', NULL, '[\"3343208844\"]', 'Guadalajara', '', 'Jalisco'),
(251, 'Alebrije 741', 'Av. Acueducto 6050 int. 37', NULL, '[\"3334688026\"]', 'Guadalajara', '', 'Jalisco'),
(252, 'Altium Complex Padel', '', NULL, '[\"3323499103\",\"3315461585\"]', 'Guadalajara', '', 'Jalisco'),
(253, 'Padel World Club', 'Av. Aviación 950', NULL, '[\"3314115788\"]', 'Guadalajara', '', 'Jalisco'),
(254, 'Padel Time Club', '', NULL, '[\"3313009402\"]', 'Guadalajara', '', 'Jalisco'),
(255, 'Leones Padel Club', '', NULL, '[\"3334585152\"]', 'Guadalajara', '', 'Jalisco'),
(256, 'Padel Pro Club Oficial', 'Camino Arenero 761, El Bajio 45019, Zapopan, Jalisco', NULL, '[\"5649304539\"]', 'Guadalajara', '', 'Jalisco'),
(257, 'Punto Gana Padel', 'Calle Mixtecas 115, Las Colonias, Tepatitlan de Morelos, Jalisco', NULL, '[\"3343340445\"]', 'Guadalajara', '', 'Jalisco'),
(258, 'Pyramid Padel', 'Prol. Mariano Otero 615, Zapopan, Jalisco', NULL, '[\"3317899316\"]', 'Guadalajara', '', 'Jalisco'),
(259, 'La Reyna Padel Club', 'De las Americas 131, Lomas de Tlaquepaque, Jalisco', NULL, '[\"3312568784\"]', 'Guadalajara', '', 'Jalisco'),
(260, 'Padel Gdl Oficial', '', NULL, '[\"3322548117\"]', 'Guadalajara', '', 'Jalisco'),
(261, 'Carioca Club', 'Club completo \"padel, fut, taekondo, etc\"', NULL, '[\"3313412500\"]', 'Guadalajara', '', 'Jalisco'),
(262, 'South Side Cluib Padel', 'La Cumbre Sur, Guadaljara, Jal.', NULL, '[\"3318078016\"]', 'Guadalajara', '', 'Jalisco'),
(263, 'Sesentas Padel Club', 'Zona Real, Zapopan, Jal.', NULL, '[\"3315742149\"]', 'Guadalajara', '', 'Jalisco'),
(264, 'Red Padel Gdl', 'Av. 5 de mayo 462, Zapopan, Jalisco', NULL, '[\"3316929119\"]', 'Guadalajara', '', 'Jalisco'),
(265, 'We Padel', 'Concordia 435, Zapopan, Jalisco', NULL, '[\"3313140113\"]', 'Guadalajara', '', 'Jalisco'),
(266, 'Smash Padel Club', 'Blvd. Ramon Martin Huerta 1311, San Juan de los Lagos, Jalisco', NULL, '[\"3951172030\"]', 'Guadalajara', '', 'Jalisco'),
(267, 'La Red Club de Padel', 'San Juan Ocotan, Zapopan, Jalisco', NULL, '[\"3318696632\"]', 'Guadalajara', '', 'Jalisco'),
(268, 'Padel Guadalupe', 'Camellon Av. Guadalupe 6000 y Av. Copérnico, Zapopan, Jalisco', NULL, '[\"3316052297\"]', 'Guadalajara', '', 'Jalisco'),
(269, 'Real Padel Indoor Club', 'A. Servidor público 1195, Zapopan, Jalisco', NULL, '[\"3334046601\"]', 'Guadalajara', '', 'Jalisco'),
(270, 'Ciudad Deportiva El Coto Padel', 'Av. Bruselas s/n Urb. El Coto \"El Cesar\"', NULL, '[\"639982921\"]', 'Guadalajara', '', 'Jalisco'),
(271, 'Club Premier Metepec', '', NULL, '[\"5554184446\"]', 'Toluca', '', 'Estado de México'),
(272, 'Padel Play Toluca', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(273, 'Club Society Padel & Golf', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(274, 'Padel Center Metepec (2)', 'Town Square  y Condado Metepec', NULL, '[\"7226471599\",\"7292749333\"]', 'Toluca', '', 'Estado de México'),
(275, 'Padek', '2001-2 Jesus Reyes Heroles, Toluca, México', NULL, '[\"7227024079\"]', 'Toluca', '', 'Estado de México'),
(276, 'Padelville Calimaya', 'Calimaya, Estado de México', NULL, '[\"7221566797\"]', 'Toluca', '', 'Estado de México'),
(277, 'Padel 4', 'Metepec, Edo de Mex.', NULL, '[\"7223612523\"]', 'Toluca', '', 'Estado de México'),
(278, 'Padel Sports Pit', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(279, 'Bellavista Padel Metepec', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(280, 'Club de Padel Foresta Dreams', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(281, 'Padel Planet', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(282, 'Club de Padel & Pickleball Jinetes', '', NULL, '[\"7222923051\"]', 'Toluca', '', 'Estado de México'),
(283, 'Padel Tex', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(284, 'Padel Premier Zama', 'Coacalco, Estado de México', NULL, '[\"7225469044\"]', 'Toluca', '', 'Estado de México'),
(285, 'Padel Club Arboreto', 'Metepec, Edo de Mex.', NULL, '[\"7222256581\"]', 'Toluca', '', 'Estado de México'),
(286, 'Padel Club Gavilanes', '', NULL, '[]', 'Toluca', '', 'Estado de México'),
(287, 'Swing Padel Club', 'Cabo, San Lucas', NULL, '[\"6243163432\"]', 'Los Cabos', '', 'Baja California Sur'),
(288, 'Palé Club Padel', '', NULL, '[]', 'Los Cabos', '', 'Baja California Sur'),
(289, '40-0 Padel Club', 'Cabo San Lucas', NULL, '[\"6241136873\"]', 'Los Cabos', '', 'Baja California Sur'),
(290, 'Cardon Padel', 'Cabo San Lucas', NULL, '[\"5545453106\"]', 'Los Cabos', '', 'Baja California Sur'),
(291, 'Evolution Padel Los Cabos', '', NULL, '[\"6241325815\"]', 'Los Cabos', '', 'Baja California Sur'),
(292, 'Leclub Padel', '', NULL, '[]', 'Los Cabos', '', 'Baja California Sur'),
(293, 'Jungle Padel Tulum', 'Tulum', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(294, 'Tulum Padel Social Club', 'Tulum', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(295, 'Padel Club Cancun', 'Calle Laureles Álamos II Av .Huayacán Avenida Álamos 1', NULL, '[\"9982602490\"]', 'Riviera Maya', '', 'Quintana Roo'),
(296, 'Journey Padel Arena', 'Manzana 185, Calle Nogal', NULL, '[\"9981053445\"]', 'Riviera Maya', '', 'Quintana Roo'),
(297, 'Garden Padel Club', 'Carr. Tulum - Cancún 1215, Alfredo V. Bonfil, 77560', NULL, '[\"9987366233\"]', 'Riviera Maya', '', 'Quintana Roo'),
(298, 'Prime Padel Arena Cancun', 'Cancun', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(299, 'One Padel Cumbres', 'Cancun', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(300, 'Raquet Padel Club', 'Cancun', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(301, 'Padel Aqua', 'Cancun', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(302, 'Utopia', 'Cancun', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(303, 'Elite Padel', 'Playa del Carmen', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(304, 'Sport Tennis y Padel', 'Playa del Carmen', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(305, 'Xmash Padel Family Padel', 'Playa del Carmen', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(306, 'Heat Padel & Pickleball', 'Playa del Carmen', NULL, '[]', 'Riviera Maya', '', 'Quintana Roo'),
(307, 'All 4 Padel Adidas Club', 'Playa del Carmen', NULL, '[\"9842530780\"]', 'Riviera Maya', '', 'Quintana Roo'),
(308, '111 Top Garden Cancun', 'Cancun', '', '[\"9981810191\"]', 'Riviera Maya', '', 'Quintana Roo'),
(309, 'Top Spin Club', 'Kaybe Tulum', NULL, '[\"5528988100\"]', 'Riviera Maya', '', 'Quintana Roo'),
(310, 'Sportres Club de Padel', 'Manzana F lote baldio sm313, Fonatour Y Huayacan calle Encino 313, Can.', NULL, '[\"9981235535\"]', 'Riviera Maya', '', 'Quintana Roo'),
(311, 'Padel Costa Veracruz', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(312, 'Az Padel Boca', 'Av. Ruiz Cortines 1350, Boca del Río', NULL, '[\"2296795628\"]', 'Veracruz', '', 'Veracruz'),
(313, 'Grand Padel Club Veracruz', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(314, 'Distrito Padel Veracruz', 'Guadalupe Victoria 1484, esq. Raz y Guzman, Col. Formando Hogar', NULL, '[\"2297111197\"]', 'Veracruz', '', 'Veracruz'),
(315, 'Sporting Padel Club Veracruz', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(316, 'CC Padel Club', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(317, 'Puerto Padel Veracruz', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(318, 'Black Padel', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(319, 'Las Palmas Padel', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(320, 'The Black Padel', 'Carretera Playa de Vacas 1158, 94274 Dos Bocas, Ver.', NULL, '[\"2294471535\"]', 'Veracruz', '', 'Veracruz'),
(321, 'Professional Padel Academy', 'PGL Calle Chiapas 3 de Mayo, Xalapa', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(322, 'Ace Padel Xalapa', 'Jose Emparam Esquina, Av. 20 de Nov. 2, Xalapa, Ver.', NULL, '[\"2281397107\"]', 'Veracruz', '', 'Veracruz'),
(323, 'Set Padel Coatepec', 'Carretera Nueva Xalapa-Coatepec 108, Coatepec, Veracruz', NULL, '[\"2281020188\"]', 'Veracruz', '', 'Veracruz'),
(324, 'Sports Park Xalapa', '', NULL, '[\"2281381769\"]', 'Veracruz', '', 'Veracruz'),
(325, 'Padel Suaces', '', NULL, '[]', 'Veracruz', '', 'Veracruz'),
(326, 'Padel City Mérida', 'Plaza La Isla Mérida calle 24 608', NULL, '[\"9998023831\"]', 'Mérida', '', 'Yucatán'),
(327, 'Área Padel', 'Calle 60 299', NULL, '[\"9999929228\"]', 'Mérida', '', 'Yucatán'),
(328, 'Kem Padel Club', 'C. 16 402-A, Montebello, 97113 Mérida, Yuc.', NULL, '[\"9999967260\"]', 'Mérida', '', 'Yucatán'),
(329, 'Pro Padel Mérida', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(330, 'Épica Academia Padel Club', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(331, 'Go Padel', 'Calle 36 Diagonal 357B, Fraccionamiento Montebello, Merida, Yuc.', NULL, '[\"9992329756\"]', 'Mérida', '', 'Yucatán'),
(332, 'All 4 Padel Club Mérida', 'Calle 20 Altabrisa, Mérida', NULL, '[\"99945102524\"]', 'Mérida', '', 'Yucatán'),
(333, 'Padel 21', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(334, 'Club Cumbres', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(335, 'Padel Nuevo Yucatan', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(336, 'GEA Padel Center', 'Calle 17 13080 Mérida, Yuc.', NULL, '[\"9992428507\"]', 'Mérida', '', 'Yucatán'),
(337, 'Casa Padel', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(338, 'Prime Padel', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(339, 'Padel Coriasso', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(340, 'Padel Chi Chi', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(341, 'MB Padel Academy', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(342, 'Padel Gran Santa Fe Norte', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(343, 'Lets Padel', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(344, 'One Padel Club', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(345, 'Más Padel Cholul Club', 'Mérida', NULL, '[]', 'Mérida', '', 'Yucatán'),
(346, 'Gran Padel Río', 'Blvd. Padre Kino 11082, Zona Rio, Tijuana', NULL, '[\"663 203 4372\"]', 'Tijuana', '', 'Baja California'),
(347, 'Flou Padel Club Heroes', 'Ave. Paseo de los Heroes 10810', NULL, '[\"664 765 0848\"]', 'Tijuana', '', 'Baja California'),
(348, 'Flou Padel Club New City', 'Blvd. Padre Kino 1325, Zona Rio, Tijuana', NULL, '[\"664 765 0848\"]', 'Tijuana', '', 'Baja California'),
(349, 'Spin Padel', 'Via Rapida ote. 11942-2, Col. Sepanal, Tijuana', NULL, '[\"6649066621\"]', 'Tijuana', '', 'Baja California'),
(350, 'Otay Padel Club', 'Ave. Universidad 13516, Col, Induce Universidad, Tim', NULL, '[\"664 301 7879\"]', 'Tijuana', '', 'Baja California'),
(351, 'Lago Padel Club', 'Ave. Paseo del Lago 16822, Col. Lago Sur, Tij', NULL, '[\"664 923 6683\"]', 'Tijuana', '', 'Baja California'),
(352, 'Santa Fe Padel Club Tijuana', 'C. San Juan 7827, San Agustin, La Gloria, Tijuana', NULL, '[\"664 767 0287\"]', 'Tijuana', '', 'Baja California'),
(353, 'Baja Padel Club', 'Rio Tijuana 3a. Etapa, Tijuana', NULL, '[\"664 214 1100\"]', 'Tijuana', '', 'Baja California'),
(354, 'Frontera Padel Club', 'Blvd. Manuel J. Clothier 6204, El Guaycura, Tijuana', NULL, '[\"664 794 4455\"]', 'Tijuana', '', 'Baja California'),
(355, 'Pacifico Padel Club (Rosarito)', 'Plan San Luis, Playas de Rosario', NULL, '[]', 'Tijuana', '', 'Baja California'),
(356, 'Sport Zone Club', 'Ave. San Marcos 253, Nueva Ensenada, Ensenada', NULL, '[\"646 388 1569\"]', 'Ensenada', '', 'Baja California'),
(357, 'Club de Padel Las Palmas', 'Ave. Gral. Agustin Sangines 206, Carlos Pacheco, Ens', NULL, '[\"646 273 0294\"]', 'Ensenada', '', 'Baja California'),
(358, 'Pacifico Padel Club (Ensenada)', 'Plinta y Guaymas, Ensenada', NULL, '[\"646 127 7455\"]', 'Ensenada', '', 'Baja California'),
(359, 'Costa Padel', 'Plinta 380, Acapulco, Ensenada', NULL, '[\"646 148 8577\"]', 'Ensenada', '', 'Baja California'),
(360, 'San Marino Padel Club', 'Ave. Jose de Jesus Clark Flores, Coronets, Ensenada', NULL, '[\"646 179 1406\"]', 'Ensenada', '', 'Baja California'),
(361, 'Coral y Marina Padel Club', 'Km 103 Carretera Tij-Ens', NULL, '[\"646 143 8849\"]', 'Ensenada', '', 'Baja California'),
(362, 'Padel Point', 'El Sauzal de Rodríguez, Ensenada', NULL, '[\"646 162 4899\"]', 'Ensenada', '', 'Baja California'),
(363, 'La Cima Padel Club', 'Batopilas, Fracc. Lomas, Ensenada', NULL, '[]', 'Ensenada', '', 'Baja California'),
(364, 'Padel DiVino', 'Carretera Ens-Tecate Km 92.5', NULL, '[]', 'Ensenada', '', 'Baja California'),
(365, 'Padel Norte Club Deportivo Cetys', 'Calz. Cetys 4053, Mexicali', NULL, '[\"686 230 8049\"]', 'Mexicali', '', 'Baja California'),
(366, 'Central Padel Club Deportivo', 'Calz Independencia 210, Mexicali', NULL, '[\"686 161 1809\"]', 'Mexicali', '', 'Baja California'),
(367, 'Centura Padel Club', 'Blvd. Lázaro Cárdenas 1565, Mexicali', NULL, '[\"686 608 6712\"]', 'Mexicali', '', 'Baja California'),
(368, 'iPadel Mexicali', 'Av. De Los Insurgentes 1540, Mexicali', NULL, '[\"686 120 8299\"]', 'Mexicali', '', 'Baja California'),
(369, 'Indor Club', 'Av. República De Paraguay 103, Mexicali', NULL, '[\"686 429 9031\"]', 'Mexicali', '', 'Baja California'),
(370, 'Bodega Padel', 'José Ma. Larroque 1375, Mexicali', NULL, '[]', 'Mexicali', '', 'Baja California'),
(371, 'Fisic Fitness Padel', 'Calzada Anahuac 1301-2, Mexicali', NULL, '[\"686 555 5556\"]', 'Mexicali', '', 'Baja California'),
(372, 'Centinela Pádel Club', 'Ucrania 2450, Mexicali', NULL, '[]', 'Mexicali', '', 'Baja California'),
(373, 'Casino de Mexicali (Privado)', 'Av. José María Pino Suárez 2001, Mexicali', NULL, '[\"686 553 5880\"]', 'Mexicali', '', 'Baja California'),
(374, 'Padel Norte Macristy', 'Calz Macristy de Hermosillo, Mexicali', NULL, '[\"686 348 8311\"]', 'Mexicali', '', 'Baja California'),
(375, 'Padel California Club', 'Cjon. Cuauhtémoc 1251, Mexicali', NULL, '[]', 'Mexicali', '', 'Baja California'),
(376, 'Palestra Club Deportivo', 'Prof. Rode M. Landeros 842, Rivera, Mexicali', NULL, '[\"686 184 4490\"]', 'Mexicali', '', 'Baja California'),
(377, 'Zona Padel', 'Calz. Cetys 2945, Mexicali', NULL, '[\"686 124 0666\"]', 'Mexicali', '', 'Baja California'),
(378, 'Padelux Sport Center', 'Callejon Cuauhtemoc 1251, Mexicali, Baja California', NULL, '[\"6861920793\"]', 'Mexicali', '', 'Baja California'),
(379, 'Unio Sports Club', 'Calz. Cetys 4015, Mexicali', NULL, '[\"686 241 5468\"]', 'Mexicali', '', 'Baja California'),
(380, 'Zona Padel Chihuahua', 'Altozano, Real Escondido Sur', NULL, '[\"6143609216\"]', 'Chihuahua', '', 'Chihuahua'),
(381, 'Sports Club Leones', 'Av. Glandorf 4101, San Felipe, Etapa, 31210', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(382, 'Padel House Chihuahua', 'Av. Hacienda de los Morales y Av. Tomas Valles', NULL, '[\"6144447817\"]', 'Chihuahua', '', 'Chihuahua'),
(383, 'Noro Padel Club', '', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(384, 'Elite Padel', '', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(385, 'We Padel Cantera', '', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(386, 'Padel La Cerve', '', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(387, 'Room Padel', '', NULL, '[\"6142079081\",\"6141995949\"]', 'Chihuahua', '', 'Chihuahua'),
(388, 'Padel Studio', '', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(389, 'Distrito Padel', '', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(390, 'Rock And Padel', 'Av. Monteverde 14403', NULL, '[\"6141199384\"]', 'Chihuahua', '', 'Chihuahua'),
(391, 'Indoor Padel Delicias', 'Ciudad de Delicias, Chihuahua', NULL, '[\"6142764528\"]', 'Chihuahua', '', 'Chihuahua'),
(392, 'Que Padel Chihuahua', '', NULL, '[]', 'Chihuahua', '', 'Chihuahua'),
(393, 'Tropical Padel Puerto Vallarta', '', NULL, '[]', 'Riviera Nayarit', '', 'Nayarit'),
(394, 'KYU Padel Club', 'Avenida México 1285', NULL, '[\"3223032521\"]', 'Riviera Nayarit', '', 'Nayarit'),
(395, 'Clubes Marco Fabian', '', NULL, '[\"15126947603\"]', 'Riviera Nayarit', '', 'Nayarit'),
(396, 'Punto Rojo Padel Club', '', NULL, '[\"3223228648\",\"3221910412\"]', 'Riviera Nayarit', '', 'Nayarit'),
(397, 'Cumarú Padel Club', 'Av. Francisco Villa 1526, Macroplaza, Puerto Vallarta, Jalisco', NULL, '[\"3221946419\"]', 'Riviera Nayarit', '', 'Nayarit'),
(398, 'Padel 233', 'Av. Manuel Lepe 216, Puerto Vallarta', NULL, '[\"3223230894\"]', 'Riviera Nayarit', '', 'Nayarit'),
(399, 'Pik N Pad', '', NULL, '[]', 'Riviera Nayarit', '', 'Nayarit'),
(400, 'Punto Zero', '', NULL, '[]', 'Riviera Nayarit', '', 'Nayarit'),
(401, 'Doopla Padel Club', '', NULL, '[]', 'Riviera Nayarit', '', 'Nayarit'),
(402, 'Colima Padel Club', 'Av. Ignacio Sandoval 1949, Paseo de la Cantera, Colima', NULL, '[\"3121941852\"]', 'Riviera Nayarit', '', 'Nayarit'),
(403, 'Punto Padel Social Club', 'Calle Celestino Sóstenes 100, Puente de San Cayetano, Tepic, N.', NULL, '[\"3111353351\"]', 'Riviera Nayarit', '', 'Nayarit'),
(404, 'Sky Padel Colima', 'Colima', NULL, '[\"3121776205\"]', 'Riviera Nayarit', '', 'Nayarit'),
(405, 'QR Padel Colima', 'H. Ayuntamiento 690, centro, Villa de Alvarez', NULL, '[\"3121009003\"]', 'Riviera Nayarit', '', 'Nayarit'),
(406, 'Bahia Scoail Sports Club', 'Paseo de los Flamingos 38, Bahía de Banderas, Nayarit', NULL, '[\"3221818382\"]', 'Riviera Nayarit', '', 'Nayarit'),
(407, 'Club Deportivo El Tigre Nayarit', '', NULL, '[]', 'Riviera Nayarit', '', 'Nayarit'),
(408, 'All4PAdel Club Mazatlan', 'Av. Paseo del Pacífico 3500, Marina Mazatlán', NULL, '[\"6691501276\"]', 'Mazatlán', '', 'Sinaloa'),
(409, 'Clubes Marco Fabian', '', NULL, '[\"6566266097\"]', 'Mazatlán', '', 'Sinaloa'),
(410, 'Padel World Marina', 'Av. Paseo del Atlantico 6115-B', NULL, '[\"6691662352\"]', 'Mazatlán', '', 'Sinaloa'),
(411, 'Padel Place Mazatlan', 'Av. Del Delfin 6201-A', NULL, '[\"6699328447\"]', 'Mazatlán', '', 'Sinaloa'),
(412, 'Padel Prix Mazatlan', '', NULL, '[]', 'Mazatlán', '', 'Sinaloa'),
(413, 'Padel World Sunset', '', NULL, '[]', 'Mazatlán', '', 'Sinaloa'),
(414, 'Punta Padel', 'Orquideas 415, Irapuato', NULL, '[\"4621490525\"]', 'Irapuato/Salamanca', '', 'Guanajuato'),
(415, 'Padelismo Indoor Padel Club', 'Gabriel Garcia Marquez 4495, San Francisco', NULL, '[\"4622516417\"]', 'Irapuato/Salamanca', '', 'Guanajuato'),
(416, 'Tie Break Irapuato Padel Club', 'Padeo de la Altiplanicie 3567, Villas de Irapuato', NULL, '[]', 'Irapuato/Salamanca', '', 'Guanajuato'),
(417, 'Prana Padel Club', '', NULL, '[]', 'Irapuato/Salamanca', '', 'Guanajuato'),
(418, 'Lykan Club', 'Carretera Salamanca-La Ordeña km 1-300, Campestre, Salamanca', NULL, '[\"4641195855\"]', 'Irapuato/Salamanca', '', 'Guanajuato'),
(419, 'Black Padel & Sport Zone', '', NULL, '[\"4621495033\"]', 'Irapuato/Salamanca', '', 'Guanajuato'),
(420, 'Americas Padel Academy', '', NULL, '[\"4432722646\"]', 'Morelia', '', 'Michoacán'),
(421, 'Top Sport Padel Club', 'Av. Acueducto758 chapultepec norte, Morelia', NULL, '[\"4433283661\"]', 'Morelia', '', 'Michoacán'),
(422, 'Padel X Club Morelia', '', NULL, '[\"4434704484\"]', 'Morelia', '', 'Michoacán'),
(423, 'Padel Bros Club', '', NULL, '[\"4438391364\"]', 'Morelia', '', 'Michoacán'),
(424, 'Blue Padel Club', '', NULL, '[]', 'Morelia', '', 'Michoacán'),
(425, 'Padel Box', '', NULL, '[]', 'Morelia', '', 'Michoacán'),
(426, 'Ananda Padel House Morelia', '', NULL, '[]', 'Morelia', '', 'Michoacán'),
(427, '365 Padel Club', 'Blvd. Manuel Gomez Morin 395, Villa Magna SLP', NULL, '[\"4444483327\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(428, 'Padel Park San Luis', 'Sierra Vista, Lomas 4ta Sección, SLP', NULL, '[\"4442044524\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(429, 'Padel Center San Luis', 'Francisco Martinez de la Vega 150, Industrias SLP', NULL, '[\"4443177108\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(430, 'The Royal Padel Club', 'Parque Royal 205, SLP', NULL, '[\"4443928190\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(431, 'Padel Masters Zone', '', NULL, '[\"4446314285\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(432, 'Padel Madness', '', NULL, '[\"4401050983\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(433, 'Seis Dos Padel', '', NULL, '[\"4443211363\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(434, 'Rou Padel Club SLP', 'Calzada de los pintores 19', NULL, '[\"4441414280\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(435, 'Villa Padel SLP', 'Camino a Santa Rita 222, Pozos, SLP', NULL, '[\"4444236480\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(436, 'X Padel SLP', 'Río Nazas 155 SLP', NULL, '[]', 'San Luis Potosi', '', 'San Luis Potosí'),
(437, 'Lomas Padel Club', 'Av. Cordillera Karakorum 120, Lomas 4ta secc. 78120, SLP', NULL, '[\"4444326007\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(438, 'Advantage Padel', 'Av. Nereo Rodriguez Barragan 1340, SLP', NULL, '[\"4423432913\"]', 'San Luis Potosi', '', 'San Luis Potosí'),
(439, 'Gold Padel Celaya', 'Av. Irrigación 550', NULL, '[\"4613003221\"]', 'Celaya', '', 'Guanajuato'),
(440, 'Padel Campestre', 'Luis Donaldo Colosio, Ribera del Campestre 251-1', NULL, '[\"4613308465\"]', 'Celaya', '', 'Guanajuato'),
(441, 'Momentum Padel Center', 'Juan Rodriguez Patiño 211', NULL, '[\"4612771282\"]', 'Celaya', '', 'Guanajuato'),
(442, 'Blackzone Padel', 'Blvd. Adolfo Lopez Mateos 1566, col. Renacimiento', NULL, '[\"4612313117\"]', 'Celaya', '', 'Guanajuato'),
(443, 'Padel Haus', 'Camino a San Jose de Guanajuato', NULL, '[\"4611300424\"]', 'Celaya', '', 'Guanajuato'),
(444, 'Match Point Celaya', 'Camino a San Jose de Guanajuato km 4-5', NULL, '[\"4613988914\"]', 'Celaya', '', 'Guanajuato'),
(445, 'Punto de Oro Oaxaca', 'Calle 5 de Mayo 102, col. San Felipe del Agua', NULL, '[\"9514780609\"]', 'Oaxaca', '', 'Oaxaca'),
(446, 'Globo Padel Oaxaca', 'Carretera Internacional km 11.5', NULL, '[\"9514019368\"]', 'Oaxaca', '', 'Oaxaca'),
(447, 'Sport Plus Arena', 'Camino de la Horqueta 558, Santa Cruz', NULL, '[\"9514584084\"]', 'Oaxaca', '', 'Oaxaca'),
(448, 'I Play Padel', 'Carlos Gracida 160, &ta sección, San Antonio de la Cal', NULL, '[\"9513510523\"]', 'Oaxaca', '', 'Oaxaca'),
(449, 'Bien Padel', 'Calvario, La Trinidad 6ta sección, Tlalixtac de Cabrera', NULL, '[\"9512210065\"]', 'Oaxaca', '', 'Oaxaca'),
(450, 'Padel Vibres Oaxaca', '', NULL, '[\"9516508888\"]', 'Oaxaca', '', 'Oaxaca'),
(451, 'Volea Padel Oaxaca', 'El Horizonte 103, 68259, Hacienda Blanca', NULL, '[\"9515818505\"]', 'Oaxaca', '', 'Oaxaca'),
(452, 'Bacocho Club Padel & Tenis', 'Puerto Escondido', NULL, '[\"9545820061\",\"9541324874\"]', 'Oaxaca', '', 'Oaxaca'),
(453, 'Padel Zone Brenamiel', 'Av. Ferrocarril 218, Granjas y Huertos de Brenamiel, San Jacinto', NULL, '[\"9512448416\"]', 'Oaxaca', '', 'Oaxaca'),
(454, 'Padel One Club', 'Carretera Torreon San Pedro 2950, Plaza 5 7', NULL, '[\"8714018979\"]', 'Torreon', '', 'Coahuila'),
(455, 'Play Padel Laguna', 'San Pedro de las Colonias, Ejido Paso del Aguila 27416', NULL, '[\"8713452481\"]', 'Torreon', '', 'Coahuila'),
(456, 'El Clubsito', 'Calle Nogales 2, 27422 La Concha', NULL, '[\"8711924911\"]', 'Torreon', '', 'Coahuila'),
(457, 'Padel Match Moroleón', 'Calle Salvador Díaz Mirón 43, Lomas del Valle II, Moroleon', NULL, '[\"4451415085\"]', 'Moroleón/Uruapan', '', 'Guanajuato'),
(458, 'Pro Padel Uruapan', 'Privada Latinoamericana 5, col. Los Angeles, Uruapan', NULL, '[\"4521056309\"]', 'Moroleón/Uruapan', '', 'Michoacán'),
(459, 'Corona Club Padel Moroleon', 'Ponciano Vega 1323', NULL, '[\"4451000911\"]', 'Moroleón/Uruapan', '', 'Guanajuato'),
(460, 'Pure Padel Moroleon', 'Junto a BIMBO, Calle Ponciano Vega', NULL, '[\"4451412313\"]', 'Moroleón/Uruapan', '', 'Guanajuato'),
(461, 'Padel Club La Hacienda Moroleon', 'Carrera Moroleon-Piñicuaro 4185', NULL, '[\"4451414331\"]', 'Moroleón/Uruapan', '', 'Guanajuato'),
(462, 'Woolis Padel Club', 'Tuxtla Gutierrez', NULL, '[\"9612830282\"]', 'Chiapas', '', 'Chiapas'),
(463, 'Tropiko Club Deportivo', 'Libramiento Sur Poniente 1000, col. Buenos Aires', NULL, '[\"9621426561\"]', 'Chiapas', '', 'Chiapas'),
(464, 'Volea Padel Club', 'Tuxtla Gutierrez', NULL, '[\"9618256447\"]', 'Chiapas', '', 'Chiapas'),
(465, 'Marca Padel Premier Club', 'Plan de Ayala, 29020 Tuxtla Gutierrez', NULL, '[\"9613360157\"]', 'Chiapas', '', 'Chiapas'),
(466, 'Global Sport Padel Club', 'Calle Paris, esq. Montes de Oca 290, col. La Salle', NULL, '[\"9613652960\"]', 'Chiapas', '', 'Chiapas'),
(467, 'Match Point 360', 'Blvd. Belisario Dominguez 1820, col. Arboledas', NULL, '[\"9615857863\"]', 'Chiapas', '', 'Chiapas'),
(468, 'High Padel Club', 'El Sumidero 24, Col. El Relicario, San Cristobal', NULL, '[\"9671410459\"]', 'Chiapas', '', 'Chiapas'),
(469, 'Brava Padel Club', '8 Av. Poniente Sur, Col. Primero de Mayo', NULL, '[\"9632723113\"]', 'Chiapas', '', 'Chiapas'),
(470, 'Padel Tacaná', 'Prolongación central norte, Tapachula', NULL, '[\"9622888360\"]', 'Chiapas', '', 'Chiapas'),
(471, 'DUO Padel Park Hermosillo Centro', 'Av. Tamaulipas 54', NULL, '[\"6624540047\"]', 'Hermosillo', '', 'Sonora'),
(472, 'DUO Padel Park Navarrete', 'Blvd. Juan Navarrete 484', NULL, '[\"6624539373\"]', 'Hermosillo', '', 'Sonora');
INSERT INTO `directorio_clubes` (`id_directorio_club`, `nombre`, `direccion`, `url`, `telefonos`, `ciudad`, `pais`, `estado`) VALUES
(473, 'DOMO Indoor Padel', 'Plaza Andenes, Blvd. Luis Donaldo Colosio, Calz. De los A.', NULL, '[\"6622572402\"]', 'Hermosillo', '', 'Sonora'),
(474, 'BrotherHood Padel', 'Blvd. Juan Navarrete 460', NULL, '[\"6624308013\"]', 'Hermosillo', '', 'Sonora'),
(475, 'La Casa del Padel', 'Blvd. Juan Navarrete 706', NULL, '[\"6621808757\"]', 'Hermosillo', '', 'Sonora'),
(476, 'Cactus Padel', 'Blvd. Juan Navarrete 720', NULL, '[\"6622815588\"]', 'Hermosillo', '', 'Sonora'),
(477, 'Padel Zone Hermosillo', 'Real Quiroga s/n 83224', NULL, '[\"6672277162\"]', 'Hermosillo', '', 'Sonora'),
(478, 'Padel Kino', 'Blvd. Francisco Eusebio Kino 321 Country Club', NULL, '[\"6624757521\"]', 'Hermosillo', '', 'Sonora'),
(479, 'Desert Padel Indoor Salamanca', 'Salamnca a 373, col. Las Amapolas', NULL, '[]', 'Hermosillo', '', 'Sonora'),
(480, 'DUO Padel Park UPDAY', 'Calle Olivares 520, Jardines de Monaco', NULL, '[\"6622686955\"]', 'Hermosillo', '', 'Sonora'),
(481, 'Central Padel Saltillo', 'Blvd. Jose Musa de Leon 3286', NULL, '[\"8443342477\"]', 'Saltillo', '', 'Coahuila'),
(482, 'Padel GM Saltillo', 'F22G 5M, col. 16, 25270', NULL, '[\"8110438734\"]', 'Saltillo', '', 'Coahuila'),
(483, 'South Padel', 'Calle 18 31, col. Lourdes 25070', NULL, '[\"8445397671\"]', 'Saltillo', '', 'Coahuila'),
(484, 'Net Padel Club', 'Blvd. Parque Centro 1370, col. Los Parques', NULL, '[\"8442915590\"]', 'Saltillo', '', 'Coahuila'),
(485, 'Punto Padel SLW', 'Blvd. Venustiano Carranza 8220, col. Los Rodriguez', NULL, '[\"8443802768\"]', 'Saltillo', '', 'Coahuila'),
(486, 'Smash Padel', 'Av. Dr. Jose Narro Robles s/n, col. Los Gonzalez', NULL, '[\"8441037952\"]', 'Saltillo', '', 'Coahuila'),
(487, 'Padel Los GNZLZ', 'Blvd. Eulalio Gutierrez Treviño 4108', NULL, '[\"8448920874\"]', 'Saltillo', '', 'Coahuila'),
(488, 'Club W', 'Los Pastores 2900, col. Torrecillas', NULL, '[\"8444435002\"]', 'Saltillo', '', 'Coahuila'),
(489, 'Rebote Indoor Padel', 'Calle 2 203, Col. La Aurora', NULL, '[\"8442991682\"]', 'Saltillo', '', 'Coahuila'),
(490, 'Mirasierra Padel Club', 'Prolongación Calle 2, Blvd. Mirasierra', NULL, '[\"8441222684\"]', 'Saltillo', '', 'Coahuila'),
(491, 'Club D Padel', 'Blvd. Eulalio Gutierrez Treviño 1240', NULL, '[\"8441786390\"]', 'Saltillo', '', 'Coahuila'),
(492, 'Quadro Padel', 'Carretera federal 57, 3553 Poniente, Sabinas, Coahuila', NULL, '[\"8611100347\"]', 'Saltillo', '', 'Coahuila'),
(493, 'Central Padel', 'Calle Pedro Rosales de Leon 6751', NULL, '[\"6568052200\"]', 'Ciudad Juarez', '', 'Chihuahua'),
(494, 'Gallery Padel Club', 'Calle de la Labranza 1820-2', NULL, '[]', 'Ciudad Juarez', '', 'Chihuahua'),
(495, 'Padel Pro Juarez', 'Av. Ejercito Nacional 11163', NULL, '[\"6563392162\"]', 'Ciudad Juarez', '', 'Chihuahua'),
(496, 'Mission Padel Club', 'Av. Paseo de la Victoria 3781', NULL, '[\"6562725173\"]', 'Ciudad Juarez', '', 'Chihuahua'),
(497, 'Desert Padel Club', 'Calle Camino Viejo a Zaragoza 2460', NULL, '[]', 'Ciudad Juarez', '', 'Chihuahua'),
(498, 'The Deuce Club Padel', 'San Fernando 2351', NULL, '[\"6563387806\"]', 'Ciudad Juarez', '', 'Chihuahua'),
(499, 'National Padel', 'Av. Plutarco Elias Calles 2243', NULL, '[\"6565838888\"]', 'Ciudad Juarez', '', 'Chihuahua'),
(500, 'ALL Padel', 'Av. Tecnologico 1860', NULL, '[\"6366922852\"]', 'Ciudad Juarez', '', 'Chihuahua'),
(501, 'Verde Sur Padel Club', 'Miguel Hidalgo 13, Hotel Hacienda el Marques, Guanajuato', NULL, '[\"4731184314\"]', 'Guanajuato', '', 'Guanajuato'),
(502, 'Falguera Padel Club', 'Paseo de la presa 95, col. Barrio de la Presa', NULL, '[\"5555039816\"]', 'Guanajuato', '', 'Guanajuato'),
(503, 'San Padel Social Club', 'San Francisco del Rincón, Guanajuato', NULL, '[\"4761272955\"]', 'Guanajuato', '', 'Guanajuato'),
(504, 'Padel 11:11', 'Tampico', NULL, '[\"8334487193\"]', 'Tampico', '', 'Tamaulipas'),
(505, 'Be Padel Tampico', 'Paseo de los Arcangeles 612', NULL, '[\"8333006065\"]', 'Tampico', '', 'Tamaulipas'),
(506, 'Padel TM', 'Calzada San Pedro 102', NULL, '[\"8331392669\"]', 'Tampico', '', 'Tamaulipas'),
(507, 'Padel 120 Tampico', 'Calle Eduardo 158', NULL, '[\"8332550801\"]', 'Tampico', '', 'Tamaulipas'),
(508, 'Padel Club 833', 'Av. Miguel Hidalgo 6311, col. Choferes', NULL, '[\"8331200044\"]', 'Tampico', '', 'Tamaulipas'),
(509, 'Padel On Club', 'Club Deportivo Balderas 105', NULL, '[\"6182209030\"]', 'Durango', '', 'Durango'),
(510, 'Durango Padel Club', 'El Nayar, Durango', NULL, '[\"6188221518\"]', 'Durango', '', 'Durango'),
(511, 'Padel 618 Durango', 'Calle Guadalupe 423', NULL, '[\"6182719530\"]', 'Durango', '', 'Durango'),
(512, 'Durango Padel-Gol', 'Av. La Salle', NULL, '[\"6182999072\"]', 'Durango', '', 'Durango'),
(513, 'Veinte Diez Padel Club', 'Blvd. Republica 911-A, Piedras Negras', NULL, '[\"8781175235\"]', 'Piedras Negras', '', 'Coahuila'),
(514, 'Padel 3015', 'Ags, Mx.', NULL, '[\"4493069889\"]', 'Aguascalientes', '', 'Aguascalientes'),
(515, 'Padelandia', 'Av. Siglo XXI Norte, Aguascalientes, México', NULL, '[\"4491100305\"]', 'Aguascalientes', '', 'Aguascalientes'),
(516, 'Club de padel Matamoros', 'Blv. Manuel Cavazos Leema 126, Enrique Cardenas, Mat. Tamaulipas', NULL, '[\"8681066518\"]', 'Matamoros', '', 'Tamaulipas'),
(517, 'Punto Padel', 'Las Galeanas 45, Col. Las Jacarandas, La Piedad, Michoacan', NULL, '[\"3521361563\"]', 'La Piedad', '', 'Michoacán'),
(518, 'Top Spin Club', 'Camino a cerro colorado s/n 51200, Valle de Bravo, México', NULL, '[\"5528988100\"]', 'Valle de Bravo', '', 'Estado de México'),
(519, 'Padel Club Avandaro', 'Del Carmen 19, Avandaro, Valle de Bravo, México', NULL, '[\"7221209398\"]', 'Valle de Bravo', '', 'Estado de México'),
(520, 'Deportiva Amanalco', 'Manzana 16, 51260, Amanalco, Estado de México', NULL, '[]', 'Valle de Bravo', '', 'Estado de México'),
(521, 'Yaqui Padel & Golf', 'Blvd. Hidalgo, Plaza Engrei, Reynosa, Tamaulipas', NULL, '[\"8993166580\"]', 'Tamaulipas', '', 'Tamaulipas'),
(522, 'Padel Club Reynosa PCR', 'Sinaloa 1730', NULL, '[\"8999241695\"]', 'Tamaulipas', '', 'Tamaulipas'),
(523, 'Padel Sport Center', 'Rio Poo 302, Col. Santa Maria, El Pasito', NULL, '[\"8999442339\"]', 'Tamaulipas', '', 'Tamaulipas'),
(524, 'Padel Universe Reynosa', 'Blvd. Morelos', NULL, '[\"8991600905\"]', 'Tamaulipas', '', 'Tamaulipas'),
(525, 'Bamboo Padel Carmen', 'Abreu Compañ 31, Fracc. Isla del Carmen 200', NULL, '[\"9381724998\"]', 'Tamaulipas', '', 'Tamaulipas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `egresos`
--

CREATE TABLE `egresos` (
  `id_egreso` int(11) NOT NULL,
  `id_corte_caja` int(11) DEFAULT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_club_metodo_pago` int(11) NOT NULL,
  `concepto` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` datetime NOT NULL,
  `nota` text COLLATE utf8_unicode_ci,
  `id_fraccionamientoclub` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `egresos_ingresos`
--

CREATE TABLE `egresos_ingresos` (
  `id_egresosIngresos` int(11) NOT NULL,
  `concepto` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `monto` float DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `id_fraccionamientoClub` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `comprobante` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tipo` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_cancha` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados`
--

CREATE TABLE `estados` (
  `id_estados` int(11) NOT NULL,
  `est_nombre` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_pais` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `estados`
--

INSERT INTO `estados` (`id_estados`, `est_nombre`, `id_pais`) VALUES
(1, 'Querétro', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estatus_planes`
--

CREATE TABLE `estatus_planes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `color` varchar(7) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `estatus_planes`
--

INSERT INTO `estatus_planes` (`id`, `nombre`, `color`) VALUES
(1, 'Activa', '#28a745'),
(2, 'Expirada', '#6c757d'),
(3, 'Cancelada', '#dc3545');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `evento_categoria`
--

CREATE TABLE `evento_categoria` (
  `id_evento_categoria` int(11) NOT NULL,
  `tipo_evento` enum('reserva','clase','academia') COLLATE utf8_unicode_ci NOT NULL,
  `id_categoria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `evento_categoria`
--

INSERT INTO `evento_categoria` (`id_evento_categoria`, `tipo_evento`, `id_categoria`) VALUES
(1, 'reserva', 69),
(2, 'clase', 9),
(3, 'academia', 14);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `faqs`
--

CREATE TABLE `faqs` (
  `id` int(11) NOT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `pregunta` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `respuesta` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `etiquetas` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vistas` int(11) DEFAULT '0',
  `util_count` int(11) DEFAULT '0',
  `no_util_count` int(11) DEFAULT '0',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `faqs`
--

INSERT INTO `faqs` (`id`, `id_categoria`, `pregunta`, `respuesta`, `etiquetas`, `vistas`, `util_count`, `no_util_count`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(8, 12, '¿Olvidé mi contraseña, cómo puedo recuperarla?', 'En la página de login, da click en \"Olvide mi contraseña\"', '', 1, 0, 0, '2026-03-17 18:27:56', '2026-04-02 18:27:44'),
(9, 13, '¿Cómo me inscribo a un torneo?', 'Cuando haya un torneo disponible', '', 1, 0, 0, '2026-03-17 18:28:43', '2026-04-02 16:38:10'),
(10, 14, '¿Qué métodos de pago acepta Arosports?', 'Pagos con tarjeta', '', 0, 0, 0, '2026-03-17 18:30:56', '2026-03-17 18:30:56'),
(11, 14, '¿Cómo recibo mi comprobante de pago?', 'A través de su cuenta de banco', '', 0, 0, 0, '2026-03-17 18:31:36', '2026-03-17 18:31:36'),
(12, 14, '¿Cómo puedo ver mi historial de pagos?', 'No hay un historial de pagos, pero cada que realizan un pago se les envía un comprobante de pago vía correo. ', '', 0, 0, 0, '2026-03-17 18:32:27', '2026-03-17 18:32:27'),
(13, 15, '¿Qué beneficios obtengo con un plan de suscripción?', 'Varios', '', 0, 0, 0, '2026-03-17 18:33:57', '2026-03-17 18:33:57'),
(14, 16, '¿Cómo contacto al soporte técnico de Arosports?', 'A través del Chatbot dentro de las preguntas frecuentes “FAQ”, en caso de no poder resolver tu problema crear un ticket para que uno de nuestros agentes se ponga en contacto contigo.', '', 0, 0, 0, '2026-03-17 18:34:27', '2026-03-17 18:34:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `faq_categorias`
--

CREATE TABLE `faq_categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `faq_categorias`
--

INSERT INTO `faq_categorias` (`id`, `nombre`, `descripcion`, `fecha_creacion`) VALUES
(12, 'Cuenta y acceso', '', '2026-03-17 18:25:38'),
(13, 'Torneos y uso de la app', '', '2026-03-17 18:25:51'),
(14, 'Pagos y facturación', '', '2026-03-17 18:26:05'),
(15, 'Suscripción y beneficios', '', '2026-03-17 18:26:33'),
(16, 'Soporte y ayuda', '', '2026-03-17 18:26:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fraccionamientoClub_usuarios`
--

CREATE TABLE `fraccionamientoClub_usuarios` (
  `id_fraccionamientoclub` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_club_usuario` int(11) NOT NULL,
  `cus_nombre` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cus_apellido` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cus_telefono` int(11) DEFAULT NULL,
  `cus_correo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cus_fechaRegistro` date DEFAULT NULL,
  `cus_fechaBaja` date DEFAULT NULL,
  `id_status` int(11) NOT NULL,
  `cus_genero` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cus_categoria` int(11) DEFAULT NULL,
  `cus_notas` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `fraccionamientoClub_usuarios`
--

INSERT INTO `fraccionamientoClub_usuarios` (`id_fraccionamientoclub`, `id_usuario`, `id_club_usuario`, `cus_nombre`, `cus_apellido`, `cus_telefono`, `cus_correo`, `cus_fechaRegistro`, `cus_fechaBaja`, `id_status`, `cus_genero`, `cus_categoria`, `cus_notas`) VALUES
(2, NULL, 1, 'che', 'Gonzalez', 0, '', '2026-04-03', NULL, 1, NULL, NULL, 'Creado desde calendario para búsqueda: \"che\"');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fraccionamiento_club`
--

CREATE TABLE `fraccionamiento_club` (
  `id_fraccionamientoclub` int(11) NOT NULL,
  `fc_nombre` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_direccion` int(11) DEFAULT NULL,
  `fc_fechaRegistro` date DEFAULT NULL,
  `tipo` int(11) DEFAULT NULL,
  `imagen` blob,
  `imagen_perfil` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_status` int(11) NOT NULL,
  `stripe_account_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `fraccionamiento_club`
--

INSERT INTO `fraccionamiento_club` (`id_fraccionamientoclub`, `fc_nombre`, `id_direccion`, `fc_fechaRegistro`, `tipo`, `imagen`, `imagen_perfil`, `id_status`, `stripe_account_id`) VALUES
(1, 'Developer', 1, '2026-03-24', NULL, NULL, NULL, 1, 'acct_1TICqtFbNW036zev'),
(2, 'The Club Padel & Academy Qro', 2, '2026-03-25', 5, NULL, './static/uploads/profiles_club/profile_pic_20260325_100548903.jpeg', 1, 'acct_1TF166F56iZRvuEr'),
(5, 'Club Montes', 28, '2026-04-03', 5, NULL, NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horaDiaTorneo`
--

CREATE TABLE `horaDiaTorneo` (
  `id` int(11) NOT NULL,
  `id_torneos` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horarios_club`
--

CREATE TABLE `horarios_club` (
  `id_horario_club` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `dia` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `estatus` binary(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `horarios_club`
--

INSERT INTO `horarios_club` (`id_horario_club`, `id_fraccionamientoclub`, `dia`, `hora_inicio`, `hora_fin`, `estatus`) VALUES
(1, 2, 'Lunes', '07:00:00', '23:00:00', 0x31),
(2, 2, 'Martes', '07:00:00', '23:00:00', 0x31),
(3, 2, 'Jueves', '07:00:00', '23:00:00', 0x31),
(4, 2, 'Viernes', '07:00:00', '23:00:00', 0x31),
(5, 2, 'Domingo', '08:00:00', '14:00:00', 0x31),
(6, 1, 'Lunes', '00:00:00', '15:30:00', 0x31),
(7, 1, 'Martes', '00:00:00', '23:00:00', 0x31),
(8, 1, 'Jueves', '00:00:00', '01:00:00', 0x31),
(9, 1, 'Viernes', '00:00:00', '23:00:00', 0x31),
(10, 1, 'Domingo', '00:00:00', '00:30:00', 0x31),
(11, 1, 'Miercoles', '00:30:00', '23:00:00', 0x31),
(12, 1, 'Sabado', '00:30:00', '01:00:00', 0x31),
(13, 2, 'Miercoles', '07:00:00', '23:00:00', 0x31),
(14, 2, 'Sabado', '08:00:00', '14:00:00', 0x31);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagen_club_fraccionamiento`
--

CREATE TABLE `imagen_club_fraccionamiento` (
  `id_imagen_club_fraccionamiento` int(11) NOT NULL COMMENT 'Primary Key',
  `url_imagen` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_club_fraccionamiento` int(11) DEFAULT NULL,
  `numero_imagen` int(11) DEFAULT NULL,
  `estatus` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `imagen_club_fraccionamiento`
--

INSERT INTO `imagen_club_fraccionamiento` (`id_imagen_club_fraccionamiento`, `url_imagen`, `id_club_fraccionamiento`, `numero_imagen`, `estatus`) VALUES
(1, 'static/uploads/imagenes_referencia/reference_pic_20260325_100603259.jpeg', 2, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingresos`
--

CREATE TABLE `ingresos` (
  `id_ingreso` int(11) NOT NULL,
  `id_corte_caja` int(11) DEFAULT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_reserva` int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_pago_reserva` int(11) DEFAULT NULL,
  `id_club_metodo_pago` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` datetime NOT NULL,
  `concepto` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nota` text COLLATE utf8_unicode_ci,
  `id_fraccionamientoclub` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juegos`
--

CREATE TABLE `juegos` (
  `id_juego` int(11) NOT NULL,
  `jue_nombre` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `jue_fecha` date DEFAULT NULL,
  `jue_hora` time DEFAULT NULL,
  `duracion` time DEFAULT NULL,
  `id_cancha` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_modojuego` int(11) DEFAULT NULL,
  `id_torneo` int(11) DEFAULT NULL,
  `id_tipo` int(11) DEFAULT NULL,
  `id_reserva` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_fraccionamientoclub` int(11) DEFAULT NULL,
  `imagen` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_canchas` int(11) DEFAULT NULL,
  `id_direccion` int(11) DEFAULT NULL,
  `estado` enum('activo','finalizado','pendiente') COLLATE utf8_unicode_ci DEFAULT 'activo',
  `puntos` int(11) DEFAULT '0',
  `num_jugadores` int(11) NOT NULL DEFAULT '4' COMMENT 'Número de jugadores para la jugada (mínimo 4)',
  `puntos_set` int(11) DEFAULT NULL COMMENT 'Puntos por set para Round Robin (id_modojuego 1 y 15)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `juegos`
--

INSERT INTO `juegos` (`id_juego`, `jue_nombre`, `jue_fecha`, `jue_hora`, `duracion`, `id_cancha`, `id_categoria`, `id_modojuego`, `id_torneo`, `id_tipo`, `id_reserva`, `id_usuario`, `id_fraccionamientoclub`, `imagen`, `num_canchas`, `id_direccion`, `estado`, `puntos`, `num_jugadores`, `puntos_set`) VALUES
(1, 'Americana Individual Emilio', '2026-03-26', '12:57:00', '02:00:00', NULL, 4, 14, NULL, 2, 2, 1060, NULL, NULL, 2, 10, 'finalizado', 0, 8, 7),
(2, 'Americana Individual Emilio', '2026-03-26', '13:04:00', '02:00:00', NULL, 4, 14, NULL, 2, 3, 1060, NULL, NULL, 2, 11, 'finalizado', 0, 8, 9),
(3, 'Americana Individual Emilio', '2026-03-26', '13:09:00', '02:00:00', NULL, 4, 14, NULL, 2, 4, 1060, NULL, NULL, 2, 12, 'finalizado', 0, 8, 7),
(4, 'Americana Individual Emilio', '2026-03-26', '13:11:00', '02:00:00', NULL, 4, 14, NULL, 2, 5, 1060, NULL, NULL, 2, 13, 'activo', 0, 8, 7),
(5, 'Americana Individual Monica Montoya ', '2026-03-31', '21:44:00', '02:00:00', NULL, 6, 14, NULL, 2, 6, 1085, NULL, NULL, 1, 14, 'pendiente', 0, 4, 5),
(6, 'Americana Individual Monica Montoya ', '2026-03-31', '22:08:00', '02:00:00', NULL, 6, 14, NULL, 2, 7, 1085, NULL, NULL, 1, 15, 'pendiente', 0, 4, 5),
(7, 'Reta Monica Montoya ', '2026-03-31', '12:34:00', '02:00:00', NULL, 6, 10, NULL, 2, 8, 1085, NULL, NULL, 1, 16, 'pendiente', 0, 4, 0),
(8, 'Americana Parejas Monica Montoya ', '2026-03-31', '16:10:00', '02:00:00', NULL, 6, 16, NULL, 2, 9, 1085, NULL, NULL, 1, 17, 'activo', 0, 4, 5),
(9, 'Americana Parejas Monica Montoya ', '2026-03-31', '16:13:00', '02:00:00', NULL, 6, 16, NULL, 2, 10, 1085, NULL, NULL, 1, 18, 'activo', 0, 4, 8),
(10, 'Americana Individual ', '2026-04-03', '09:29:00', '02:00:00', NULL, 4, 14, NULL, 2, 11, 1060, NULL, NULL, 2, 20, 'finalizado', 0, 8, 8),
(11, 'Americana Individual ', '2026-04-03', '09:32:00', '02:00:00', NULL, 4, 14, NULL, 2, 12, 1060, NULL, NULL, 2, 21, 'finalizado', 0, 8, 8),
(12, 'Americana Individual ', '2026-04-03', '09:50:00', '02:00:00', NULL, 4, 14, NULL, 2, 13, 1060, NULL, NULL, 2, 22, 'finalizado', 0, 8, 8),
(13, 'Americana Individual Francisco Beltrán ', '2026-04-03', '11:05:00', '02:00:00', NULL, 4, 14, NULL, 2, 14, 1088, NULL, NULL, 1, 24, 'finalizado', 0, 4, 6),
(14, 'Reta Francisco Beltrán ', '2026-04-03', '11:51:00', '02:00:00', NULL, 4, 10, NULL, 2, 16, 1088, NULL, NULL, 1, 26, 'finalizado', 0, 4, 0),
(15, 'Americana Parejas Emilio', '2026-04-04', '08:06:00', '02:00:00', NULL, 4, 16, NULL, 2, 17, 1060, NULL, NULL, 2, 29, 'activo', 0, 8, 8),
(16, 'Round Robin Individual Francisco Beltrán ', '2026-04-04', '10:47:00', '02:00:00', NULL, 4, 1, NULL, 2, 18, 1088, NULL, NULL, 3, 30, 'finalizado', 0, 12, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juegos_prueba`
--

CREATE TABLE `juegos_prueba` (
  `id_juegosprueba` int(11) NOT NULL,
  `id_jugador` int(11) DEFAULT NULL,
  `id_modojuego` int(11) DEFAULT NULL,
  `juegopueba_fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juego_canchas`
--

CREATE TABLE `juego_canchas` (
  `id_juego` int(11) NOT NULL,
  `id_cancha` int(11) NOT NULL,
  `orden` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juego_confirmaciones_americana`
--

CREATE TABLE `juego_confirmaciones_americana` (
  `id_confirmacion` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `confirmado` tinyint(1) NOT NULL DEFAULT '0',
  `solicitado_at` datetime NOT NULL,
  `confirmado_at` datetime DEFAULT NULL,
  `ranking_aplicado` tinyint(1) NOT NULL DEFAULT '0',
  `ranking_aplicado_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `juego_confirmaciones_americana`
--

INSERT INTO `juego_confirmaciones_americana` (`id_confirmacion`, `id_juego`, `id_jugador`, `confirmado`, `solicitado_at`, `confirmado_at`, `ranking_aplicado`, `ranking_aplicado_at`) VALUES
(1, 1, 26, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(2, 1, 27, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(3, 1, 28, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(4, 1, 29, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(5, 1, 30, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(6, 1, 31, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(7, 1, 32, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(8, 1, 33, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(9, 1, 34, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(10, 1, 2, 1, '2026-03-26 13:01:33', '2026-03-26 13:01:33', 1, '2026-03-26 13:01:33'),
(11, 2, 2, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(12, 2, 35, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(13, 2, 36, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(14, 2, 37, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(15, 2, 38, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(16, 2, 39, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(17, 2, 40, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(18, 2, 41, 1, '2026-03-26 13:08:18', '2026-03-26 13:08:18', 1, '2026-03-26 13:08:18'),
(19, 3, 2, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(20, 3, 42, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(21, 3, 43, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(22, 3, 44, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(23, 3, 45, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(24, 3, 46, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(25, 3, 47, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(26, 3, 48, 1, '2026-03-26 13:13:53', '2026-03-26 13:13:53', 1, '2026-03-26 13:13:53'),
(27, 10, 58, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(28, 10, 59, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(29, 10, 60, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(30, 10, 61, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(31, 10, 62, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(32, 10, 63, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(33, 10, 64, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(34, 10, 65, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(35, 10, 2, 1, '2026-04-03 09:37:16', '2026-04-03 09:37:16', 1, '2026-04-03 09:37:16'),
(36, 11, 2, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:47', 1, '2026-04-03 09:40:47'),
(37, 11, 66, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:46', 1, '2026-04-03 09:40:47'),
(38, 11, 67, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:46', 1, '2026-04-03 09:40:47'),
(39, 11, 68, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:46', 1, '2026-04-03 09:40:47'),
(40, 11, 69, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:46', 1, '2026-04-03 09:40:47'),
(41, 11, 70, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:46', 1, '2026-04-03 09:40:47'),
(42, 11, 71, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:46', 1, '2026-04-03 09:40:47'),
(43, 11, 72, 1, '2026-04-03 09:40:46', '2026-04-03 09:40:46', 1, '2026-04-03 09:40:47'),
(44, 13, 2, 1, '2026-04-03 11:07:48', '2026-04-03 11:11:02', 1, '2026-04-03 11:11:02'),
(45, 13, 81, 1, '2026-04-03 11:07:48', '2026-04-03 11:07:48', 1, '2026-04-03 11:11:02'),
(46, 13, 82, 1, '2026-04-03 11:07:48', '2026-04-03 11:07:48', 1, '2026-04-03 11:11:02'),
(47, 13, 84, 1, '2026-04-03 11:07:48', '2026-04-03 11:07:48', 1, '2026-04-03 11:11:02'),
(48, 13, 80, 1, '2026-04-03 11:07:48', '2026-04-03 11:07:48', 1, '2026-04-03 11:11:02'),
(49, 12, 2, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(50, 12, 73, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(51, 12, 74, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(52, 12, 75, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(53, 12, 76, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(54, 12, 77, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(55, 12, 78, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(56, 12, 79, 1, '2026-04-03 11:18:33', '2026-04-03 11:18:33', 1, '2026-04-03 11:18:33'),
(57, 16, 95, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(58, 16, 96, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(59, 16, 97, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(60, 16, 98, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(61, 16, 99, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(62, 16, 100, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(63, 16, 101, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(64, 16, 102, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(65, 16, 103, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(66, 16, 104, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(67, 16, 105, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:47', 1, '2026-04-04 10:50:48'),
(68, 16, 80, 1, '2026-04-04 10:50:47', '2026-04-04 10:50:48', 1, '2026-04-04 10:50:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juego_confirmaciones_reta`
--

CREATE TABLE `juego_confirmaciones_reta` (
  `id_confirmacion` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `confirmado` tinyint(1) NOT NULL DEFAULT '0',
  `solicitado_at` datetime NOT NULL,
  `confirmado_at` datetime DEFAULT NULL,
  `ranking_aplicado` tinyint(1) NOT NULL DEFAULT '0',
  `ranking_aplicado_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `juego_confirmaciones_reta`
--

INSERT INTO `juego_confirmaciones_reta` (`id_confirmacion`, `id_juego`, `id_jugador`, `confirmado`, `solicitado_at`, `confirmado_at`, `ranking_aplicado`, `ranking_aplicado_at`) VALUES
(1, 14, 85, 1, '2026-04-03 11:52:35', '2026-04-03 11:52:35', 1, '2026-04-03 11:52:36'),
(2, 14, 86, 1, '2026-04-03 11:52:35', '2026-04-03 11:52:35', 1, '2026-04-03 11:52:36'),
(3, 14, 87, 1, '2026-04-03 11:52:35', '2026-04-03 11:52:35', 1, '2026-04-03 11:52:36'),
(4, 14, 80, 1, '2026-04-03 11:52:35', '2026-04-03 11:52:36', 1, '2026-04-03 11:52:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juego_jugadores`
--

CREATE TABLE `juego_jugadores` (
  `id_juego_jugadores` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `id_juego` int(11) DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `juego_jugadores`
--

INSERT INTO `juego_jugadores` (`id_juego_jugadores`, `id_jugador`, `id_juego`, `id_status`) VALUES
(1, 26, 1, 3),
(2, 27, 1, 3),
(3, 28, 1, 3),
(4, 29, 1, 3),
(5, 30, 1, 3),
(6, 31, 1, 3),
(7, 32, 1, 3),
(8, 33, 1, 3),
(9, 34, 1, 3),
(10, 2, 1, 3),
(11, 2, 2, 3),
(12, 35, 2, 3),
(13, 36, 2, 3),
(14, 37, 2, 3),
(15, 38, 2, 3),
(16, 39, 2, 3),
(17, 40, 2, 3),
(18, 41, 2, 3),
(19, 2, 3, 3),
(20, 2, 4, 3),
(21, 42, 3, 3),
(22, 43, 3, 3),
(23, 44, 3, 3),
(24, 45, 3, 3),
(25, 46, 3, 3),
(26, 47, 3, 3),
(27, 48, 3, 3),
(28, 49, 5, 3),
(29, 49, 6, 3),
(30, 49, 7, 3),
(31, 49, 8, 3),
(32, 49, 9, 3),
(33, 58, 10, 3),
(34, 59, 10, 3),
(35, 60, 10, 3),
(36, 61, 10, 3),
(37, 62, 10, 3),
(38, 63, 10, 3),
(39, 64, 10, 3),
(40, 65, 10, 3),
(41, 2, 10, 3),
(42, 2, 11, 3),
(43, 66, 11, 3),
(44, 67, 11, 3),
(45, 68, 11, 3),
(46, 69, 11, 3),
(47, 70, 11, 3),
(48, 71, 11, 3),
(49, 72, 11, 3),
(50, 2, 12, 3),
(51, 73, 12, 3),
(52, 74, 12, 3),
(53, 75, 12, 3),
(54, 76, 12, 3),
(55, 77, 12, 3),
(56, 78, 12, 3),
(57, 79, 12, 3),
(58, 2, 13, 3),
(59, 81, 13, 3),
(60, 82, 13, 3),
(61, 84, 13, 3),
(62, 80, 13, 3),
(63, 85, 14, 3),
(64, 86, 14, 3),
(65, 87, 14, 3),
(66, 80, 14, 3),
(67, 2, 15, 3),
(68, 88, 15, 3),
(69, 89, 15, 3),
(70, 90, 15, 3),
(71, 91, 15, 3),
(72, 92, 15, 3),
(73, 93, 15, 3),
(74, 94, 15, 3),
(75, 95, 16, 3),
(76, 96, 16, 3),
(77, 97, 16, 3),
(78, 98, 16, 3),
(79, 99, 16, 3),
(80, 100, 16, 3),
(81, 101, 16, 3),
(82, 102, 16, 3),
(83, 103, 16, 3),
(84, 104, 16, 3),
(85, 105, 16, 3),
(86, 80, 16, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugadaAmericana`
--

CREATE TABLE `jugadaAmericana` (
  `id_jugadaAmericana` int(11) NOT NULL,
  `id_jugador1` int(11) DEFAULT NULL,
  `us_jugador1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_jugador2` int(11) DEFAULT NULL,
  `us_jugador2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `set1` int(11) DEFAULT NULL,
  `pareja` int(11) NOT NULL,
  `id_juego` int(11) DEFAULT NULL,
  `Estatus` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugadaReta`
--

CREATE TABLE `jugadaReta` (
  `id_jugadaReta` int(11) NOT NULL,
  `id_jugador1` int(11) DEFAULT NULL,
  `us_jugador1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_jugador2` int(11) DEFAULT NULL,
  `us_jugador2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `set1` int(11) DEFAULT NULL,
  `set2` int(11) DEFAULT NULL,
  `set3` int(11) DEFAULT NULL,
  `pareja` int(11) NOT NULL,
  `id_juego` int(11) DEFAULT NULL,
  `Estatus` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugadores`
--

CREATE TABLE `jugadores` (
  `id_jugador` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `jug_puntos` float DEFAULT NULL,
  `num_partidos` int(11) NOT NULL DEFAULT '0',
  `ranking` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `nom_invitado` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contador` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `jugadores`
--

INSERT INTO `jugadores` (`id_jugador`, `id_usuario`, `jug_puntos`, `num_partidos`, `ranking`, `id_categoria`, `id_status`, `nom_invitado`, `contador`) VALUES
(2, 1060, 12.5, 18, 2, 4, 1, NULL, 5),
(21, 1079, 0, 0, NULL, 6, 1, NULL, 5),
(22, 1080, 0, 0, NULL, 6, 1, NULL, 5),
(23, 1081, 0, 0, NULL, 6, 1, NULL, 5),
(24, 1082, 0, 0, NULL, 6, 1, NULL, 5),
(25, 1083, 0, 0, NULL, 6, 1, NULL, 5),
(26, NULL, NULL, 0, NULL, NULL, NULL, 'Carlos', NULL),
(27, NULL, NULL, 0, NULL, NULL, NULL, 'Pedro', NULL),
(28, NULL, NULL, 0, NULL, NULL, NULL, 'Emilio', NULL),
(29, NULL, NULL, 0, NULL, NULL, NULL, 'Camargo', NULL),
(30, NULL, NULL, 0, NULL, NULL, NULL, 'Fer', NULL),
(31, NULL, NULL, 0, NULL, NULL, NULL, 'Ser', NULL),
(32, NULL, NULL, 0, NULL, NULL, NULL, 'Charly', NULL),
(33, NULL, NULL, 0, NULL, NULL, NULL, 'Vghj', NULL),
(34, NULL, NULL, 0, NULL, NULL, NULL, 'Xvgfv', NULL),
(35, NULL, NULL, 0, NULL, NULL, NULL, 'Xbox', NULL),
(36, NULL, NULL, 0, NULL, NULL, NULL, 'Cnx', NULL),
(37, NULL, NULL, 0, NULL, NULL, NULL, 'Cnxnx x', NULL),
(38, NULL, NULL, 0, NULL, NULL, NULL, 'Cnxnx', NULL),
(39, NULL, NULL, 0, NULL, NULL, NULL, 'Vnfbdjxx', NULL),
(40, NULL, NULL, 0, NULL, NULL, NULL, 'Cnxnccmgncv', NULL),
(41, NULL, NULL, 0, NULL, NULL, NULL, 'Cndndjdjxnfbc', NULL),
(42, NULL, NULL, 0, NULL, NULL, NULL, 'Fgggg', NULL),
(43, NULL, NULL, 0, NULL, NULL, NULL, 'Fggg', NULL),
(44, NULL, NULL, 0, NULL, NULL, NULL, 'Jajj', NULL),
(45, NULL, NULL, 0, NULL, NULL, NULL, 'Lol', NULL),
(46, NULL, NULL, 0, NULL, NULL, NULL, 'Chfdxz', NULL),
(47, NULL, NULL, 0, NULL, NULL, NULL, 'Ba', NULL),
(48, NULL, NULL, 0, NULL, NULL, NULL, 'Gnbcddd', NULL),
(49, 1085, 0, 0, NULL, 6, 1, NULL, 5),
(50, NULL, NULL, 0, NULL, NULL, NULL, 'Alma', NULL),
(51, NULL, NULL, 0, NULL, NULL, NULL, 'Paula', NULL),
(52, NULL, NULL, 0, NULL, NULL, NULL, 'Nury', NULL),
(53, NULL, NULL, 0, NULL, NULL, NULL, 'Jimena', NULL),
(54, NULL, NULL, 0, NULL, NULL, NULL, 'Leo', NULL),
(55, NULL, NULL, 0, NULL, NULL, NULL, 'María del Carmen', NULL),
(56, NULL, NULL, 0, NULL, NULL, NULL, 'Mariana', NULL),
(57, NULL, NULL, 0, NULL, NULL, NULL, 'Grettel', NULL),
(58, NULL, NULL, 0, NULL, NULL, NULL, 'Alma', NULL),
(59, NULL, NULL, 0, NULL, NULL, NULL, 'Leo', NULL),
(60, NULL, NULL, 0, NULL, NULL, NULL, 'Paula', NULL),
(61, NULL, NULL, 0, NULL, NULL, NULL, 'Mariana', NULL),
(62, NULL, NULL, 0, NULL, NULL, NULL, 'Nury', NULL),
(63, NULL, NULL, 0, NULL, NULL, NULL, 'María del Carmen', NULL),
(64, NULL, NULL, 0, NULL, NULL, NULL, 'Jimena', NULL),
(65, NULL, NULL, 0, NULL, NULL, NULL, 'Grettel', NULL),
(66, NULL, NULL, 0, NULL, NULL, NULL, 'Leo', NULL),
(67, NULL, NULL, 0, NULL, NULL, NULL, 'Paula', NULL),
(68, NULL, NULL, 0, NULL, NULL, NULL, 'Mariana', NULL),
(69, NULL, NULL, 0, NULL, NULL, NULL, 'María del Carmen', NULL),
(70, NULL, NULL, 0, NULL, NULL, NULL, 'Nury', NULL),
(71, NULL, NULL, 0, NULL, NULL, NULL, 'Jimena', NULL),
(72, NULL, NULL, 0, NULL, NULL, NULL, 'Grettel', NULL),
(73, NULL, NULL, 0, NULL, NULL, NULL, 'Paula', NULL),
(74, NULL, NULL, 0, NULL, NULL, NULL, 'Nury', NULL),
(75, NULL, NULL, 0, NULL, NULL, NULL, 'Jimena', NULL),
(76, NULL, NULL, 0, NULL, NULL, NULL, 'Leo', NULL),
(77, NULL, NULL, 0, NULL, NULL, NULL, 'Carmen', NULL),
(78, NULL, NULL, 0, NULL, NULL, NULL, 'Mariana', NULL),
(79, NULL, NULL, 0, NULL, NULL, NULL, 'Grettel', NULL),
(80, 1088, 12.2, 9, 1, 4, 1, NULL, 5),
(81, NULL, NULL, 0, NULL, NULL, NULL, 'Jorge', NULL),
(82, NULL, NULL, 0, NULL, NULL, NULL, 'Zamir', NULL),
(83, 1089, 0, 0, NULL, 6, 1, NULL, 5),
(84, NULL, NULL, 0, NULL, NULL, NULL, 'Fran', NULL),
(85, NULL, NULL, 0, NULL, NULL, NULL, 'Zamir', NULL),
(86, NULL, NULL, 0, NULL, NULL, NULL, 'Moises', NULL),
(87, NULL, NULL, 0, NULL, NULL, NULL, 'Norman', NULL),
(88, NULL, NULL, 0, NULL, NULL, NULL, 'Marco', NULL),
(89, NULL, NULL, 0, NULL, NULL, NULL, 'Mario', NULL),
(90, NULL, NULL, 0, NULL, NULL, NULL, 'Mauricio', NULL),
(91, NULL, NULL, 0, NULL, NULL, NULL, 'Diego', NULL),
(92, NULL, NULL, 0, NULL, NULL, NULL, 'Rafa', NULL),
(93, NULL, NULL, 0, NULL, NULL, NULL, 'Alfredo', NULL),
(94, NULL, NULL, 0, NULL, NULL, NULL, 'Lino', NULL),
(95, NULL, NULL, 0, NULL, NULL, NULL, 'Jorge', NULL),
(96, NULL, NULL, 0, NULL, NULL, NULL, 'Zamir', NULL),
(97, NULL, NULL, 0, NULL, NULL, NULL, 'Moi', NULL),
(98, NULL, NULL, 0, NULL, NULL, NULL, 'Norman', NULL),
(99, NULL, NULL, 0, NULL, NULL, NULL, 'Diego', NULL),
(100, NULL, NULL, 0, NULL, NULL, NULL, 'Pilo', NULL),
(101, NULL, NULL, 0, NULL, NULL, NULL, 'Rodrigo', NULL),
(102, NULL, NULL, 0, NULL, NULL, NULL, 'Nacho', NULL),
(103, NULL, NULL, 0, NULL, NULL, NULL, 'Pancho', NULL),
(104, NULL, NULL, 0, NULL, NULL, NULL, 'Pablo', NULL),
(105, NULL, NULL, 0, NULL, NULL, NULL, 'Mau', NULL),
(106, NULL, NULL, 0, NULL, NULL, NULL, 'Jorge', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_asociados`
--

CREATE TABLE `menu_asociados` (
  `id_perfil` int(11) DEFAULT NULL,
  `id_seccion` int(11) DEFAULT NULL,
  `id_modulo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `menu_asociados`
--

INSERT INTO `menu_asociados` (`id_perfil`, `id_seccion`, `id_modulo`) VALUES
(18, NULL, 4),
(17, 2, 2),
(17, 1, 2),
(17, NULL, 5),
(17, 6, 13),
(17, 7, 13),
(17, NULL, 4),
(18, NULL, 8),
(17, 17, 2),
(18, 18, 8),
(18, 19, 8),
(14, NULL, 4),
(14, NULL, 5),
(14, NULL, 9),
(14, NULL, 7),
(14, 8, 7),
(14, 9, 7),
(14, 10, 7),
(14, 13, 7),
(14, 14, 7),
(14, 15, 7),
(14, 16, 7),
(20, NULL, 4),
(20, NULL, 9),
(20, NULL, 8),
(20, NULL, 9),
(20, 18, 8),
(20, 19, 8),
(14, 21, 9),
(18, 22, 9),
(18, 23, 8),
(18, 24, 8),
(18, 25, 8),
(20, 22, 9),
(20, 24, 8),
(20, 25, 8),
(20, 23, 8),
(21, NULL, 4),
(21, NULL, 5),
(21, NULL, 9),
(21, NULL, 7),
(21, 8, 7),
(21, 9, 7),
(21, 10, 7),
(21, 13, 7),
(21, 14, 7),
(21, 15, 7),
(21, 16, 7),
(21, 21, 9),
(18, 26, 8),
(18, 27, 8),
(20, 26, 8),
(20, 27, 8),
(19, NULL, 4),
(19, NULL, 15),
(14, 30, 7),
(14, NULL, 15),
(21, NULL, 15),
(17, 32, 16),
(14, 31, 16),
(21, 31, 16),
(17, 33, 16),
(17, 34, 16),
(17, 35, 16);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodos_pago`
--

CREATE TABLE `metodos_pago` (
  `id_metodo` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `descripcion` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `estatus` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modojuego`
--

CREATE TABLE `modojuego` (
  `id_modojuego` int(11) NOT NULL,
  `mod_nombre` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `mod_descripcion` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `mod_minJugadores` int(11) DEFAULT NULL,
  `mod_maxJugadores` int(11) DEFAULT NULL,
  `id_status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `modojuego`
--

INSERT INTO `modojuego` (`id_modojuego`, `mod_nombre`, `mod_descripcion`, `mod_minJugadores`, `mod_maxJugadores`, `id_status`) VALUES
(1, 'Round Robin Individual', 'Se juega en formato 2 vs 2, pero cada jugador suma puntos de manera individual. En cada juego, los jugadores cambian de pareja y de rivales. El objetivo es acumular la mayor cantidad de puntos posibles a lo largo del torneo. Se juega por tiempo determinado o hasta completar un número de juegos preestablecido. La clasificación final se basa en los puntos individuales obtenidos.', 4, 12, 1),
(2, 'Rey de la Pista', 'Se juega en varias canchas, con el objetivo de llegar a la cancha más alta, conocida como la \"cancha del Rey\". Todas las canchas tienen partidos simultáneos y, tras cada ronda, los ganadores suben de cancha y los perdedores bajan. La mejor cancha es la \"Cancha del Rey\", donde las parejas que llegan deben mantenerse ganando para conservar su lugar. Se juega por un tiempo determinado o hasta alcanzar una cantidad preestablecida de rondas. La pareja que permanezca como Rey de la Pista al final del ', 6, 16, 1),
(10, 'Reta', 'Se organiza una lista de equipos que se enfrentan en partidos sucesivos. La pareja ganadora permanece en la cancha y sigue jugando contra nuevos retadores. La pareja que pierde deja la cancha y espera su turno para volver a jugar. Se puede establecer un límite de partidos ganados consecutivos antes de obligar una rotación de equipos. Dependiendo del formato, se pueden registrar las victorias para premiar a la pareja con más triunfos acumulados.', 4, 4, 1),
(14, 'Americana Individual', 'Se juega un solo set a 6 juegos, aplicando reglas de punto de oro en caso de igualdad en cada juego. Si se llega a un empate en el marcador al final del set, se define con un tie-break a un número preestablecido de puntos. Es un formato rápido y dinámico diseñado para jugar partidos cortos y aumentar la rotación de jugadores. Puede jugarse en modalidad de eliminación directa o con acumulación de puntos para determinar a los finalistas.', NULL, NULL, 1),
(15, 'Round Robin Parejas', 'Se juega en formato 2 vs 2, pero los puntos se suman en conjunto con la misma pareja durante todo el torneo. En cada ronda, la pareja mantiene su equipo, pero cambia de rivales. Se establecen puntos por victoria y, en algunos casos, por empate. Al finalizar las rondas, la pareja con más puntos acumulados es la ganadora.', 5, 10, 1),
(16, 'Americana Parejas', 'Se juega un solo set a 6 juegos, aplicando reglas de punto de oro en caso de igualdad en cada juego. Si se llega a un empate en el marcador al final del set, se define con un tie-break a un número preestablecido de puntos. Es un formato rápido y dinámico diseñado para jugar partidos cortos y aumentar la rotación de jugadores. Puede jugarse en modalidad de eliminación directa o con acumulación de puntos para determinar a los finalistas.', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulo`
--

CREATE TABLE `modulo` (
  `mod_id` int(11) NOT NULL,
  `mod_nombre` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `mod_ruta` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `modulo`
--

INSERT INTO `modulo` (`mod_id`, `mod_nombre`, `mod_ruta`) VALUES
(1, 'Calendario', '/calendar'),
(2, 'Clientes', '/customers'),
(3, 'Colaboradores', '/collaborators'),
(4, 'Recompensas', '/rewards'),
(5, 'Noticias', '/news'),
(6, 'Configuración', '/settings'),
(7, 'Finanzas', '/financial'),
(8, 'Administración Colaboradores', '/gestionfinanciera'),
(10, 'Facturación', '/facturacion'),
(11, 'Soporte', '/technical-support');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos`
--

CREATE TABLE `modulos` (
  `id_modulo` int(11) NOT NULL,
  `mod_nombre` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mod_icono` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mod_descripcion` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mod_orden` int(11) DEFAULT NULL,
  `mod_url` varchar(55) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `id_perfil` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `modulos`
--

INSERT INTO `modulos` (`id_modulo`, `mod_nombre`, `mod_icono`, `mod_descripcion`, `mod_orden`, `mod_url`, `id_status`, `id_perfil`) VALUES
(2, 'Administración', 'fas fa-tools', 'Panel de administración', 2, NULL, 1, NULL),
(4, 'Perfil', 'fas fa-user', 'Gestión del perfil de usuario', 4, 'private/web/perfil/Profile', 1, NULL),
(5, 'Inicio', 'fas fa-home', 'Modulo de inicio', 1, 'web', 1, NULL),
(6, 'Calendario', 'fa-solid fa-calendar-days', 'Gestión de calendarios y eventos', 5, 'private/web/calendario/Calendario', 1, NULL),
(7, 'Clubs', NULL, 'Gestion de clubs', 6, NULL, 1, NULL),
(8, 'Fraccionamiento', 'fas fa-building', 'Gestión de fracionamiento', 7, NULL, 1, NULL),
(9, 'Finanzas', 'fas fa-wallet', 'Gestión de finanzas', 11, NULL, 1, NULL),
(10, 'Soporte', 'fas fa-headset', 'Soporte', 9, NULL, 1, NULL),
(13, 'Organizaciones', 'fa-solid fa-building-ngo', 'Organizaciones', 3, NULL, 1, NULL),
(14, 'Colaboradores', NULL, 'Colaboradores de club', 10, NULL, 1, NULL),
(15, 'Torneos', 'fa-solid fa-trophy', 'Torneos extrenos', 8, 'private/web/club/Torneos', 1, NULL),
(16, 'Reportes', 'fa-solid fa-file-invoice', 'Reportes', 12, NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos_superadmin`
--

CREATE TABLE `modulos_superadmin` (
  `mod_id` int(11) NOT NULL,
  `mod_nombre` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nombre del módulo',
  `mod_ruta` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Ruta del módulo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `modulos_superadmin`
--

INSERT INTO `modulos_superadmin` (`mod_id`, `mod_nombre`, `mod_ruta`) VALUES
(1, 'Reportes Generales', '/general'),
(2, 'Usuarios', '/users'),
(3, 'Clubes', '/clubs'),
(4, 'Desarrollos', '/subdivisions'),
(5, 'Empresas', '/companies'),
(6, 'Patrocinio', '/sponsors'),
(7, 'Gobierno', '/government'),
(8, 'Promotores', '/promoters'),
(9, 'Soporte', '/technical-support'),
(10, 'Market Place', '/marketplace'),
(11, 'Colaboradores', '/collaborators-admin'),
(12, 'Facturación', '/facturacion');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_pendientes`
--

CREATE TABLE `movimientos_pendientes` (
  `id_movimiento` int(11) NOT NULL,
  `tipo` enum('ingreso','egreso') COLLATE utf8_unicode_ci NOT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_club_metodo_pago` int(11) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` datetime NOT NULL,
  `estado` enum('pendiente','aprobado','rechazado') COLLATE utf8_unicode_ci DEFAULT 'pendiente',
  `observaciones` text COLLATE utf8_unicode_ci,
  `id_fraccionamientoclub` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `municipio`
--

CREATE TABLE `municipio` (
  `id_municipio` int(11) NOT NULL,
  `mun_nombre` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `niveljuego`
--

CREATE TABLE `niveljuego` (
  `id_nivelJuego` int(11) NOT NULL,
  `niv_nombre` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `niveljuego`
--

INSERT INTO `niveljuego` (`id_nivelJuego`, `niv_nombre`) VALUES
(1, 'Open'),
(2, 'Primera'),
(3, 'Segunda'),
(4, 'Tercera'),
(5, 'Cuarta'),
(6, 'Quinta'),
(7, 'Libre');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `noticias`
--

CREATE TABLE `noticias` (
  `id_noticias` int(11) NOT NULL,
  `not_titulo` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `not_descripcion` text COLLATE utf8_unicode_ci,
  `not_imagen` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fecha_creacion` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `id_fraccionamientoclub` int(11) DEFAULT NULL,
  `id_tipo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones_enviadas`
--

CREATE TABLE `notificaciones_enviadas` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `tipo_notificacion` enum('24h','1h') COLLATE utf8_unicode_ci NOT NULL,
  `fecha_envio` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones_juegos`
--

CREATE TABLE `notificaciones_juegos` (
  `id_notificacion` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `tipo_notificacion` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `fecha_envio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones_reservas`
--

CREATE TABLE `notificaciones_reservas` (
  `id_notificacion` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_reserva` int(11) NOT NULL,
  `tiempo` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `fecha_envio` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos_reserva`
--

CREATE TABLE `pagos_reserva` (
  `id` int(11) NOT NULL,
  `id_reserva` int(11) NOT NULL,
  `id_participante` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fecha` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pais`
--

CREATE TABLE `pais` (
  `id_pais` int(11) NOT NULL,
  `pai_nombre` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `pais`
--

INSERT INTO `pais` (`id_pais`, `pai_nombre`) VALUES
(1, 'México');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil`
--

CREATE TABLE `perfil` (
  `id_perfil` int(11) NOT NULL,
  `per_nombre` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `per_descripcion` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`id_perfil`, `per_nombre`, `per_descripcion`, `id_status`) VALUES
(1, 'Desarrollador', 'Perfil de desarrollador (ver todos ', 1),
(14, 'Administrador club', 'Administrador del club(web)', 1),
(16, 'Cliente', 'Usuario Cliente(móvil)', 1),
(17, 'SuperAdmin', 'Administrador de la plataforma web', 1),
(18, 'Administrador Fraccionamiento', 'Administrador de fraccionamientos(w', 1),
(19, 'Administrador otros', 'Administrador de empresas, canchas ', 1),
(20, 'Colaborador Fraccionamiento', 'Colaborador de Fraccionamiento (web', 1),
(21, 'Colaborador Club', 'Colaborador club(web)', 1),
(22, 'Colaborador SuperAdmin', 'Colaborador de la plataforma web (S', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil_modulo`
--

CREATE TABLE `perfil_modulo` (
  `id_perfil` int(11) NOT NULL,
  `id_modulo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `perfil_modulo`
--

INSERT INTO `perfil_modulo` (`id_perfil`, `id_modulo`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_admin_rol`
--

CREATE TABLE `permisos_admin_rol` (
  `id_perfil` int(11) NOT NULL COMMENT 'ID del usuario colaborador',
  `mod_id` int(11) NOT NULL COMMENT 'ID del módulo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `permisos_admin_rol`
--

INSERT INTO `permisos_admin_rol` (`id_perfil`, `mod_id`) VALUES
(22, 3),
(22, 5),
(22, 8),
(22, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_admin_usuario`
--

CREATE TABLE `permisos_admin_usuario` (
  `id_usuario` int(11) NOT NULL COMMENT 'ID del usuario colaborador',
  `mod_id` int(11) NOT NULL COMMENT 'ID del módulo',
  `can_view` tinyint(1) DEFAULT '1' COMMENT 'Permiso de visualización',
  `can_create` tinyint(1) DEFAULT '0' COMMENT 'Permiso de creación',
  `can_edit` tinyint(1) DEFAULT '0' COMMENT 'Permiso de edición'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `permisos_admin_usuario`
--

INSERT INTO `permisos_admin_usuario` (`id_usuario`, `mod_id`, `can_view`, `can_create`, `can_edit`) VALUES
(981, 8, 1, 1, 1),
(982, 8, 1, 1, 1),
(983, 2, 1, 1, 1),
(984, 3, 1, 1, 1),
(985, 3, 1, 1, 1),
(985, 5, 1, 1, 1),
(986, 8, 1, 1, 1),
(986, 9, 1, 1, 1),
(987, 8, 1, 1, 1),
(987, 9, 1, 1, 1),
(988, 8, 1, 1, 1),
(988, 9, 1, 1, 1),
(996, 9, 1, 1, 1),
(997, 8, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_rol`
--

CREATE TABLE `permisos_rol` (
  `id_perfil` int(11) NOT NULL,
  `mod_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `permisos_rol`
--

INSERT INTO `permisos_rol` (`id_perfil`, `mod_id`) VALUES
(14, 1),
(14, 2),
(14, 3),
(14, 4),
(14, 5),
(21, 1),
(21, 2),
(21, 4),
(21, 5),
(14, 6),
(21, 6),
(14, 7),
(21, 7),
(14, 8),
(21, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_usuario`
--

CREATE TABLE `permisos_usuario` (
  `id_usuario` int(11) NOT NULL,
  `mod_id` int(11) NOT NULL,
  `can_view` tinyint(1) DEFAULT NULL,
  `can_create` tinyint(1) DEFAULT NULL,
  `can_edit` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `permisos_usuario`
--

INSERT INTO `permisos_usuario` (`id_usuario`, `mod_id`, `can_view`, `can_create`, `can_edit`) VALUES
(849, 1, 1, 1, 1),
(849, 2, 1, 1, 1),
(849, 3, 1, 1, 1),
(849, 4, 1, 1, 1),
(849, 5, 1, 1, 1),
(807, 1, 1, 1, 1),
(807, 2, 1, 1, 1),
(807, 3, 1, 1, 1),
(807, 4, 1, 1, 1),
(807, 5, 1, 1, 1),
(854, 1, 1, 1, 1),
(854, 2, 1, 1, 1),
(854, 3, 1, 1, 1),
(854, 4, 1, 1, 1),
(854, 5, 1, 1, 1),
(832, 1, 1, 1, 1),
(832, 2, 1, 1, 1),
(832, 3, 1, 1, 1),
(832, 4, 1, 1, 1),
(832, 5, 1, 1, 1),
(881, 1, 1, 1, 1),
(881, 2, 1, 1, 1),
(881, 4, 1, 1, 1),
(860, 1, 1, 1, 1),
(891, 1, 1, 1, 1),
(892, 1, 1, 1, 1),
(892, 2, 1, 1, 1),
(892, 4, 1, 1, 1),
(892, 5, 1, 1, 1),
(893, 1, 1, 1, 1),
(895, 1, 1, 1, 1),
(895, 2, 1, 1, 1),
(895, 3, 1, 1, 1),
(895, 4, 1, 1, 1),
(895, 5, 1, 1, 1),
(898, 1, 1, 0, 0),
(898, 2, 0, 0, 0),
(898, 3, 0, 0, 0),
(898, 4, 0, 0, 0),
(898, 5, 0, 0, 0),
(899, 1, 1, 0, 0),
(899, 2, 1, 0, 0),
(899, 3, 1, 0, 1),
(899, 4, 1, 0, 1),
(894, 1, 1, 0, 0),
(894, 2, 1, 0, 1),
(894, 3, 1, 0, 1),
(901, 1, 1, 0, 0),
(901, 2, 1, 0, 0),
(901, 3, 1, 0, 0),
(901, 4, 1, 0, 0),
(901, 5, 1, 0, 0),
(902, 1, 1, 0, 0),
(902, 2, 1, 0, 1),
(902, 3, 1, 0, 1),
(902, 4, 1, 0, 1),
(902, 5, 1, 0, 1),
(904, 1, 1, 0, 0),
(904, 2, 1, 1, 0),
(905, 1, 1, 0, 0),
(903, 1, 1, 0, 0),
(903, 2, 1, 1, 0),
(903, 3, 1, 1, 0),
(903, 4, 1, 1, 0),
(903, 5, 1, 1, 0),
(906, 1, 1, 0, 0),
(906, 2, 1, 0, 0),
(906, 3, 1, 1, 1),
(906, 4, 1, 0, 0),
(906, 5, 1, 0, 0),
(908, 1, 1, 0, 0),
(908, 2, 1, 0, 0),
(908, 3, 1, 1, 1),
(908, 4, 1, 0, 0),
(907, 1, 1, 0, 1),
(907, 2, 1, 0, 1),
(907, 3, 1, 0, 1),
(907, 4, 1, 0, 1),
(907, 5, 1, 0, 1),
(862, 1, 1, 0, 0),
(862, 2, 1, 1, 0),
(862, 3, 1, 1, 0),
(862, 4, 1, 1, 0),
(862, 5, 1, 1, 0),
(910, 1, 1, 0, 0),
(910, 2, 1, 0, 0),
(910, 3, 1, 0, 0),
(910, 5, 1, 0, 0),
(832, 6, 1, 1, 1),
(807, 6, 1, 1, 1),
(911, 1, 1, 1, 0),
(911, 2, 1, 0, 0),
(911, 3, 1, 1, 1),
(849, 6, 1, 1, 1),
(900, 1, 1, 1, 0),
(900, 2, 1, 1, 0),
(900, 3, 1, 1, 0),
(900, 4, 1, 1, 0),
(900, 5, 1, 1, 0),
(900, 6, 1, 1, 0),
(854, 6, 1, 1, 1),
(909, 1, 1, 1, 1),
(909, 2, 1, 1, 1),
(909, 3, 1, 1, 1),
(909, 4, 1, 1, 1),
(909, 5, 1, 1, 1),
(909, 6, 1, 1, 1),
(914, 1, 1, 1, 1),
(914, 2, 1, 1, 1),
(914, 3, 1, 1, 1),
(914, 4, 1, 1, 1),
(914, 5, 1, 1, 1),
(914, 6, 1, 1, 1),
(914, 7, 1, 1, 1),
(914, 8, 1, 1, 1),
(849, 7, 1, 1, 1),
(849, 8, 1, 1, 1),
(916, 1, 1, 1, 1),
(916, 2, 1, 1, 1),
(916, 3, 1, 1, 1),
(916, 4, 1, 1, 1),
(916, 5, 1, 1, 1),
(916, 6, 1, 1, 1),
(916, 7, 1, 1, 1),
(916, 8, 1, 1, 1),
(967, 1, 1, 1, 1),
(967, 2, 1, 1, 1),
(967, 3, 1, 1, 1),
(967, 4, 1, 1, 1),
(967, 5, 1, 1, 1),
(967, 6, 1, 1, 1),
(967, 7, 1, 1, 1),
(967, 8, 1, 1, 1),
(968, 1, 1, 1, 1),
(968, 2, 1, 1, 1),
(968, 3, 1, 1, 1),
(968, 4, 1, 1, 1),
(968, 5, 1, 1, 1),
(968, 6, 1, 1, 1),
(968, 7, 1, 1, 1),
(968, 8, 1, 1, 1),
(969, 1, 1, 1, 1),
(969, 2, 1, 1, 1),
(969, 3, 1, 1, 1),
(969, 4, 1, 1, 1),
(969, 5, 1, 1, 1),
(969, 6, 1, 1, 1),
(969, 7, 1, 1, 1),
(969, 8, 1, 1, 1),
(970, 1, 1, 1, 1),
(970, 2, 1, 1, 1),
(970, 3, 1, 1, 1),
(970, 4, 1, 1, 1),
(970, 5, 1, 1, 1),
(970, 6, 1, 1, 1),
(970, 7, 1, 1, 1),
(970, 8, 1, 1, 1),
(913, 1, 1, 0, 0),
(913, 2, 1, 0, 0),
(913, 3, 1, 0, 0),
(913, 4, 1, 0, 0),
(913, 5, 1, 0, 0),
(913, 6, 1, 0, 0),
(1007, 1, 1, 1, 1),
(1007, 2, 1, 1, 1),
(1007, 3, 1, 1, 1),
(1007, 4, 1, 1, 1),
(1007, 5, 1, 1, 1),
(1007, 6, 1, 1, 1),
(1007, 7, 1, 1, 1),
(1007, 8, 1, 1, 1),
(1008, 1, 1, 1, 1),
(1008, 2, 1, 1, 1),
(1008, 3, 1, 1, 1),
(1008, 4, 1, 1, 1),
(1008, 5, 1, 1, 1),
(1008, 6, 1, 1, 1),
(1008, 7, 1, 1, 1),
(1008, 8, 1, 1, 1),
(1009, 1, 1, 1, 1),
(1009, 2, 1, 1, 1),
(1009, 3, 1, 1, 1),
(1009, 4, 1, 1, 1),
(1009, 5, 1, 1, 1),
(1009, 6, 1, 1, 1),
(1009, 7, 1, 1, 1),
(1009, 8, 1, 1, 1),
(1010, 1, 1, 1, 1),
(1010, 2, 1, 1, 1),
(1010, 3, 1, 1, 1),
(1010, 4, 1, 1, 1),
(1010, 5, 1, 1, 1),
(1010, 6, 1, 1, 1),
(1010, 7, 1, 1, 1),
(1010, 8, 1, 1, 1),
(1012, 1, 1, 1, 1),
(1012, 2, 1, 1, 1),
(1012, 3, 1, 1, 1),
(1012, 4, 1, 1, 1),
(1012, 5, 1, 1, 1),
(1012, 6, 1, 1, 1),
(1012, 7, 1, 1, 1),
(1012, 8, 1, 1, 1),
(1015, 1, 1, 1, 1),
(1015, 2, 1, 1, 1),
(1015, 3, 1, 1, 1),
(1015, 4, 1, 1, 1),
(1015, 5, 1, 1, 1),
(1015, 6, 1, 1, 1),
(1015, 7, 1, 1, 1),
(1015, 8, 1, 1, 1),
(1018, 1, 1, 1, 1),
(1018, 2, 1, 1, 1),
(1018, 3, 1, 1, 1),
(1018, 4, 1, 1, 1),
(1018, 5, 1, 1, 1),
(1018, 6, 1, 1, 1),
(1018, 7, 1, 1, 1),
(1018, 8, 1, 1, 1),
(1019, 1, 1, 1, 1),
(1019, 2, 1, 1, 1),
(1019, 3, 1, 1, 1),
(1019, 4, 1, 1, 1),
(1019, 5, 1, 1, 1),
(1019, 6, 1, 1, 1),
(1019, 7, 1, 1, 1),
(1019, 8, 1, 1, 1),
(1020, 1, 1, 1, 1),
(1020, 2, 1, 1, 1),
(1020, 3, 1, 1, 1),
(1020, 4, 1, 1, 1),
(1020, 5, 1, 1, 1),
(1020, 6, 1, 1, 1),
(1020, 7, 1, 1, 1),
(1020, 8, 1, 1, 1),
(1021, 1, 1, 1, 1),
(1021, 2, 1, 1, 1),
(1021, 3, 1, 1, 1),
(1021, 4, 1, 1, 1),
(1021, 5, 1, 1, 1),
(1021, 6, 1, 1, 1),
(1021, 7, 1, 1, 1),
(1021, 8, 1, 1, 1),
(1022, 1, 1, 1, 1),
(1022, 2, 1, 1, 1),
(1022, 3, 1, 1, 1),
(1022, 4, 1, 1, 1),
(1022, 5, 1, 1, 1),
(1022, 6, 1, 1, 1),
(1022, 7, 1, 1, 1),
(1022, 8, 1, 1, 1),
(1023, 1, 1, 1, 1),
(1023, 2, 1, 1, 1),
(1023, 3, 1, 1, 1),
(1023, 4, 1, 1, 1),
(1023, 5, 1, 1, 1),
(1023, 6, 1, 1, 1),
(1023, 7, 1, 1, 1),
(1023, 8, 1, 1, 1),
(1025, 1, 1, 1, 1),
(1025, 2, 1, 1, 1),
(1025, 3, 1, 1, 1),
(1025, 4, 1, 1, 1),
(1025, 5, 1, 1, 1),
(1025, 6, 1, 1, 1),
(1025, 7, 1, 1, 1),
(1025, 8, 1, 1, 1),
(1034, 1, 1, 1, 1),
(1034, 2, 1, 1, 1),
(1034, 3, 1, 1, 1),
(1034, 4, 1, 1, 1),
(1034, 5, 1, 1, 1),
(1034, 6, 1, 1, 1),
(1034, 7, 1, 1, 1),
(1034, 8, 1, 1, 1),
(1037, 1, 1, 1, 1),
(1037, 8, 1, 1, 1),
(1038, 1, 1, 0, 0),
(1038, 6, 1, 1, 1),
(1039, 1, 1, 0, 0),
(1039, 6, 1, 1, 1),
(1040, 1, 1, 0, 0),
(1040, 6, 1, 0, 0),
(1041, 1, 1, 0, 0),
(1041, 6, 1, 1, 1),
(916, 10, 1, 1, 1),
(916, 11, 1, 1, 1),
(1051, 8, 1, 1, 1),
(1051, 1, 1, 1, 1),
(1051, 2, 1, 1, 1),
(1051, 3, 1, 1, 1),
(1051, 6, 1, 1, 1),
(1051, 10, 1, 1, 1),
(1051, 7, 1, 1, 1),
(1051, 5, 1, 1, 1),
(1051, 4, 1, 1, 1),
(1051, 11, 1, 1, 1),
(1052, 8, 1, 1, 1),
(1052, 1, 1, 1, 1),
(1052, 2, 1, 1, 1),
(1052, 3, 1, 1, 1),
(1052, 6, 1, 1, 1),
(1052, 7, 1, 1, 1),
(1052, 5, 1, 1, 1),
(1052, 4, 1, 1, 1),
(1052, 11, 1, 1, 1),
(918, 1, 1, 1, 1),
(918, 8, 1, 1, 1),
(918, 11, 1, 1, 1),
(1057, 1, 1, 1, 1),
(1057, 2, 1, 1, 1),
(1057, 3, 1, 1, 1),
(1057, 4, 1, 1, 1),
(1057, 5, 1, 1, 1),
(1057, 6, 1, 1, 1),
(1057, 7, 1, 1, 1),
(1057, 8, 1, 1, 1),
(1057, 10, 1, 1, 1),
(1057, 11, 1, 1, 1),
(1058, 1, 1, 1, 1),
(1058, 2, 1, 1, 1),
(1058, 3, 1, 1, 1),
(1058, 4, 1, 1, 1),
(1058, 5, 1, 1, 1),
(1058, 6, 1, 1, 1),
(1058, 7, 1, 1, 1),
(1058, 8, 1, 1, 1),
(1058, 10, 1, 1, 1),
(1058, 11, 1, 1, 1),
(1084, 1, 1, 1, 1),
(1084, 2, 1, 1, 1),
(1084, 3, 1, 0, 0),
(1084, 4, 1, 0, 0),
(1084, 5, 1, 1, 0),
(1084, 8, 1, 1, 1),
(1084, 11, 1, 1, 1),
(1090, 1, 1, 1, 1),
(1090, 2, 1, 1, 1),
(1090, 3, 1, 1, 1),
(1090, 4, 1, 1, 1),
(1090, 5, 1, 1, 1),
(1090, 6, 1, 1, 1),
(1090, 7, 1, 1, 1),
(1090, 8, 1, 1, 1),
(1090, 10, 1, 1, 1),
(1090, 11, 1, 1, 1),
(1091, 1, 1, 1, 1),
(1091, 2, 1, 1, 1),
(1091, 3, 1, 1, 1),
(1091, 4, 1, 1, 1),
(1091, 5, 1, 1, 1),
(1091, 6, 1, 1, 1),
(1091, 7, 1, 1, 1),
(1091, 8, 1, 1, 1),
(1091, 10, 1, 1, 1),
(1091, 11, 1, 1, 1),
(1092, 1, 1, 1, 1),
(1092, 2, 1, 1, 1),
(1092, 3, 1, 1, 1),
(1092, 4, 1, 1, 1),
(1092, 5, 1, 1, 1),
(1092, 6, 1, 1, 1),
(1092, 7, 1, 1, 1),
(1092, 8, 1, 1, 1),
(1092, 10, 1, 1, 1),
(1092, 11, 1, 1, 1),
(1093, 1, 1, 1, 1),
(1093, 2, 1, 1, 1),
(1093, 3, 1, 1, 1),
(1093, 4, 1, 1, 1),
(1093, 5, 1, 1, 1),
(1093, 6, 1, 1, 1),
(1093, 7, 1, 1, 1),
(1093, 8, 1, 1, 1),
(1093, 10, 1, 1, 1),
(1093, 11, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes_suscripcion`
--

CREATE TABLE `planes_suscripcion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8_unicode_ci,
  `categoria` enum('usuarios','club','desarrollos') COLLATE utf8_unicode_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `duracion` enum('mensual','anual') COLLATE utf8_unicode_ci NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `planes_suscripcion`
--

INSERT INTO `planes_suscripcion` (`id`, `nombre`, `descripcion`, `categoria`, `precio`, `duracion`, `creado_en`, `actualizado_en`) VALUES
(1, 'Plan Mensual', 'Plan Mensual de usuarios.', 'usuarios', 79.00, 'mensual', '2024-12-16 20:12:25', '2025-12-09 05:45:16'),
(2, 'Plan Anual', 'Plan Anual de usuarios.', 'usuarios', 790.00, 'anual', '2024-12-16 20:12:25', '2025-12-09 05:45:16'),
(3, 'Plan Mensual', 'Plan Mensual de club.', 'club', 1800.00, 'mensual', '2024-12-16 20:12:25', '2025-12-09 05:45:16'),
(4, 'Plan Anual', 'Plan Anual de club.', 'club', 18000.00, 'anual', '2024-12-16 20:12:25', '2025-12-09 05:45:16'),
(5, 'Plan Mensual', 'Plan Mensual.', 'desarrollos', 1500.00, 'mensual', '2024-12-16 20:12:25', '2025-12-09 05:45:17'),
(6, 'Plan Anual', 'Plan Anual.', 'desarrollos', 15000.00, 'anual', '2024-12-16 20:12:25', '2025-12-09 05:45:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios_torneo`
--

CREATE TABLE `precios_torneo` (
  `id_precio` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `moneda` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `premios`
--

CREATE TABLE `premios` (
  `id_premios` int(11) NOT NULL,
  `pre_nombre` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pre_descripcion` text COLLATE utf8_unicode_ci,
  `id_fraccionamientoclub` int(11) DEFAULT NULL,
  `pre_ptsnecesario` int(11) DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `pre_cantidad` int(11) DEFAULT NULL,
  `imagen` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `premios`
--

INSERT INTO `premios` (`id_premios`, `pre_nombre`, `pre_descripcion`, `id_fraccionamientoclub`, `pre_ptsnecesario`, `id_status`, `pre_cantidad`, `imagen`) VALUES
(20, 'No', '123', 111, 123, 1, 1, 'recompensa_1756139889.jpg'),
(44, 'Bolas hornet', 'bolas hornet', 2, 100, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_partidos`
--

CREATE TABLE `programacion_partidos` (
  `id_programacion` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `id_partido` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subcategoria_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fase_tipo` enum('grupo','final') COLLATE utf8mb4_unicode_ci NOT NULL,
  `grupo_index` int(11) DEFAULT NULL,
  `ronda_index` int(11) DEFAULT NULL,
  `partido_index` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `id_cancha` int(11) DEFAULT NULL,
  `nombre_cancha` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `sincronizado_desde_storage` tinyint(1) DEFAULT '1' COMMENT '1=viene de localStorage, 0=creado directo en BD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Programación de partidos - sincronización desde localStorage';

--
-- Volcado de datos para la tabla `programacion_partidos`
--

INSERT INTO `programacion_partidos` (`id_programacion`, `id_torneo`, `id_partido`, `categoria_id`, `subcategoria_id`, `fase_tipo`, `grupo_index`, `ronda_index`, `partido_index`, `fecha`, `hora`, `id_cancha`, `nombre_cancha`, `fecha_creacion`, `fecha_actualizacion`, `sincronizado_desde_storage`) VALUES
(7, 61, 'partido-grupo-0-0-2', '5', '1', 'grupo', 0, NULL, 1, NULL, NULL, NULL, NULL, '2025-06-09 01:00:30', '2025-06-09 00:45:19', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_partidos_padel`
--

CREATE TABLE `programacion_partidos_padel` (
  `id` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `id_partido` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subcategoria_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fase_tipo` enum('grupo','final') COLLATE utf8mb4_unicode_ci NOT NULL,
  `grupo_index` int(11) DEFAULT NULL,
  `ronda_index` int(11) DEFAULT NULL,
  `partido_index` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `id_cancha` int(11) NOT NULL,
  `nombre_cancha` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_programacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `ultima_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promotores`
--

CREATE TABLE `promotores` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `apellido_paterno` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `apellido_materno` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nombre_usuario` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `correo` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genero` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `asociacion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `codigo_usuario` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cantidad_usuarios` int(11) DEFAULT NULL,
  `cantidad_clubes` int(11) DEFAULT NULL,
  `cantidad_fracc` int(11) DEFAULT NULL,
  `cantidad_patrocinios` int(11) NOT NULL DEFAULT '0',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `promotores`
--

INSERT INTO `promotores` (`id`, `id_usuario`, `nombre`, `apellido_paterno`, `apellido_materno`, `nombre_usuario`, `correo`, `telefono`, `genero`, `fecha_nacimiento`, `asociacion`, `codigo_usuario`, `cantidad_usuarios`, `cantidad_clubes`, `cantidad_fracc`, `cantidad_patrocinios`, `fecha_registro`, `estatus`) VALUES
(1, 1060, 'Emilio', '', '', 'EmilioCG', 'emilio_cg@hotmail.com', '4421390491', 'M', '1986-07-01', '', 'P8KA8A7C', 0, 0, 0, 0, '2026-03-25 16:49:01', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pts_jugador_club`
--

CREATE TABLE `pts_jugador_club` (
  `id_pts_jugador_club` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `puntos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publicidad`
--

CREATE TABLE `publicidad` (
  `id_publicidad` int(11) NOT NULL,
  `ba_nombre` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ba_descripcion` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ba_imagen` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ba_orden` int(11) DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ranking`
--

CREATE TABLE `ranking` (
  `ranking` int(11) NOT NULL,
  `id_jugador` int(11) DEFAULT NULL,
  `ran_posicion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ranking_historial`
--

CREATE TABLE `ranking_historial` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `ran_posicion_anterior` int(11) NOT NULL,
  `ran_posicion_actual` int(11) NOT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recuperarContrasena`
--

CREATE TABLE `recuperarContrasena` (
  `idRC` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tokenRecuperacion` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `fecha_expiracion` datetime DEFAULT NULL,
  `fechaRecuperacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `id_reserva` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) DEFAULT NULL,
  `id_coach` int(11) DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `id_cancha` int(11) DEFAULT NULL,
  `id_status` int(11) NOT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `duracion` time DEFAULT NULL,
  `num_canchas` int(11) DEFAULT NULL,
  `moneda` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reservacion_club` tinyint(1) NOT NULL DEFAULT '0',
  `notas` text COLLATE utf8_unicode_ci,
  `tipo_evento` enum('reserva','clase','academia','bloqueo') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'reserva',
  `diferido` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`id_reserva`, `id_fraccionamientoclub`, `id_coach`, `fecha`, `hora_inicio`, `hora_fin`, `id_cancha`, `id_status`, `precio`, `duracion`, `num_canchas`, `moneda`, `reservacion_club`, `notas`, `tipo_evento`, `diferido`) VALUES
(1, 2, NULL, '2026-03-25', '21:00:00', '23:00:00', 3, 2, 1000.00, '02:00:00', NULL, NULL, 0, '', 'reserva', 0),
(2, NULL, NULL, '2026-03-26', '12:57:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(3, NULL, NULL, '2026-03-26', '13:04:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(4, NULL, NULL, '2026-03-26', '13:09:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(5, NULL, NULL, '2026-03-26', '13:11:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(6, NULL, NULL, '2026-03-31', '21:44:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 1, '', 0, NULL, 'reserva', 0),
(7, NULL, NULL, '2026-03-31', '22:08:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 1, '', 0, NULL, 'reserva', 0),
(8, NULL, NULL, '2026-03-31', '12:34:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 1, '', 0, NULL, 'reserva', 0),
(9, NULL, NULL, '2026-03-31', '16:10:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 1, '', 0, NULL, 'reserva', 0),
(10, NULL, NULL, '2026-03-31', '16:13:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 1, '', 0, NULL, 'reserva', 0),
(11, NULL, NULL, '2026-04-03', '09:29:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(12, NULL, NULL, '2026-04-03', '09:32:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(13, NULL, NULL, '2026-04-03', '09:50:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(14, NULL, NULL, '2026-04-03', '11:05:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 1, '', 0, NULL, 'reserva', 0),
(16, NULL, NULL, '2026-04-03', '11:51:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 1, '', 0, NULL, 'reserva', 0),
(17, NULL, NULL, '2026-04-04', '08:06:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 2, '', 0, NULL, 'reserva', 0),
(18, NULL, NULL, '2026-04-04', '10:47:00', '00:00:00', NULL, 1, 0.00, '02:00:00', 3, '', 0, NULL, 'reserva', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_participantes`
--

CREATE TABLE `reservas_participantes` (
  `id_participante` int(11) NOT NULL,
  `id_reserva` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_club_usuario` int(11) DEFAULT NULL,
  `costo_individual` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `reservas_participantes`
--

INSERT INTO `reservas_participantes` (`id_participante`, `id_reserva`, `id_usuario`, `id_club_usuario`, `costo_individual`) VALUES
(1, 1, 1060, NULL, NULL),
(2, 2, 1060, NULL, NULL),
(3, 3, 1060, NULL, NULL),
(4, 4, 1060, NULL, NULL),
(5, 5, 1060, NULL, NULL),
(6, 6, 1085, NULL, NULL),
(7, 7, 1085, NULL, NULL),
(8, 8, 1085, NULL, NULL),
(9, 9, 1085, NULL, NULL),
(10, 10, 1085, NULL, NULL),
(11, 11, 1060, NULL, NULL),
(12, 12, 1060, NULL, NULL),
(13, 13, 1060, NULL, NULL),
(14, 14, 1088, NULL, NULL),
(16, 16, 1088, NULL, NULL),
(17, 17, 1060, NULL, NULL),
(18, 18, 1088, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_recurrentes`
--

CREATE TABLE `reservas_recurrentes` (
  `id_recurrencia` int(11) NOT NULL,
  `id_reserva_padre` int(11) NOT NULL,
  `fecha_sesion` date NOT NULL,
  `id_cancha` int(11) NOT NULL,
  `id_coach` int(11) DEFAULT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `orden_sesion` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva_historial`
--

CREATE TABLE `reserva_historial` (
  `id_historial` int(11) NOT NULL,
  `id_reserva` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `accion` enum('creacion','edicion','eliminacion','') COLLATE utf8_unicode_ci NOT NULL,
  `fecha_accion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `detalles_cambio` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `reserva_historial`
--

INSERT INTO `reserva_historial` (`id_historial`, `id_reserva`, `id_usuario`, `accion`, `fecha_accion`, `detalles_cambio`) VALUES
(1, 1, 1058, 'creacion', '2026-03-25 18:04:04', 'Reserva creada con 1 participante(s).'),
(2, 1, 1058, 'eliminacion', '2026-03-25 18:04:42', 'Reserva eliminada/cancelada por el administrador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultados_partidos_padel`
--

CREATE TABLE `resultados_partidos_padel` (
  `id_resultado` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `id_partido` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subcategoria_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fase_tipo` enum('grupo','final') COLLATE utf8mb4_unicode_ci NOT NULL,
  `grupo_index` int(11) DEFAULT NULL,
  `ronda_index` int(11) DEFAULT NULL,
  `partido_index` int(11) NOT NULL,
  `equipo_a_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `equipo_b_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `equipo_a_nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `equipo_b_nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `set1_a` int(11) DEFAULT NULL,
  `set1_b` int(11) DEFAULT NULL,
  `set2_a` int(11) DEFAULT NULL,
  `set2_b` int(11) DEFAULT NULL,
  `set3_a` int(11) DEFAULT NULL,
  `set3_b` int(11) DEFAULT NULL,
  `sets_a` int(11) DEFAULT NULL,
  `sets_b` int(11) DEFAULT NULL,
  `ganador_letra` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ultima_actualizacion` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `puntos_equipo_a` int(11) DEFAULT '0',
  `puntos_equipo_b` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rondas_americana`
--

CREATE TABLE `rondas_americana` (
  `id` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `ronda` int(11) NOT NULL,
  `id_jugador1_p1` int(11) DEFAULT NULL,
  `nombre_jugador1_p1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_jugador2_p1` int(11) DEFAULT NULL,
  `nombre_jugador2_p1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_jugador1_p2` int(11) DEFAULT NULL,
  `nombre_jugador1_p2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_jugador2_p2` int(11) DEFAULT NULL,
  `nombre_jugador2_p2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `puntos_p1` int(11) DEFAULT NULL,
  `puntos_p2` int(11) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` tinyint(4) DEFAULT '1',
  `puntos_tieBreak_p1` int(11) DEFAULT NULL,
  `puntos_tieBreak_p2` int(11) DEFAULT NULL,
  `nombre_cancha` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `rondas_americana`
--

INSERT INTO `rondas_americana` (`id`, `id_juego`, `ronda`, `id_jugador1_p1`, `nombre_jugador1_p1`, `id_jugador2_p1`, `nombre_jugador2_p1`, `id_jugador1_p2`, `nombre_jugador1_p2`, `id_jugador2_p2`, `nombre_jugador2_p2`, `puntos_p1`, `puntos_p2`, `fecha`, `estatus`, `puntos_tieBreak_p1`, `puntos_tieBreak_p2`, `nombre_cancha`) VALUES
(1, 1, 0, 27, 'Pedro', 28, 'Emilio', 29, 'Camargo', 30, 'Fer', 3, 4, '2026-03-26 18:59:30', 1, NULL, NULL, 'Cancha 1'),
(2, 1, 0, 31, 'Ser', 32, 'Charly', 33, 'Vghj', 34, 'Xvgfv', 6, 1, '2026-03-26 18:59:30', 1, NULL, NULL, 'Cancha 2'),
(3, 1, 1, 2, 'EmilioCG', 26, 'Carlos', 29, 'Camargo', 31, 'Ser', 0, 7, '2026-03-26 18:59:45', 1, NULL, NULL, 'Cancha 2'),
(4, 1, 1, 30, 'Fer', 33, 'Vghj', 32, 'Charly', 34, 'Xvgfv', 1, 6, '2026-03-26 18:59:45', 1, NULL, NULL, 'Cancha 1'),
(5, 1, 2, 2, 'EmilioCG', 27, 'Pedro', 32, 'Charly', 33, 'Vghj', 4, 3, '2026-03-26 19:00:26', 1, NULL, NULL, 'Cancha 2'),
(6, 1, 2, 26, 'Carlos', 28, 'Emilio', 31, 'Ser', 34, 'Xvgfv', 5, 2, '2026-03-26 19:00:26', 1, NULL, NULL, 'Cancha 1'),
(7, 1, 3, 2, 'EmilioCG', 28, 'Emilio', 26, 'Carlos', 27, 'Pedro', 5, 2, '2026-03-26 19:00:43', 1, NULL, NULL, 'Cancha 1'),
(8, 1, 3, 29, 'Camargo', 33, 'Vghj', 30, 'Fer', 34, 'Xvgfv', 1, 6, '2026-03-26 19:00:43', 1, NULL, NULL, 'Cancha 2'),
(9, 1, 4, 2, 'EmilioCG', 29, 'Camargo', 28, 'Emilio', 32, 'Charly', 7, 0, '2026-03-26 19:01:12', 1, NULL, NULL, 'Cancha 1'),
(10, 1, 4, 26, 'Carlos', 30, 'Fer', 27, 'Pedro', 31, 'Ser', 4, 3, '2026-03-26 19:01:12', 1, NULL, NULL, 'Cancha 2'),
(11, 2, 0, 2, 'EmilioCG', 35, 'Xbox', 36, 'Cnx', 37, 'Cnxnx x', 4, 5, '2026-03-26 19:07:22', 1, NULL, NULL, 'Cancha 1'),
(12, 2, 0, 38, 'Cnxnx', 39, 'Vnfbdjxx', 40, 'Cnxnccmgncv', 41, 'Cndndjdjxnfbc', 9, 0, '2026-03-26 19:07:22', 1, NULL, NULL, 'Cancha 2'),
(13, 2, 1, 2, 'EmilioCG', 36, 'Cnx', 38, 'Cnxnx', 40, 'Cnxnccmgncv', 7, 2, '2026-03-26 19:07:32', 1, NULL, NULL, 'Cancha 1'),
(14, 2, 1, 35, 'Xbox', 37, 'Cnxnx x', 39, 'Vnfbdjxx', 41, 'Cndndjdjxnfbc', 6, 3, '2026-03-26 19:07:32', 1, NULL, NULL, 'Cancha 2'),
(15, 2, 2, 2, 'EmilioCG', 37, 'Cnxnx x', 35, 'Xbox', 36, 'Cnx', 7, 2, '2026-03-26 19:07:46', 1, NULL, NULL, 'Cancha 2'),
(16, 2, 2, 38, 'Cnxnx', 41, 'Cndndjdjxnfbc', 39, 'Vnfbdjxx', 40, 'Cnxnccmgncv', 0, 9, '2026-03-26 19:07:46', 1, NULL, NULL, 'Cancha 1'),
(17, 2, 3, 2, 'EmilioCG', 38, 'Cnxnx', 35, 'Xbox', 39, 'Vnfbdjxx', 6, 3, '2026-03-26 19:08:03', 1, NULL, NULL, 'Cancha 1'),
(18, 2, 3, 36, 'Cnx', 40, 'Cnxnccmgncv', 37, 'Cnxnx x', 41, 'Cndndjdjxnfbc', 4, 5, '2026-03-26 19:08:03', 1, NULL, NULL, 'Cancha 2'),
(19, 3, 0, 2, 'EmilioCG', 42, 'Fgggg', 43, 'Fggg', 44, 'Jajj', 3, 4, '2026-03-26 19:13:02', 1, NULL, NULL, 'Cancha 1'),
(20, 3, 0, 45, 'Lol', 46, 'Chfdxz', 47, 'Ba', 48, 'Gnbcddd', 4, 3, '2026-03-26 19:13:02', 1, NULL, NULL, 'Cancha 2'),
(21, 3, 1, 2, 'EmilioCG', 43, 'Fggg', 45, 'Lol', 47, 'Ba', 3, 4, '2026-03-26 19:13:11', 1, NULL, NULL, 'Cancha 1'),
(22, 3, 1, 42, 'Fgggg', 44, 'Jajj', 46, 'Chfdxz', 48, 'Gnbcddd', 5, 2, '2026-03-26 19:13:11', 1, NULL, NULL, 'Cancha 2'),
(23, 3, 2, 2, 'EmilioCG', 44, 'Jajj', 42, 'Fgggg', 43, 'Fggg', 7, 0, '2026-03-26 19:13:34', 1, NULL, NULL, 'Cancha 2'),
(24, 3, 2, 45, 'Lol', 48, 'Gnbcddd', 46, 'Chfdxz', 47, 'Ba', 6, 1, '2026-03-26 19:13:34', 1, NULL, NULL, 'Cancha 1'),
(25, 10, 0, 58, 'Alma', 59, 'Leo', 60, 'Paula', 61, 'Mariana', 1, 7, '2026-04-03 15:37:10', 1, NULL, NULL, 'Cancha 1'),
(26, 10, 0, 62, 'Nury', 63, 'María del Carmen', 64, 'Jimena', 65, 'Grettel', 4, 4, '2026-04-03 15:37:10', 1, NULL, NULL, 'Cancha 2'),
(27, 11, 0, 2, 'EmilioCG', 66, 'Leo', 67, 'Paula', 68, 'Mariana', 1, 7, '2026-04-03 15:40:44', 1, NULL, NULL, 'Cancha 1'),
(28, 11, 0, 69, 'María del Carmen', 70, 'Nury', 71, 'Jimena', 72, 'Grettel', 4, 4, '2026-04-03 15:40:44', 1, NULL, NULL, 'Cancha 2'),
(29, 12, 0, 2, 'EmilioCG', 73, 'Paula', 74, 'Nury', 75, 'Jimena', 6, 2, '2026-04-03 16:05:04', 1, NULL, NULL, 'Cancha 1'),
(30, 12, 0, 76, 'Leo', 77, 'Carmen', 78, 'Mariana', 79, 'Grettel', 4, 4, '2026-04-03 16:05:04', 1, NULL, NULL, 'Cancha 2'),
(31, 12, 1, 2, 'EmilioCG', 74, 'Nury', 76, 'Leo', 78, 'Mariana', 6, 2, '2026-04-03 16:26:58', 1, NULL, NULL, 'Cancha 1'),
(32, 12, 1, 73, 'Paula', 75, 'Jimena', 77, 'Carmen', 79, 'Grettel', 2, 6, '2026-04-03 16:26:58', 1, NULL, NULL, 'Cancha 2'),
(33, 12, 2, 2, 'EmilioCG', 75, 'Jimena', 73, 'Paula', 74, 'Nury', 2, 6, '2026-04-03 16:55:18', 1, NULL, NULL, 'Cancha 2'),
(34, 12, 2, 76, 'Leo', 79, 'Grettel', 77, 'Carmen', 78, 'Mariana', 5, 3, '2026-04-03 16:55:18', 1, NULL, NULL, 'Cancha 1'),
(35, 13, 0, 80, 'Fran Beltran ', 81, 'Jorge', 82, 'Zamir', 84, 'Fran', 4, 2, '2026-04-03 17:07:06', 1, NULL, NULL, 'Cancha 1'),
(36, 13, 1, 2, 'EmilioCG', 82, 'Zamir', 81, 'Jorge', 84, 'Fran', 4, 2, '2026-04-03 17:07:20', 1, NULL, NULL, 'Cancha 1'),
(37, 13, 2, 2, 'EmilioCG', 84, 'Fran', 80, 'Fran Beltran ', 82, 'Zamir', 3, 3, '2026-04-03 17:07:34', 1, NULL, NULL, 'Cancha 1'),
(38, 12, 3, 2, 'EmilioCG', 76, 'Leo', 73, 'Paula', 77, 'Carmen', 4, 4, '2026-04-03 17:18:27', 1, NULL, NULL, 'Cancha 1'),
(39, 12, 3, 74, 'Nury', 78, 'Mariana', 75, 'Jimena', 79, 'Grettel', 5, 3, '2026-04-03 17:18:27', 1, NULL, NULL, 'Cancha 2'),
(40, 15, 0, 2, 'EmilioCG', 88, 'Marco', 89, 'Mario', 90, 'Mauricio', 1, 7, '2026-04-04 14:38:23', 1, NULL, NULL, 'Cancha 1'),
(41, 15, 0, 91, 'Diego', 92, 'Rafa', 93, 'Alfredo', 94, 'Lino', 3, 5, '2026-04-04 14:38:23', 1, NULL, NULL, 'Cancha 2'),
(42, 15, 1, 2, 'EmilioCG', 88, 'Marco', 91, 'Diego', 92, 'Rafa', 5, 3, '2026-04-04 14:56:30', 1, NULL, NULL, 'Cancha 1'),
(43, 15, 1, 89, 'Mario', 90, 'Mauricio', 93, 'Alfredo', 94, 'Lino', 1, 7, '2026-04-04 14:56:30', 1, NULL, NULL, 'Cancha 2'),
(44, 15, 2, 2, 'EmilioCG', 88, 'Marco', 93, 'Alfredo', 94, 'Lino', 5, 3, '2026-04-04 15:20:12', 1, NULL, NULL, 'Cancha 1'),
(45, 15, 2, 89, 'Mario', 90, 'Mauricio', 91, 'Diego', 92, 'Rafa', 4, 4, '2026-04-04 15:20:12', 1, NULL, NULL, 'Cancha 2'),
(46, 15, 3, 2, 'EmilioCG', 88, 'Marco', 89, 'Mario', 90, 'Mauricio', 5, 3, '2026-04-04 15:43:22', 1, NULL, NULL, 'Cancha 2'),
(47, 15, 3, 91, 'Diego', 92, 'Rafa', 93, 'Alfredo', 94, 'Lino', 4, 4, '2026-04-04 15:43:22', 1, NULL, NULL, 'Cancha 1'),
(48, 15, 4, 2, 'EmilioCG', 88, 'Marco', 91, 'Diego', 92, 'Rafa', 4, 4, '2026-04-04 16:02:51', 1, NULL, NULL, 'Cancha 2'),
(49, 15, 4, 89, 'Mario', 90, 'Mauricio', 93, 'Alfredo', 94, 'Lino', 2, 6, '2026-04-04 16:02:51', 1, NULL, NULL, 'Cancha 1'),
(50, 16, 0, 100, 'Pilo', 101, 'Rodrigo', 102, 'Nacho', 103, 'Pancho', 6, 2, '2026-04-04 16:48:14', 1, NULL, NULL, 'Cancha 1'),
(51, 16, 0, 104, 'Pablo', 105, 'Mau', 80, 'Fran Beltran ', 95, 'Jorge', 1, 7, '2026-04-04 16:48:14', 1, NULL, NULL, 'Cancha 2'),
(52, 16, 0, 96, 'Zamir', 97, 'Moi', 98, 'Norman', 99, 'Diego', 3, 5, '2026-04-04 16:48:14', 1, NULL, NULL, 'Cancha 3'),
(53, 16, 1, 100, 'Pilo', 102, 'Nacho', 104, 'Pablo', 80, 'Fran Beltran ', 4, 4, '2026-04-04 16:48:43', 1, NULL, NULL, 'Cancha 3'),
(54, 16, 1, 101, 'Rodrigo', 103, 'Pancho', 96, 'Zamir', 98, 'Norman', 6, 2, '2026-04-04 16:48:43', 1, NULL, NULL, 'Cancha 2'),
(55, 16, 1, 105, 'Mau', 95, 'Jorge', 97, 'Moi', 99, 'Diego', 5, 3, '2026-04-04 16:48:43', 1, NULL, NULL, 'Cancha 1'),
(56, 16, 2, 100, 'Pilo', 103, 'Pancho', 104, 'Pablo', 95, 'Jorge', 7, 1, '2026-04-04 16:49:09', 1, NULL, NULL, 'Cancha 3'),
(57, 16, 2, 101, 'Rodrigo', 102, 'Nacho', 96, 'Zamir', 99, 'Diego', 0, 8, '2026-04-04 16:49:09', 1, NULL, NULL, 'Cancha 2'),
(58, 16, 2, 105, 'Mau', 80, 'Fran Beltran ', 97, 'Moi', 98, 'Norman', 6, 2, '2026-04-04 16:49:09', 1, NULL, NULL, 'Cancha 1'),
(59, 16, 3, 100, 'Pilo', 104, 'Pablo', 101, 'Rodrigo', 105, 'Mau', 2, 6, '2026-04-04 16:49:58', 1, NULL, NULL, 'Cancha 1'),
(60, 16, 3, 102, 'Nacho', 96, 'Zamir', 103, 'Pancho', 97, 'Moi', 6, 2, '2026-04-04 16:49:58', 1, NULL, NULL, 'Cancha 2'),
(61, 16, 3, 80, 'Fran Beltran ', 98, 'Norman', 95, 'Jorge', 99, 'Diego', 6, 2, '2026-04-04 16:49:58', 1, NULL, NULL, 'Cancha 3'),
(62, 16, 4, 100, 'Pilo', 105, 'Mau', 103, 'Pancho', 96, 'Zamir', 4, 4, '2026-04-04 16:50:22', 1, NULL, NULL, 'Cancha 3'),
(63, 16, 4, 101, 'Rodrigo', 104, 'Pablo', 80, 'Fran Beltran ', 99, 'Diego', 3, 5, '2026-04-04 16:50:22', 1, NULL, NULL, 'Cancha 1'),
(64, 16, 4, 102, 'Nacho', 97, 'Moi', 95, 'Jorge', 98, 'Norman', 8, 0, '2026-04-04 16:50:22', 1, NULL, NULL, 'Cancha 2'),
(65, 16, 5, 100, 'Pilo', 80, 'Fran Beltran ', 103, 'Pancho', 99, 'Diego', 5, 3, '2026-04-04 16:50:38', 1, NULL, NULL, 'Cancha 2'),
(66, 16, 5, 101, 'Rodrigo', 95, 'Jorge', 105, 'Mau', 97, 'Moi', 2, 6, '2026-04-04 16:50:38', 1, NULL, NULL, 'Cancha 3'),
(67, 16, 5, 102, 'Nacho', 98, 'Norman', 104, 'Pablo', 96, 'Zamir', 6, 2, '2026-04-04 16:50:38', 1, NULL, NULL, 'Cancha 1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rondas_Reta`
--

CREATE TABLE `rondas_Reta` (
  `id_ronda_reta` int(11) NOT NULL,
  `num_ronda` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `id_jugador1` int(11) DEFAULT NULL,
  `us_jugador1` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `id_jugador2` int(11) DEFAULT NULL,
  `us_jugador2` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `set1` int(11) DEFAULT '0',
  `set2` int(11) DEFAULT '0',
  `set3` int(11) DEFAULT '0',
  `tiebreak` int(11) DEFAULT '0',
  `tiebreak2` int(11) DEFAULT NULL,
  `tiebreak3` int(11) DEFAULT NULL,
  `pareja` int(11) NOT NULL DEFAULT '0',
  `Estatus` int(11) NOT NULL DEFAULT '1',
  `e_set1` int(1) NOT NULL DEFAULT '1',
  `e_set2` int(1) NOT NULL DEFAULT '1',
  `e_set3` int(1) NOT NULL DEFAULT '1',
  `nombre_cancha` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `rondas_Reta`
--

INSERT INTO `rondas_Reta` (`id_ronda_reta`, `num_ronda`, `id_juego`, `id_jugador1`, `us_jugador1`, `id_jugador2`, `us_jugador2`, `set1`, `set2`, `set3`, `tiebreak`, `tiebreak2`, `tiebreak3`, `pareja`, `Estatus`, `e_set1`, `e_set2`, `e_set3`, `nombre_cancha`) VALUES
(1, 1, 14, 85, 'Zamir', 86, 'Moises', 2, 7, 4, NULL, NULL, NULL, 0, 3, 2, 2, 2, 'Cancha 1'),
(2, 1, 14, 87, 'Norman', 80, 'Fran Beltran ', 6, 5, 6, NULL, NULL, NULL, 0, 3, 2, 2, 2, 'Cancha 1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_categorias_finazas`
--

CREATE TABLE `sa_categorias_finazas` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `status` enum('activa','inactiva') NOT NULL DEFAULT 'activa',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `sa_categorias_finazas`
--

INSERT INTO `sa_categorias_finazas` (`id_categoria`, `nombre`, `tipo`, `descripcion`, `status`, `fecha_registro`) VALUES
(1, 'Comision reserva', 'ingreso', 'Comision fija automatica por reserva', 'activa', '2026-03-24 05:50:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_cortes_caja`
--

CREATE TABLE `sa_cortes_caja` (
  `id_corte` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `total_ingresos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_egresos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `saldo_final` decimal(10,2) NOT NULL DEFAULT '0.00',
  `observaciones` text,
  `status` enum('pendiente','cerrado','aprobado') NOT NULL DEFAULT 'pendiente',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `sa_cortes_caja`
--

INSERT INTO `sa_cortes_caja` (`id_corte`, `id_usuario`, `fecha_inicio`, `fecha_fin`, `total_ingresos`, `total_egresos`, `saldo_final`, `observaciones`, `status`, `fecha_creacion`) VALUES
(3, 76, '2026-01-25 00:00:00', '2026-01-25 23:59:59', 1213.00, 144.00, 1069.00, 'Corte de caja del 25/01/2026 | Corte de caja del 25/01/2026', 'cerrado', '2026-01-25 08:00:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_cortes_caja_detalles`
--

CREATE TABLE `sa_cortes_caja_detalles` (
  `id_detalle_corte` int(11) NOT NULL,
  `id_corte` int(11) NOT NULL,
  `id_club_metodo_pago` int(11) NOT NULL,
  `metodo_pago_nombre` varchar(150) DEFAULT NULL,
  `ingresos_sistema` decimal(10,2) NOT NULL DEFAULT '0.00',
  `egresos_sistema` decimal(10,2) NOT NULL DEFAULT '0.00',
  `balance_sistema` decimal(10,2) NOT NULL DEFAULT '0.00',
  `monto_real_contado` decimal(10,2) NOT NULL DEFAULT '0.00',
  `diferencia` decimal(10,2) NOT NULL DEFAULT '0.00',
  `notas` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `sa_cortes_caja_detalles`
--

INSERT INTO `sa_cortes_caja_detalles` (`id_detalle_corte`, `id_corte`, `id_club_metodo_pago`, `metodo_pago_nombre`, `ingresos_sistema`, `egresos_sistema`, `balance_sistema`, `monto_real_contado`, `diferencia`, `notas`) VALUES
(3, 3, 1, 'Tarjeta de Crédito', 1213.00, 144.00, 1069.00, 0.00, -1069.00, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_cortes_caja_movimientos`
--

CREATE TABLE `sa_cortes_caja_movimientos` (
  `id_movimiento_corte` int(11) NOT NULL,
  `id_corte` int(11) NOT NULL,
  `id_detalle_corte` int(11) NOT NULL,
  `tipo_movimiento` enum('ingreso','egreso') NOT NULL,
  `id_movimiento` int(11) NOT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `categoria_nombre` varchar(150) DEFAULT NULL,
  `concepto` varchar(255) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fecha_movimiento` datetime DEFAULT NULL,
  `nota` text,
  `metodo_pago_nombre` varchar(150) DEFAULT NULL,
  `id_club_metodo_pago` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_egresos`
--

CREATE TABLE `sa_egresos` (
  `id_egreso` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_club_metodo_pago` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` datetime NOT NULL,
  `concepto` varchar(255) NOT NULL,
  `nota` text,
  `id_corte_caja` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_ingresos`
--

CREATE TABLE `sa_ingresos` (
  `id_ingreso` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_club_metodo_pago` int(11) NOT NULL,
  `id_reserva` int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_pago_reserva` int(11) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` datetime NOT NULL,
  `concepto` varchar(255) NOT NULL,
  `nota` text,
  `id_corte_caja` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `sa_ingresos`
--

INSERT INTO `sa_ingresos` (`id_ingreso`, `id_categoria`, `id_club_metodo_pago`, `id_reserva`, `id_participante`, `id_pago_reserva`, `monto`, `fecha`, `concepto`, `nota`, `id_corte_caja`) VALUES
(1, 1, 1, 1, NULL, NULL, 20.00, '2026-03-25 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(2, 1, 1, 2, NULL, NULL, 20.00, '2026-03-26 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(3, 1, 1, 3, NULL, NULL, 20.00, '2026-03-26 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(4, 1, 1, 4, NULL, NULL, 20.00, '2026-03-26 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(5, 1, 1, 5, NULL, NULL, 20.00, '2026-03-26 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(6, 1, 1, 6, NULL, NULL, 20.00, '2026-03-31 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(7, 1, 1, 7, NULL, NULL, 20.00, '2026-03-31 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(8, 1, 1, 8, NULL, NULL, 20.00, '2026-03-31 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(9, 1, 1, 9, NULL, NULL, 20.00, '2026-03-31 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(10, 1, 1, 10, NULL, NULL, 20.00, '2026-03-31 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(11, 1, 1, 11, NULL, NULL, 20.00, '2026-04-03 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(12, 1, 1, 12, NULL, NULL, 20.00, '2026-04-03 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(13, 1, 1, 13, NULL, NULL, 20.00, '2026-04-03 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL),
(14, 1, 1, 14, NULL, NULL, 20.00, '2026-04-03 00:00:00', 'Comision fija por reserva', 'Movimiento automatico generado por reserva', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_metodos_pago`
--

CREATE TABLE `sa_metodos_pago` (
  `id_metodo` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estatus` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `sa_metodos_pago`
--

INSERT INTO `sa_metodos_pago` (`id_metodo`, `nombre`, `descripcion`, `estatus`, `fecha_registro`) VALUES
(1, 'Tarjeta de Crédito', 'sip', 1, '2026-01-25 07:34:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sa_metodo_pago`
--

CREATE TABLE `sa_metodo_pago` (
  `id` int(11) NOT NULL,
  `id_metodo` int(11) NOT NULL,
  `estatus` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `sa_metodo_pago`
--

INSERT INTO `sa_metodo_pago` (`id`, `id_metodo`, `estatus`, `fecha_registro`) VALUES
(1, 1, 1, '2026-01-25 01:34:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `secciones`
--

CREATE TABLE `secciones` (
  `id_seccion` int(11) NOT NULL,
  `id_modulo` int(11) DEFAULT NULL,
  `se_descripcion` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `se_icono` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `se_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `se_orden` int(11) DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `nombre_seccion` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `secciones`
--

INSERT INTO `secciones` (`id_seccion`, `id_modulo`, `se_descripcion`, `se_icono`, `se_url`, `se_orden`, `id_status`, `nombre_seccion`) VALUES
(0, 9, 'Tarifas', 'fas fa-users', 'private/web/administracion/FinanzasAdmin', 1, 1, 'Tarifas'),
(1, 2, 'Dar de lat tipos', 'fa-solid fa-building-ngo', 'private/web/administracion/Organizaciones', 2, 1, 'Organización'),
(2, 2, 'Dar de alta perfiles', 'fas fa-users', 'private/web/administracion/Administracion', 1, 1, 'Perfil'),
(6, 13, 'organi', 'fa-solid fa-building-ngo', 'private/web/organizaciones/Organizaciones', 5, 1, 'Alta organizaciones'),
(7, 13, 'Usuarios', 'fas fa-users', 'private/web/usuarios/Usuarios', 1, 1, 'Usuarios'),
(8, 7, 'Todos los clubs', 'fa-solid fa-table-tennis-paddle-ball', 'private/web/club/Perfil_club', 1, 1, 'Perfil Club'),
(9, 7, 'calendario de clubs', 'fa-solid fa-calendar', 'private/web/fraccionamientoAdmin/FraccionamientoCalendario', 2, 1, 'Calendario'),
(10, 7, 'clientes del club', 'fas fa-users', 'private/web/club/Clientes', 3, 1, 'Clientes'),
(11, 7, 'Ingresos del club', 'fa-solid fa-trophy', 'private/web/club/Torneos', 4, 1, 'Torneos'),
(13, 7, 'recompensas de la app', 'fa-solid fa-gift', 'private/web/club/Recompensas', 6, 1, 'Recompensas'),
(14, 7, 'canchas del club', 'fas fa-border-all', 'private/web/club/Canchas', 7, 1, 'Canchas'),
(15, 7, 'Horarios de la cancha', 'fa-solid fa-hourglass-half', 'private/web/club/Horarios', 8, 1, 'Horarios'),
(16, 7, 'colaboradores del club', 'fa-solid fa-screwdriver-wrench', 'private/web/club/Colaboradores', 9, 1, 'Colaboradores'),
(17, 2, 'Alta banners', 'fa-solid fa-image', 'private/web/banners/Banners', 3, 1, 'Publicidad'),
(18, 8, 'Admin fraccionamiento', 'fas fa-users', 'private/web/fraccionamientoAdmin/FraccionamientoAdmin', 1, 1, 'Alta admin'),
(19, 8, 'PerfilFraccionamiento', 'fas fa-building', 'private/web/fraccionamientoAdmin/FraccionamientoPerfil', 2, 1, 'Perfil Fraccionamiento'),
(20, 9, 'Finanzas Admin', 'fas fa-users', 'private/web/administracion/FinanzasAdmin', 1, 1, 'Suscripciones'),
(21, 9, 'Finanzas Clubs', 'fa-solid fa-circle-dollar-to-slot', 'private/web/club/ClubFinanzas', 4, 1, 'Ingresos'),
(22, 9, 'Finanzas Fraccionamiento', 'fa-solid fa-circle-dollar-to-slot', 'private/web/fraccionamientoAdmin/FraccionamientoFinanzas', 3, 1, 'Finanzas Fraccionamiento'),
(23, 8, 'Usuarios Fraccionamiento', 'fas fa-users', 'private/web/fraccionamientoAdmin/FraccionamientoClientes', 3, 1, 'Clientes'),
(24, 8, 'Horarios Fraccionamiento', 'fa-solid fa-clock', 'private/web/fraccionamientoAdmin/FraccionamientoHorarios', 4, 1, 'Horarios'),
(25, 8, 'Canchas Fraccionamiento', 'fas fa-border-all', 'private/web/fraccionamientoAdmin/FraccionamientoCanchas', 5, 1, 'Canchas'),
(26, 8, 'Calendario', 'fa-solid fa-calendar-days', 'private/web/fraccionamientoAdmin/FraccionamientoCalendario', 6, 1, 'Calendario'),
(27, 8, 'Noticias', 'fa-solid fa-newspaper', 'private/web/fraccionamientoAdmin/FraccionamientoNoticias', 7, 1, 'Noticias'),
(28, 9, 'Tarifas', 'fas fa-users', 'private/web/administracion/TarifaAdmin', 4, 1, 'Tarifas'),
(29, 2, 'Alta Videos', 'fa-solid fa-image', 'private/web/banners/Videos', 4, 1, 'Videos'),
(30, 7, 'Noticias', 'fa-solid fa-newspaper', 'private/web/fraccionamientoAdmin/FraccionamientoNoticias', 10, 1, 'Noticias'),
(31, 16, 'Reportes', 'fa-solid fa-newspaper', 'private/web/Reportes/Reportes_club', 11, 1, 'Reportes'),
(32, 16, 'Reporte de Usuarios', 'fas fa-users', 'private/web/Reportes/ReporteSA_usuarios', 1, 1, 'Usuarios'),
(33, 16, 'Reporte de Clubes', 'fa-solid fa-table-tennis-paddle-ball', 'private/web/Reportes/ReporteSA_clubes', 2, 1, 'Clubes'),
(34, 16, 'Reporte de Fraccionamientos', 'fas fa-city', 'private/web/Reportes/ReporteSA_fraccionamientos', 3, 1, 'Fraccionamientos'),
(35, 16, 'Reporte de Empresas', 'fas fa-building', 'private/web/Reportes/ReporteSA_empresas', 4, 1, 'Empresas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `id_solicitud` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `fecha_solicitud` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_facturacion`
--

CREATE TABLE `solicitudes_facturacion` (
  `id_solicitud` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `correo_contacto` varchar(150) NOT NULL,
  `mensaje` text,
  `status` enum('pendiente','contactado','cerrado','rechazado') NOT NULL DEFAULT 'pendiente',
  `admin_id` int(11) DEFAULT NULL,
  `admin_notas` text,
  `admin_visto` tinyint(1) NOT NULL DEFAULT '0',
  `club_visto` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `soporte_categories`
--

CREATE TABLE `soporte_categories` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `soporte_categories`
--

INSERT INTO `soporte_categories` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Cuenta y Acceso', 'Problemas con inicio de sesión, contraseña y configuración de cuenta', 1, '2026-01-21 18:54:42', '2026-01-21 18:54:42'),
(2, 'Pagos y Suscripciones', 'Preguntas sobre pagos, facturación y suscripciones', 1, '2026-01-21 18:54:42', '2026-01-21 18:54:42'),
(3, 'Funcionalidades', 'Ayuda con el uso de funcionalidades del sistema', 1, '2026-01-21 18:54:42', '2026-01-21 18:54:42'),
(4, 'Problemas Técnicos', 'Errores, bugs y problemas técnicos', 1, '2026-01-21 18:54:42', '2026-01-21 18:54:42'),
(5, 'Otros', 'Consultas generales y otros temas', 1, '2026-01-21 18:54:42', '2026-01-21 18:54:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `soporte_tickets`
--

CREATE TABLE `soporte_tickets` (
  `id` int(11) UNSIGNED NOT NULL,
  `id_usuario` int(11) NOT NULL COMMENT 'FK a tabla usuarios existente',
  `user_profile_id` int(11) DEFAULT NULL COMMENT 'ID del perfil del usuario (id_perfil)',
  `user_profile_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nombre del perfil (ej: Cliente, Administrador Club, etc.)',
  `user_full_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nombre completo del usuario',
  `user_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Teléfono del usuario',
  `user_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email del usuario',
  `category_id` int(11) UNSIGNED DEFAULT NULL,
  `assigned_to` int(11) DEFAULT NULL COMMENT 'ID del agente asignado (usuarios con perfil 18 o 20)',
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('open','in_progress','waiting_response','resolved','closed') COLLATE utf8mb4_unicode_ci DEFAULT 'open',
  `priority` enum('low','medium','high','urgent') COLLATE utf8mb4_unicode_ci DEFAULT 'medium',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `resolved_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `soporte_tickets`
--

INSERT INTO `soporte_tickets` (`id`, `id_usuario`, `user_profile_id`, `user_profile_name`, `user_full_name`, `user_phone`, `user_email`, `category_id`, `assigned_to`, `subject`, `description`, `status`, `priority`, `created_at`, `updated_at`, `resolved_at`) VALUES
(41, 1086, 16, 'Cliente', 'Daniel Pruebas', '4428730578', 'jugador@arosports.com', 1, NULL, 'Solo es una prueba', 'Prueba de camhatbot y página web', 'open', 'medium', '2026-04-02 18:03:00', '2026-04-02 18:03:00', NULL),
(42, 1086, 16, 'Cliente', 'Daniel Pruebas', '4428730578', 'jugador@arosports.com', 1, NULL, 'solo es una prueba aun jaja', 'solo es una prueba a ver si funcionan bien los botones', 'open', 'medium', '2026-04-02 18:20:08', '2026-04-02 18:20:08', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `soporte_ticket_attachments`
--

CREATE TABLE `soporte_ticket_attachments` (
  `id` int(11) UNSIGNED NOT NULL,
  `ticket_id` int(11) UNSIGNED NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filepath` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize` int(11) NOT NULL,
  `mimetype` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `soporte_ticket_attachments`
--

INSERT INTO `soporte_ticket_attachments` (`id`, `ticket_id`, `filename`, `filepath`, `filesize`, `mimetype`, `created_at`) VALUES
(13, 41, 'mnhs92os_e6ac8e93_TK41.jpg', 'uploads/tickets/mnhs92os_e6ac8e93_TK41.jpg', 120616, 'image/jpeg', '2026-04-02 18:03:01'),
(14, 42, 'mnhsv3hx_g4ck063q_TK42.jpg', 'uploads/tickets/mnhsv3hx_g4ck063q_TK42.jpg', 30964, 'image/jpeg', '2026-04-02 18:20:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `soporte_ticket_responses`
--

CREATE TABLE `soporte_ticket_responses` (
  `id` int(11) UNSIGNED NOT NULL,
  `ticket_id` int(11) UNSIGNED NOT NULL,
  `id_usuario` int(11) NOT NULL COMMENT 'FK a tabla usuarios existente',
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_agent` tinyint(1) DEFAULT '0' COMMENT '1 si es respuesta del agente, 0 si es del usuario',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `status`
--

CREATE TABLE `status` (
  `id_status` int(11) NOT NULL,
  `sta_nombre` varchar(35) COLLATE utf8_unicode_ci NOT NULL,
  `sta_descripcion` varchar(35) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `status`
--

INSERT INTO `status` (`id_status`, `sta_nombre`, `sta_descripcion`) VALUES
(1, 'Activo', 'Estado activo'),
(2, 'Inactivo', 'Estado inactivo'),
(3, 'Confirmado', 'invitación confirmada'),
(4, 'Pendiente', 'falta aceptar solicitud'),
(5, 'Rechazado', 'invitación rechazada'),
(6, 'pendiente Confirmar', 'usuario no a confirmo asistencia'),
(7, 'Aceptado por Desarrollo', 'cuando fue aceptado por el desarrol'),
(8, 'Rechazado por Desarrollo', 'cuando fue rechazado por el desarro'),
(9, 'Salir del juego', 'ya estaba dento pero decide cancela'),
(10, 'Segunda confirmación', 'horas antes del juego se confirma l'),
(11, 'Solicitud enviada', 'Solicitud enviada de jugadas public'),
(12, 'Entregado', 'Entrega de recompensas al usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suscripciones`
--

CREATE TABLE `suscripciones` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_plan` int(11) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_estatus` int(11) NOT NULL,
  `priceId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id_promotor` int(11) DEFAULT NULL,
  `porcentaje_promotor` decimal(5,2) DEFAULT NULL,
  `monto_promotor` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `suscripciones`
--

INSERT INTO `suscripciones` (`id`, `id_usuario`, `id_plan`, `fecha_inicio`, `fecha_fin`, `creado_en`, `id_estatus`, `priceId`, `id_promotor`, `porcentaje_promotor`, `monto_promotor`) VALUES
(1, 1086, 1, '2026-04-06 12:32:14', '2026-05-06 12:32:14', '2026-04-06 17:32:14', 1, '', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarifas`
--

CREATE TABLE `tarifas` (
  `id_tarifa` int(11) NOT NULL,
  `id_canchas` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `tipo` int(11) DEFAULT '1',
  `intervalo` time DEFAULT NULL,
  `horario_inicio` time DEFAULT NULL,
  `horario_fin` time DEFAULT NULL,
  `dia` enum('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo') COLLATE utf8_unicode_ci DEFAULT NULL,
  `puntos` decimal(10,2) NOT NULL,
  `id_horario_club` int(11) DEFAULT NULL,
  `moneda` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `tarifas`
--

INSERT INTO `tarifas` (`id_tarifa`, `id_canchas`, `precio`, `tipo`, `intervalo`, `horario_inicio`, `horario_fin`, `dia`, `puntos`, `id_horario_club`, `moneda`) VALUES
(539, 1, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(540, 1, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(541, 1, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(542, 1, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(543, 1, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(544, 1, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(545, 1, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(546, 1, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(547, 1, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(548, 1, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(549, 1, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(550, 1, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(551, 1, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(552, 1, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(553, 1, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(554, 1, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(555, 1, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(556, 1, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(557, 1, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(558, 1, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(559, 1, 500.00, 2, '01:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(560, 1, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(561, 1, 500.00, 1, '01:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(562, 1, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(707, 2, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(708, 2, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(709, 2, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(710, 2, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(711, 2, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(712, 2, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(713, 2, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(714, 2, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(715, 2, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(716, 2, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(717, 2, 500.00, 2, '01:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(718, 2, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(719, 2, 500.00, 1, '01:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(720, 2, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(721, 2, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(722, 2, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(723, 2, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(724, 2, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(725, 2, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(726, 2, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(727, 2, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(728, 2, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(729, 2, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(730, 2, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(785, 3, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(786, 3, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(787, 3, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(788, 3, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(789, 3, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(790, 3, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(791, 3, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(792, 3, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(793, 3, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(794, 3, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(795, 3, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(796, 3, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(797, 3, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(798, 3, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(799, 3, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(800, 3, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(801, 3, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(802, 3, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(803, 3, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(804, 3, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(805, 3, 500.00, 1, '01:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(806, 3, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(807, 3, 500.00, 2, '01:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(808, 3, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(809, 4, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(810, 4, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(811, 4, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(812, 4, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(813, 4, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(814, 4, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(815, 4, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(816, 4, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(817, 4, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(818, 4, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(819, 4, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(820, 4, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(821, 4, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(822, 4, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(823, 4, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(824, 4, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(825, 4, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(826, 4, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(827, 4, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(828, 4, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(829, 4, 500.00, 2, '01:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(830, 4, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(831, 4, 500.00, 2, '01:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(832, 4, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(911, 5, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(912, 5, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(913, 5, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(914, 5, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(915, 5, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(916, 5, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(917, 5, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(918, 5, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(919, 5, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(920, 5, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(921, 5, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(922, 5, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(923, 5, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(924, 5, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(925, 5, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(926, 5, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(927, 5, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(928, 5, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(929, 5, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(930, 5, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(931, 5, 500.00, 1, '01:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(932, 5, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(933, 5, 500.00, 2, '01:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(934, 5, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(1013, 6, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1014, 6, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1015, 6, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1016, 6, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1017, 6, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1018, 6, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1019, 6, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(1020, 6, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(1021, 6, 400.00, 1, '01:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(1022, 6, 800.00, 1, '02:00:00', '07:00:00', '17:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(1023, 6, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1024, 6, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1025, 6, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1026, 6, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1027, 6, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(1028, 6, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(1029, 6, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1030, 6, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1031, 6, 500.00, 2, '01:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(1032, 6, 1000.00, 1, '02:00:00', '17:00:00', '23:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(1033, 6, 500.00, 1, '01:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(1034, 6, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Domingo', 0.00, NULL, 'MXN'),
(1035, 6, 500.00, 2, '01:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(1036, 6, 1000.00, 1, '02:00:00', '08:00:00', '14:00:00', 'Sabado', 0.00, NULL, 'MXN'),
(1062, 7, 3.00, 1, '00:30:00', '00:00:00', '01:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1063, 7, 33.00, 1, '00:45:00', '00:00:00', '01:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1064, 7, 3.00, 1, '00:30:00', '00:00:00', '01:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1065, 7, 33.00, 1, '00:45:00', '00:00:00', '01:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1066, 7, 3.00, 1, '00:30:00', '00:00:00', '01:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1067, 7, 33.00, 1, '00:45:00', '00:00:00', '01:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1068, 7, 1111.00, 1, '01:30:00', '08:00:00', '16:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(1069, 7, 1111.00, 1, '01:30:00', '08:00:00', '16:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1070, 7, 1111.00, 1, '01:30:00', '08:00:00', '16:00:00', 'Miercoles', 0.00, NULL, 'MXN'),
(1071, 8, 3.00, 1, '00:30:00', '00:00:00', '01:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1072, 8, 33.00, 1, '00:45:00', '00:00:00', '01:00:00', 'Lunes', 0.00, NULL, 'MXN'),
(1073, 8, 3.00, 1, '00:30:00', '00:00:00', '01:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1074, 8, 33.00, 1, '00:45:00', '00:00:00', '01:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1075, 8, 3.00, 1, '00:30:00', '00:00:00', '01:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1076, 8, 33.00, 1, '00:45:00', '00:00:00', '01:00:00', 'Jueves', 0.00, NULL, 'MXN'),
(1077, 8, 1111.00, 1, '01:30:00', '08:00:00', '16:00:00', 'Viernes', 0.00, NULL, 'MXN'),
(1078, 8, 1111.00, 1, '01:30:00', '08:00:00', '16:00:00', 'Martes', 0.00, NULL, 'MXN'),
(1079, 8, 1111.00, 1, '01:30:00', '08:00:00', '16:00:00', 'Miercoles', 0.00, NULL, 'MXN');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos`
--

CREATE TABLE `tipos` (
  `id_tipo` int(11) NOT NULL,
  `tipo_nombre` varchar(35) COLLATE utf8_unicode_ci NOT NULL,
  `tipo_descripcion` varchar(35) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`id_tipo`, `tipo_nombre`, `tipo_descripcion`) VALUES
(1, 'Publica', 'son graccionamientos'),
(2, 'Privada', 'son clubs');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_banners`
--

CREATE TABLE `tipos_banners` (
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT '0.00',
  `divisa` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_banners`
--

INSERT INTO `tipos_banners` (`nombre`, `precio`, `divisa`) VALUES
('estatal', 5000.00, NULL),
('global', 15000.00, NULL),
('nacional', 10000.00, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_organizacion`
--

CREATE TABLE `tipo_organizacion` (
  `id_tipo_organizacion` int(11) NOT NULL,
  `to_nombre` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `to_descripcion` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `id_status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `tipo_organizacion`
--

INSERT INTO `tipo_organizacion` (`id_tipo_organizacion`, `to_nombre`, `to_descripcion`, `id_status`) VALUES
(5, 'Club', 'Tipo de organización fraccionamiento', 1),
(7, 'Fraccionamiento', 'Organización fraccionamiento', 1),
(15, 'Otro', 'Empresas, canchas independientes', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneos`
--

CREATE TABLE `torneos` (
  `id_torneos` int(11) NOT NULL,
  `torneo_nombre` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `torneo_fecha` date DEFAULT NULL,
  `id_modojuego` int(11) DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `imagen` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_cancha` int(11) DEFAULT NULL,
  `id_horario_club` int(11) DEFAULT NULL,
  `id_fraccionamientoclub` int(11) DEFAULT NULL,
  `Parejas` int(100) DEFAULT NULL,
  `moneda` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_nivelJuego` int(11) DEFAULT NULL,
  `duracionTorneo` int(11) DEFAULT NULL,
  `torneo_fecha_fin` date DEFAULT NULL,
  `torneo_hora_incio` time DEFAULT NULL,
  `torneo_hora_fin` time DEFAULT NULL,
  `es_torneo_seguido` tinyint(4) DEFAULT NULL,
  `fecha_cierre` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneos_localstorage`
--

CREATE TABLE `torneos_localstorage` (
  `id` int(11) NOT NULL,
  `storage_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `storage_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `tipo_datos` enum('programacion','intercambio','cambio_grupo') COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneos_metodos_pago`
--

CREATE TABLE `torneos_metodos_pago` (
  `id` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `id_metodo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneo_jugador`
--

CREATE TABLE `torneo_jugador` (
  `id_torneo_jugador` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `id_pareja` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_metodopago` int(11) DEFAULT NULL,
  `subcategoria` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_drafts`
--

CREATE TABLE `user_drafts` (
  `phone_number` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Número de teléfono del usuario (identificador único)',
  `draft` json NOT NULL COMMENT 'Estado completo del usuario en formato JSON',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del draft',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización del draft'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Tabla para mantener el estado conversacional de cada usuario';

--
-- Volcado de datos para la tabla `user_drafts`
--

INSERT INTO `user_drafts` (`phone_number`, `draft`, `created_at`, `updated_at`) VALUES
('5214422472440', '{\"data\": {}, \"flow\": \"soporte\", \"step\": \"menu_soporte\", \"user\": {\"correo\": \"fmbeltranbrea@gmail.com\", \"nombre\": \"Fran Beltrán \", \"apellido\": null, \"telefono\": \"4422472440\", \"id_perfil\": 16, \"id_usuario\": 799}, \"tieneSuscripcionActiva\": false}', '2026-02-12 19:19:45', '2026-02-12 19:20:04'),
('5214425986318', '{\"data\": {}, \"flow\": \"soporte\", \"step\": \"menu_soporte\", \"user\": {\"correo\": \"dan@impactosdigitales.com\", \"nombre\": \"Dan Raso Ríos\", \"apellido\": null, \"telefono\": \"4425986318\", \"id_perfil\": 16, \"id_usuario\": 105}, \"tieneSuscripcionActiva\": false}', '2026-01-29 19:02:14', '2026-02-12 19:24:23'),
('5214427243742', '{\"data\": {}, \"flow\": null, \"step\": \"menu\", \"user\": null}', '2026-01-29 22:39:48', '2026-01-29 22:40:22'),
('5214427869806', '{\"data\": {}, \"flow\": null, \"step\": \"menu\", \"user\": null}', '2026-01-28 17:18:58', '2026-01-30 18:12:58'),
('5214428730578', '{\"data\": {}, \"flow\": null, \"step\": \"menu\", \"user\": {\"correo\": \"jugador@arosports.com\", \"nombre\": \"Daniel\", \"apellido\": \"Pruebas\", \"telefono\": \"4428730578\", \"id_perfil\": 16, \"id_usuario\": 1086}}', '2026-02-10 19:48:49', '2026-04-06 17:33:21'),
('5214461421308', '{\"data\": {\"club_info\": {\"cp\": 76115, \"calle\": \"Avenida de la Luz\", \"estado\": \"Querétaro\", \"colonia\": \"El Garambullo\", \"num_ext\": 709, \"fc_nombre\": \"ClubPF\", \"num_canchas\": 3, \"id_fraccionamientoclub\": 121}}, \"flow\": \"info_club\", \"step\": \"menu_info\", \"user\": null}', '2026-01-29 18:22:20', '2026-01-29 18:23:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `us_correo` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_nombre` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_apellidop` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_sexo` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_nomUsuario` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_telefono` varchar(14) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_contrasena` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_foto` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `us_token` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL,
  `id_status` int(11) DEFAULT NULL,
  `id_perfil` int(11) DEFAULT NULL,
  `stripe_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `push_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login` int(1) NOT NULL DEFAULT '0',
  `fecha_nacimiento` date DEFAULT NULL,
  `us_portada` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_promotor` int(11) DEFAULT NULL,
  `codigo_promotor` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `us_correo`, `us_nombre`, `us_apellidop`, `us_sexo`, `us_nomUsuario`, `us_telefono`, `us_contrasena`, `us_foto`, `us_token`, `fecha_registro`, `id_status`, `id_perfil`, `stripe_id`, `id_categoria`, `push_token`, `login`, `fecha_nacimiento`, `us_portada`, `id_promotor`, `codigo_promotor`) VALUES
(76, 'superadmin@arosports.org', 'Super', 'Administrador', 'M', 'frbe#72', '0', '5b90b0b35f1a601ef0e5d294a5c7e3ce', NULL, '4c483fd9b153fcf73585d15ea2ddd7f7', '2025-01-08', 1, 17, 'cus_S3GMVcvxZvx5CJ', NULL, 'ExponentPushToken[3UrxTeAGYUP3klBPUlvURq]', 0, NULL, NULL, NULL, NULL),
(1057, 'developer@arosports.org', 'Developer', 'Developer', '', 'Developer', '4427243742', '45b629b6b0db86d8920424e31534c93e', NULL, '2cd52b2ed23d09890b762c0bc2554e20', '2026-03-24', 1, 14, 'cus_UCobxnOFZAeu0f', NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1058, 'emilio.camargo@theclubpadel.mx', 'Emilio', 'Camargo', 'M', '', '4425021867', '8168b09fe7c16f5bddd262bbaf7313b2', NULL, '9baad9060ff5672db08d814c2b06cffd', '2026-03-25', 1, 14, 'cus_UDKMX0M2nHBm2g', NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1060, 'emilio_cg@hotmail.com', 'Emilio', NULL, 'M', 'EmilioCG', '4421390491', 'a0937ed6535639bae4feccddd204709b', 'profile2_pic_movil_20260325_105000692.jpg', 'f333ce5a1b4afd2b80e7c40259234b87', '2026-03-25', 1, 16, 'cus_UDip6bvaRdnE5B', 4, 'ExponentPushToken[_8aDtUCJer3zsGkzVK0CS5]', 1, '1986-07-01', NULL, NULL, NULL),
(1079, 'promo@gmail.com', 'Promo', NULL, '', 'promo', '3232323233', '210b48b542659fb951a80a15c5997513', NULL, NULL, '2026-03-25', 1, 16, 'cus_UDPdup2gLj1znI', 6, NULL, 0, NULL, NULL, 1, 'P8KA8A7C'),
(1080, 'testingios@gmail.com', 'testingios', NULL, '', 'testingios', '9999999999', '81c7581e45ebb212980031ae3c8b9188', 'profile2_pic_movil_20260404_113246751.jpg', NULL, '2026-03-25', 1, 16, 'cus_UDQyRonBTLrRQC', 6, NULL, 1, NULL, 'cover_pic_movil_20260404_113259862.jpg', NULL, NULL),
(1081, 'test@example.com', 'John Doe', NULL, '', 'johndoe123', '1234567890', '2c103f2c4ed1e59c0b4e2e01821770fa', NULL, NULL, '2026-03-25', 1, 16, 'cus_UDR8kcpndwjs9c', 6, NULL, 1, NULL, NULL, NULL, NULL),
(1082, 'clau-ev@hotmail.com', 'Claudia Aguilera', NULL, 'F', 'Clau-ev', '5536774895', 'b6dc93afbaa7a7737de2c72573590f06', NULL, NULL, '2026-03-25', 1, 16, 'cus_UDShXdxodWZayR', 6, 'ExponentPushToken[gkRv2wMtTkSQuKegAk6HgJ]', 1, '1984-07-25', NULL, NULL, NULL),
(1083, 'developerm@arosports.org', 'Developer', NULL, '', 'Developerm', '8888888888', '210b48b542659fb951a80a15c5997513', NULL, NULL, '2026-03-26', 1, 16, 'cus_UDip6bvaRdnE5B', 6, 'ExponentPushToken[UQnuQRBidqejwB3d8RfzF2]', 1, NULL, NULL, NULL, NULL),
(1084, 'recepcion@theclubpadel.mx', 'Recepcion 1', NULL, NULL, 'Recepcion', '4444444444', '0add22c7e2b18d3d5fd37cfdefc553cb', NULL, '4153cdd7e9f355523b3c9040caffd0ae', '2026-03-30', 1, 21, 'cus_UDKMX0M2nHBm2g', NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1085, 'monimtya@gmail.com', 'Monica Montoya ', NULL, 'F', 'Moni', '4616794046', 'bcfe5bef6ec8d11a79fa0953d0bdef3c', NULL, NULL, '2026-03-30', 1, 16, 'cus_UFNxrUPb7KINdv', 6, 'ExponentPushToken[gZfMlrF21PYTWru2L-r-uV]', 1, '1994-12-08', NULL, 1, 'P8KA8A7C'),
(1086, 'jugador@arosports.com', 'Daniel', 'Pruebas', 'M', 'daniel_pruebas', '4428730578', 'c57998bb11793acab2f47decf507e36c', NULL, '94cd0683c31dbfc70f88237aaa41e12a', NULL, 1, 16, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1087, 'admin@arosports.com', 'Admin', 'Soporte', 'M', 'admin_soporte', '5559876543', '0192023a7bbd73250516f069df18b500', NULL, '8564849dbe60303df85539766cf80e6c', NULL, 1, 22, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1088, 'fmbeltranbrea@gmail.com', 'Francisco Beltrán ', NULL, 'M', 'Fran Beltran ', '4422472440', '1cb05902f4339c06683d87e7c8a49462', 'profile2_pic_movil_20260403_105805824.jpg', NULL, '2026-04-03', 1, 16, 'cus_UGiNAPVk35jxr3', 4, 'ExponentPushToken[4Q_-78IZs7HTsizUALvB7t]', 1, '1986-06-02', 'cover_pic_movil_20260404_110432330.jpg', NULL, NULL),
(1089, 'developer2@arosports.org', 'Developer2', NULL, '', 'Devem', '8787787877', '210b48b542659fb951a80a15c5997513', NULL, NULL, '2026-04-03', 1, 16, 'cus_UGiY5DYVZycHe1', 6, 'ExponentPushToken[iqHHg6F9a83eOtFmZj2Ros]', 1, NULL, NULL, NULL, NULL),
(1090, 'ubaldoaviles1@gmail.com', 'Uba', NULL, NULL, 'UBA', '3333333333', '742b01e983063ca990ff9f6b1c4e0c17', NULL, '712cc3ad1940b85129a53a1b8bc61438', '2026-04-03', 1, 21, 'cus_UDKMX0M2nHBm2g', NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1091, 'elenaz@gmail.com', 'Elena', 'Saenz', 'F', 'ele678', '4423678909', 'b6c37b01b9ad9ee4daa6cabeaa5f3754', NULL, '2c8abaea1628121f9dbee645d591276e', '2026-04-03', 1, 14, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1092, 'prueba@gmail.com', 'PRUEBA', 'PRUEBA', '', 'PRUEBA', '', '210b48b542659fb951a80a15c5997513', NULL, NULL, '2026-04-03', 1, 14, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL),
(1093, 'elenas@gmail.com', 'Elena', 'Saens', 'F', 'eleu78', '4421236789', 'b6c37b01b9ad9ee4daa6cabeaa5f3754', NULL, 'ec68b1bd772bbf439496c922b027e4c8', '2026-04-03', 1, 14, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_promotores`
--

CREATE TABLE `usuarios_promotores` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `codigo_promotor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_suscripciones`
--

CREATE TABLE `usuarios_suscripciones` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `categoria` enum('usuarios','club','desarrollos') COLLATE utf8_unicode_ci NOT NULL,
  `stripe_customer_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `stripe_subscription_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'active',
  `current_period_start` datetime DEFAULT NULL,
  `current_period_end` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_premios`
--

CREATE TABLE `usuario_premios` (
  `id_usuario_premio` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_premio` int(11) NOT NULL,
  `id_fraccionamientoclub` int(11) NOT NULL,
  `id_status` int(11) NOT NULL,
  `fecha_canje` date DEFAULT NULL,
  `fecha_entrega` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `videos`
--

CREATE TABLE `videos` (
  `id` int(11) NOT NULL,
  `video` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `estatus` tinyint(1) DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `orden` int(11) NOT NULL DEFAULT '0',
  `estado` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pais` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tipo` enum('estatal','nacional','global') COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `videos`
--

INSERT INTO `videos` (`id`, `video`, `estatus`, `fecha_creacion`, `fecha_modificacion`, `orden`, `estado`, `pais`, `tipo`) VALUES
(1, 'static/uploads/videos/video1.mp4', 1, '2025-03-18 17:32:01', '2025-05-14 01:49:47', 1, '', '', 'global'),
(2, 'static/uploads/videos/video1.mp4', 2, '2025-03-18 17:43:31', '2025-05-07 20:20:44', 2, 'queretato', 'mexico', 'estatal');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_reservas_con_pagos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_reservas_con_pagos` (
`id_usuario` int(11)
,`us_nombre` varchar(25)
,`us_apellidop` varchar(45)
,`us_correo` varchar(35)
,`us_telefono` varchar(14)
,`id_reserva` int(11)
,`fecha` date
,`hora_inicio` time
,`hora_fin` time
,`precio` decimal(10,2)
,`tipo_evento` enum('reserva','clase','academia','bloqueo')
,`id_participante` int(11)
,`costo_individual` decimal(10,2)
,`id_pago` int(11)
,`monto` decimal(10,2)
,`metodo_pago` varchar(50)
,`fecha_pago` datetime
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_reservas_con_pagos`
--
DROP TABLE IF EXISTS `vista_reservas_con_pagos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`arosports`@`localhost` SQL SECURITY DEFINER VIEW `vista_reservas_con_pagos`  AS SELECT `u`.`id_usuario` AS `id_usuario`, `u`.`us_nombre` AS `us_nombre`, `u`.`us_apellidop` AS `us_apellidop`, `u`.`us_correo` AS `us_correo`, `u`.`us_telefono` AS `us_telefono`, `r`.`id_reserva` AS `id_reserva`, `r`.`fecha` AS `fecha`, `r`.`hora_inicio` AS `hora_inicio`, `r`.`hora_fin` AS `hora_fin`, `r`.`precio` AS `precio`, `r`.`tipo_evento` AS `tipo_evento`, `rp`.`id_participante` AS `id_participante`, `rp`.`costo_individual` AS `costo_individual`, `p`.`id` AS `id_pago`, `p`.`monto` AS `monto`, `p`.`metodo_pago` AS `metodo_pago`, `p`.`fecha` AS `fecha_pago` FROM (((`usuarios` `u` join `reservas_participantes` `rp` on((`u`.`id_usuario` = `rp`.`id_usuario`))) join `reservas` `r` on((`rp`.`id_reserva` = `r`.`id_reserva`))) join `pagos_reserva` `p` on((`rp`.`id_participante` = `p`.`id_participante`))) WHERE (`p`.`monto` is not null) ORDER BY `u`.`id_usuario` ASC, `r`.`fecha` ASC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD PRIMARY KEY (`id_Administrador`),
  ADD UNIQUE KEY `idAdministrador_UNIQUE` (`id_Administrador`),
  ADD KEY `id_usuario_idx` (`id_usuario`),
  ADD KEY `id_fraccinamientoclub_idx` (`id_franccionamientoclub`),
  ADD KEY `id_status` (`id_status`);

--
-- Indices de la tabla `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_id_promotor` (`id_promotor`),
  ADD KEY `fk_tipos_banners` (`tipo`);

--
-- Indices de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD PRIMARY KEY (`id_calif`),
  ADD UNIQUE KEY `id_calif_UNIQUE` (`id_calif`),
  ADD KEY `id_usuario_calificacion_idx` (`id_usuario`);

--
-- Indices de la tabla `cambios_grupos_torneo`
--
ALTER TABLE `cambios_grupos_torneo`
  ADD PRIMARY KEY (`id_cambio`),
  ADD KEY `idx_torneo_categoria` (`id_torneo`,`categoria_id`,`subcategoria_id`),
  ADD KEY `idx_pareja` (`pareja_id`),
  ADD KEY `idx_fecha` (`fecha_cambio`),
  ADD KEY `idx_timestamp` (`timestamp_storage`);

--
-- Indices de la tabla `cambios_grupo_padel`
--
ALTER TABLE `cambios_grupo_padel`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cambio` (`id_torneo`,`categoria_id`,`subcategoria_id`,`equipo_id`);

--
-- Indices de la tabla `canchas`
--
ALTER TABLE `canchas`
  ADD PRIMARY KEY (`id_canchas`),
  ADD KEY `id_status_idx` (`id_status`),
  ADD KEY `id_fraccionamientoclub_idx` (`id_fraccionamientoclub`);

--
-- Indices de la tabla `canchasTorneo`
--
ALTER TABLE `canchasTorneo`
  ADD PRIMARY KEY (`idCanchasTorneo`),
  ADD KEY `idCancha` (`idCancha`),
  ADD KEY `idTorneo` (`idTorneo`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `categoriasTorneo`
--
ALTER TABLE `categoriasTorneo`
  ADD PRIMARY KEY (`idCategoriasTorneo`),
  ADD KEY `id_nivelJuego` (`id_nivelJuego`),
  ADD KEY `id_torneos` (`id_torneos`);

--
-- Indices de la tabla `categorias_finazas`
--
ALTER TABLE `categorias_finazas`
  ADD PRIMARY KEY (`id_categoria`),
  ADD KEY `fk_categoria_club` (`id_fraccionamientoclub`);

--
-- Indices de la tabla `club_metodo_pago`
--
ALTER TABLE `club_metodo_pago`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_fraccionamientoclub` (`id_fraccionamientoclub`),
  ADD KEY `id_metodo` (`id_metodo`);

--
-- Indices de la tabla `coaches`
--
ALTER TABLE `coaches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `coa_correo` (`coa_correo`),
  ADD KEY `id_fraccionamientoclub` (`id_fraccionamientoclub`),
  ADD KEY `coaches_ibfk_2` (`id_status`);

--
-- Indices de la tabla `coach_prices`
--
ALTER TABLE `coach_prices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_price` (`coach_id`,`tipo`,`cantidad_personas`);

--
-- Indices de la tabla `codigos_prueba`
--
ALTER TABLE `codigos_prueba`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_codigos_prueba_codigo` (`codigo`),
  ADD KEY `idx_codigos_prueba_estatus` (`estatus`),
  ADD KEY `idx_codigos_prueba_categoria` (`categoria`),
  ADD KEY `idx_codigos_prueba_usuario` (`usado_por_usuario_id`);

--
-- Indices de la tabla `cortes_caja`
--
ALTER TABLE `cortes_caja`
  ADD PRIMARY KEY (`id_corte`),
  ADD KEY `idx_fraccionamientoclub` (`id_fraccionamientoclub`),
  ADD KEY `idx_usuario` (`id_usuario`),
  ADD KEY `idx_status` (`status`);

--
-- Indices de la tabla `cortes_caja_detalles`
--
ALTER TABLE `cortes_caja_detalles`
  ADD PRIMARY KEY (`id_detalle_corte`),
  ADD KEY `idx_corte` (`id_corte`),
  ADD KEY `idx_metodo` (`id_club_metodo_pago`);

--
-- Indices de la tabla `cortes_caja_movimientos`
--
ALTER TABLE `cortes_caja_movimientos`
  ADD PRIMARY KEY (`id_relacion`),
  ADD KEY `idx_corte` (`id_corte`),
  ADD KEY `idx_tipo_movimiento` (`tipo_movimiento`,`id_movimiento`),
  ADD KEY `idx_detalle_corte` (`id_detalle_corte`),
  ADD KEY `idx_categoria` (`id_categoria`);

--
-- Indices de la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `id_status_idx` (`id_status`),
  ADD KEY `fk_id_usuario` (`id_usuario`);

--
-- Indices de la tabla `directorio_clubes`
--
ALTER TABLE `directorio_clubes`
  ADD PRIMARY KEY (`id_directorio_club`);

--
-- Indices de la tabla `egresos`
--
ALTER TABLE `egresos`
  ADD PRIMARY KEY (`id_egreso`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `id_club_metodo_pago` (`id_club_metodo_pago`),
  ADD KEY `fk_egreso_club` (`id_fraccionamientoclub`),
  ADD KEY `idx_corte_caja` (`id_corte_caja`);

--
-- Indices de la tabla `egresos_ingresos`
--
ALTER TABLE `egresos_ingresos`
  ADD PRIMARY KEY (`id_egresosIngresos`),
  ADD KEY `id_fraccionamientoclub_idx` (`id_fraccionamientoClub`),
  ADD KEY `id_usuario_idx` (`id_usuario`);

--
-- Indices de la tabla `estados`
--
ALTER TABLE `estados`
  ADD PRIMARY KEY (`id_estados`),
  ADD KEY `id_pais_idx` (`id_pais`);

--
-- Indices de la tabla `estatus_planes`
--
ALTER TABLE `estatus_planes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `evento_categoria`
--
ALTER TABLE `evento_categoria`
  ADD PRIMARY KEY (`id_evento_categoria`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Indices de la tabla `faqs`
--
ALTER TABLE `faqs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_categoria` (`id_categoria`),
  ADD KEY `idx_vistas` (`vistas`);

--
-- Indices de la tabla `faq_categorias`
--
ALTER TABLE `faq_categorias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nombre` (`nombre`);

--
-- Indices de la tabla `fraccionamientoClub_usuarios`
--
ALTER TABLE `fraccionamientoClub_usuarios`
  ADD PRIMARY KEY (`id_club_usuario`),
  ADD KEY `id_fraccionamientoclub` (`id_fraccionamientoclub`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_status` (`id_status`),
  ADD KEY `fraccionamientoClub_usuarios_ibfk_4` (`cus_categoria`);

--
-- Indices de la tabla `fraccionamiento_club`
--
ALTER TABLE `fraccionamiento_club`
  ADD PRIMARY KEY (`id_fraccionamientoclub`),
  ADD UNIQUE KEY `id_fraccionamientoclub_UNIQUE` (`id_fraccionamientoclub`),
  ADD KEY `id_direccion_idx` (`id_direccion`),
  ADD KEY `fk_tipo_organizacion` (`tipo`),
  ADD KEY `fk_estatus` (`id_status`),
  ADD KEY `idx_fraccionamiento_club_stripe_account_id` (`stripe_account_id`);

--
-- Indices de la tabla `horaDiaTorneo`
--
ALTER TABLE `horaDiaTorneo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_torneos` (`id_torneos`);

--
-- Indices de la tabla `horarios_club`
--
ALTER TABLE `horarios_club`
  ADD PRIMARY KEY (`id_horario_club`),
  ADD KEY `id_fraccionamientoclub_idx` (`id_fraccionamientoclub`);

--
-- Indices de la tabla `imagen_club_fraccionamiento`
--
ALTER TABLE `imagen_club_fraccionamiento`
  ADD PRIMARY KEY (`id_imagen_club_fraccionamiento`),
  ADD KEY `id_club_fraccionamiento` (`id_club_fraccionamiento`);

--
-- Indices de la tabla `ingresos`
--
ALTER TABLE `ingresos`
  ADD PRIMARY KEY (`id_ingreso`),
  ADD KEY `idx_id_reserva` (`id_reserva`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `id_pago_reserva` (`id_pago_reserva`),
  ADD KEY `id_club_metodo_pago` (`id_club_metodo_pago`),
  ADD KEY `fk_ingreso_club` (`id_fraccionamientoclub`),
  ADD KEY `idx_corte_caja` (`id_corte_caja`);

--
-- Indices de la tabla `juegos`
--
ALTER TABLE `juegos`
  ADD PRIMARY KEY (`id_juego`),
  ADD KEY `id_cancha_juego_idx` (`id_cancha`),
  ADD KEY `id_niveljuego_juego_idx` (`id_categoria`),
  ADD KEY `id_modojuego_juego_idx` (`id_modojuego`),
  ADD KEY `id_torneo_juego_idx` (`id_torneo`),
  ADD KEY `id_tipo_juego` (`id_tipo`),
  ADD KEY `fk_id_reserva` (`id_reserva`),
  ADD KEY `fk_id_usuario_juego` (`id_usuario`),
  ADD KEY `fk_id_fraccionamientoclub` (`id_fraccionamientoclub`),
  ADD KEY `id_direccion` (`id_direccion`);

--
-- Indices de la tabla `juegos_prueba`
--
ALTER TABLE `juegos_prueba`
  ADD PRIMARY KEY (`id_juegosprueba`),
  ADD UNIQUE KEY `id_juegosprueba_UNIQUE` (`id_juegosprueba`),
  ADD KEY `id_modojuego_pruebas_idx` (`id_modojuego`),
  ADD KEY `id_jugador_prueba_idx` (`id_jugador`);

--
-- Indices de la tabla `juego_canchas`
--
ALTER TABLE `juego_canchas`
  ADD KEY `id_juego` (`id_juego`),
  ADD KEY `id_cancha` (`id_cancha`);

--
-- Indices de la tabla `juego_confirmaciones_americana`
--
ALTER TABLE `juego_confirmaciones_americana`
  ADD PRIMARY KEY (`id_confirmacion`),
  ADD UNIQUE KEY `uniq_juego_jugador` (`id_juego`,`id_jugador`),
  ADD KEY `idx_juego` (`id_juego`);

--
-- Indices de la tabla `juego_confirmaciones_reta`
--
ALTER TABLE `juego_confirmaciones_reta`
  ADD PRIMARY KEY (`id_confirmacion`),
  ADD UNIQUE KEY `uniq_juego_jugador` (`id_juego`,`id_jugador`),
  ADD KEY `idx_juego` (`id_juego`);

--
-- Indices de la tabla `juego_jugadores`
--
ALTER TABLE `juego_jugadores`
  ADD PRIMARY KEY (`id_juego_jugadores`),
  ADD KEY `id_jugador_juego_idx` (`id_jugador`),
  ADD KEY `id_juego_jugador_idx` (`id_juego`),
  ADD KEY `fk_id_status` (`id_status`);

--
-- Indices de la tabla `jugadaAmericana`
--
ALTER TABLE `jugadaAmericana`
  ADD PRIMARY KEY (`id_jugadaAmericana`),
  ADD KEY `id_jugador1` (`id_jugador1`),
  ADD KEY `id_jugador2` (`id_jugador2`),
  ADD KEY `id_juego` (`id_juego`);

--
-- Indices de la tabla `jugadaReta`
--
ALTER TABLE `jugadaReta`
  ADD PRIMARY KEY (`id_jugadaReta`),
  ADD KEY `id_jugador1` (`id_jugador1`),
  ADD KEY `id_jugador2` (`id_jugador2`),
  ADD KEY `id_juego` (`id_juego`);

--
-- Indices de la tabla `jugadores`
--
ALTER TABLE `jugadores`
  ADD PRIMARY KEY (`id_jugador`),
  ADD UNIQUE KEY `id_jugador_UNIQUE` (`id_jugador`),
  ADD KEY `id_usuario_idx` (`id_usuario`),
  ADD KEY `id_nivelJuego_idx` (`id_categoria`),
  ADD KEY `id_status_idx` (`id_status`);

--
-- Indices de la tabla `menu_asociados`
--
ALTER TABLE `menu_asociados`
  ADD KEY `fk_permiso_perfil` (`id_perfil`),
  ADD KEY `fk_permiso_seccion` (`id_seccion`),
  ADD KEY `fk_permiso_modulo` (`id_modulo`);

--
-- Indices de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  ADD PRIMARY KEY (`id_metodo`);

--
-- Indices de la tabla `modojuego`
--
ALTER TABLE `modojuego`
  ADD PRIMARY KEY (`id_modojuego`),
  ADD KEY `id_status_modojuego_idx` (`id_status`);

--
-- Indices de la tabla `modulo`
--
ALTER TABLE `modulo`
  ADD PRIMARY KEY (`mod_id`);

--
-- Indices de la tabla `modulos`
--
ALTER TABLE `modulos`
  ADD PRIMARY KEY (`id_modulo`),
  ADD KEY `id_status_modulo_idx` (`id_status`),
  ADD KEY `id_perfil_modulo` (`id_perfil`);

--
-- Indices de la tabla `modulos_superadmin`
--
ALTER TABLE `modulos_superadmin`
  ADD PRIMARY KEY (`mod_id`);

--
-- Indices de la tabla `movimientos_pendientes`
--
ALTER TABLE `movimientos_pendientes`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `id_club_metodo_pago` (`id_club_metodo_pago`),
  ADD KEY `fk_movimiento_club` (`id_fraccionamientoclub`),
  ADD KEY `fk_movimiento_categoria` (`id_categoria`);

--
-- Indices de la tabla `municipio`
--
ALTER TABLE `municipio`
  ADD PRIMARY KEY (`id_municipio`),
  ADD KEY `id_estado_idx` (`id_estado`);

--
-- Indices de la tabla `niveljuego`
--
ALTER TABLE `niveljuego`
  ADD PRIMARY KEY (`id_nivelJuego`);

--
-- Indices de la tabla `noticias`
--
ALTER TABLE `noticias`
  ADD PRIMARY KEY (`id_noticias`),
  ADD KEY `id_status` (`id_status`),
  ADD KEY `id_fraccionamientoclub` (`id_fraccionamientoclub`),
  ADD KEY `id_tipo` (`id_tipo`);

--
-- Indices de la tabla `notificaciones_enviadas`
--
ALTER TABLE `notificaciones_enviadas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`,`id_torneo`,`tipo_notificacion`);

--
-- Indices de la tabla `notificaciones_juegos`
--
ALTER TABLE `notificaciones_juegos`
  ADD PRIMARY KEY (`id_notificacion`),
  ADD UNIQUE KEY `unq_notificacion` (`id_jugador`,`id_juego`,`tipo_notificacion`),
  ADD KEY `id_juego` (`id_juego`);

--
-- Indices de la tabla `notificaciones_reservas`
--
ALTER TABLE `notificaciones_reservas`
  ADD PRIMARY KEY (`id_notificacion`),
  ADD KEY `id_usuario_idx` (`id_usuario`),
  ADD KEY `id_reserva_idx` (`id_reserva`);

--
-- Indices de la tabla `pagos_reserva`
--
ALTER TABLE `pagos_reserva`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_reserva` (`id_reserva`),
  ADD KEY `id_participante` (`id_participante`);

--
-- Indices de la tabla `pais`
--
ALTER TABLE `pais`
  ADD PRIMARY KEY (`id_pais`);

--
-- Indices de la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`id_perfil`),
  ADD KEY `id_status_idx` (`id_status`);

--
-- Indices de la tabla `perfil_modulo`
--
ALTER TABLE `perfil_modulo`
  ADD PRIMARY KEY (`id_perfil`,`id_modulo`),
  ADD KEY `id_modulo` (`id_modulo`);

--
-- Indices de la tabla `permisos_admin_rol`
--
ALTER TABLE `permisos_admin_rol`
  ADD PRIMARY KEY (`id_perfil`,`mod_id`),
  ADD KEY `fk_mod_id_supers` (`mod_id`);

--
-- Indices de la tabla `permisos_admin_usuario`
--
ALTER TABLE `permisos_admin_usuario`
  ADD PRIMARY KEY (`id_usuario`,`mod_id`),
  ADD KEY `fk_mod_id_Super` (`mod_id`);

--
-- Indices de la tabla `permisos_rol`
--
ALTER TABLE `permisos_rol`
  ADD KEY `id_perfil` (`id_perfil`),
  ADD KEY `mod_id` (`mod_id`);

--
-- Indices de la tabla `permisos_usuario`
--
ALTER TABLE `permisos_usuario`
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `mod_id` (`mod_id`);

--
-- Indices de la tabla `planes_suscripcion`
--
ALTER TABLE `planes_suscripcion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `precios_torneo`
--
ALTER TABLE `precios_torneo`
  ADD PRIMARY KEY (`id_precio`),
  ADD KEY `fk_id_torneo_precio` (`id_torneo`);

--
-- Indices de la tabla `premios`
--
ALTER TABLE `premios`
  ADD PRIMARY KEY (`id_premios`),
  ADD UNIQUE KEY `id_premios_UNIQUE` (`id_premios`),
  ADD KEY `id_fraccionamientoclub_premios_idx` (`id_fraccionamientoclub`),
  ADD KEY `id_status_idx` (`id_status`);

--
-- Indices de la tabla `programacion_partidos`
--
ALTER TABLE `programacion_partidos`
  ADD PRIMARY KEY (`id_programacion`),
  ADD UNIQUE KEY `partido_unico` (`id_torneo`,`id_partido`,`categoria_id`,`subcategoria_id`),
  ADD KEY `idx_torneo` (`id_torneo`),
  ADD KEY `idx_fecha_hora` (`fecha`,`hora`),
  ADD KEY `idx_cancha` (`id_cancha`);

--
-- Indices de la tabla `programacion_partidos_padel`
--
ALTER TABLE `programacion_partidos_padel`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_partido` (`id_torneo`,`id_partido`);

--
-- Indices de la tabla `promotores`
--
ALTER TABLE `promotores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_promotores_usuarios` (`id_usuario`);

--
-- Indices de la tabla `pts_jugador_club`
--
ALTER TABLE `pts_jugador_club`
  ADD PRIMARY KEY (`id_pts_jugador_club`),
  ADD KEY `id_jugador_idx` (`id_jugador`),
  ADD KEY `id_fraccionamientoclub_idx` (`id_fraccionamientoclub`);

--
-- Indices de la tabla `publicidad`
--
ALTER TABLE `publicidad`
  ADD PRIMARY KEY (`id_publicidad`),
  ADD KEY `id_status_idx` (`id_status`);

--
-- Indices de la tabla `ranking`
--
ALTER TABLE `ranking`
  ADD PRIMARY KEY (`ranking`),
  ADD KEY `id_jugador_ranking_idx` (`id_jugador`);

--
-- Indices de la tabla `ranking_historial`
--
ALTER TABLE `ranking_historial`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`,`ran_posicion_actual`);

--
-- Indices de la tabla `recuperarContrasena`
--
ALTER TABLE `recuperarContrasena`
  ADD PRIMARY KEY (`idRC`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id_reserva`),
  ADD KEY `id_fraccionamientoclub_idx` (`id_fraccionamientoclub`),
  ADD KEY `id_usuario_idx` (`id_coach`),
  ADD KEY `id_cancha_idx` (`id_cancha`),
  ADD KEY `id_status_idx` (`id_status`);

--
-- Indices de la tabla `reservas_participantes`
--
ALTER TABLE `reservas_participantes`
  ADD PRIMARY KEY (`id_participante`),
  ADD KEY `fk_id_reserva_reservas` (`id_reserva`),
  ADD KEY `fk_id_usuario_usuarios` (`id_usuario`),
  ADD KEY `fk_id_club_usuarios_fraccionamientoClubUsuarios` (`id_club_usuario`);

--
-- Indices de la tabla `reservas_recurrentes`
--
ALTER TABLE `reservas_recurrentes`
  ADD PRIMARY KEY (`id_recurrencia`),
  ADD KEY `id_cancha` (`id_cancha`),
  ADD KEY `idx_recurrencia` (`id_recurrencia`),
  ADD KEY `idx_reserva_padre` (`id_reserva_padre`);

--
-- Indices de la tabla `reserva_historial`
--
ALTER TABLE `reserva_historial`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `fk_id_reservah` (`id_reserva`),
  ADD KEY `fk_id_usuariosh` (`id_usuario`);

--
-- Indices de la tabla `resultados_partidos_padel`
--
ALTER TABLE `resultados_partidos_padel`
  ADD PRIMARY KEY (`id_resultado`),
  ADD UNIQUE KEY `partido_unico` (`id_torneo`,`id_partido`,`categoria_id`,`subcategoria_id`),
  ADD KEY `idx_torneo` (`id_torneo`);

--
-- Indices de la tabla `rondas_americana`
--
ALTER TABLE `rondas_americana`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rondas_Reta`
--
ALTER TABLE `rondas_Reta`
  ADD PRIMARY KEY (`id_ronda_reta`),
  ADD KEY `id_juego->juegos` (`id_juego`),
  ADD KEY `id_usuario1->usuarios` (`id_jugador1`),
  ADD KEY `id_usuario2->usuarios` (`id_jugador2`);

--
-- Indices de la tabla `sa_categorias_finazas`
--
ALTER TABLE `sa_categorias_finazas`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `sa_cortes_caja`
--
ALTER TABLE `sa_cortes_caja`
  ADD PRIMARY KEY (`id_corte`),
  ADD KEY `idx_sa_cortes_usuario` (`id_usuario`),
  ADD KEY `idx_sa_cortes_fechas` (`fecha_inicio`,`fecha_fin`);

--
-- Indices de la tabla `sa_cortes_caja_detalles`
--
ALTER TABLE `sa_cortes_caja_detalles`
  ADD PRIMARY KEY (`id_detalle_corte`),
  ADD KEY `idx_sa_cortes_detalle_corte` (`id_corte`);

--
-- Indices de la tabla `sa_cortes_caja_movimientos`
--
ALTER TABLE `sa_cortes_caja_movimientos`
  ADD PRIMARY KEY (`id_movimiento_corte`),
  ADD KEY `idx_sa_cortes_mov_corte` (`id_corte`),
  ADD KEY `idx_sa_cortes_mov_detalle` (`id_detalle_corte`);

--
-- Indices de la tabla `sa_egresos`
--
ALTER TABLE `sa_egresos`
  ADD PRIMARY KEY (`id_egreso`),
  ADD KEY `idx_sa_egresos_fecha` (`fecha`),
  ADD KEY `idx_sa_egresos_metodo` (`id_club_metodo_pago`),
  ADD KEY `idx_sa_egresos_categoria` (`id_categoria`),
  ADD KEY `idx_sa_egresos_corte` (`id_corte_caja`);

--
-- Indices de la tabla `sa_ingresos`
--
ALTER TABLE `sa_ingresos`
  ADD PRIMARY KEY (`id_ingreso`),
  ADD KEY `idx_sa_ingresos_fecha` (`fecha`),
  ADD KEY `idx_sa_ingresos_metodo` (`id_club_metodo_pago`),
  ADD KEY `idx_sa_ingresos_categoria` (`id_categoria`),
  ADD KEY `idx_sa_ingresos_corte` (`id_corte_caja`);

--
-- Indices de la tabla `sa_metodos_pago`
--
ALTER TABLE `sa_metodos_pago`
  ADD PRIMARY KEY (`id_metodo`);

--
-- Indices de la tabla `sa_metodo_pago`
--
ALTER TABLE `sa_metodo_pago`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_sa_metodo_pago` (`id_metodo`);

--
-- Indices de la tabla `secciones`
--
ALTER TABLE `secciones`
  ADD PRIMARY KEY (`id_seccion`),
  ADD KEY `id_modulo_idx` (`id_modulo`),
  ADD KEY `id_status_secciones_idx` (`id_status`);

--
-- Indices de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD KEY `id_fraccionamientoclub` (`id_fraccionamientoclub`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_status` (`id_status`);

--
-- Indices de la tabla `solicitudes_facturacion`
--
ALTER TABLE `solicitudes_facturacion`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD KEY `idx_solicitudes_facturacion_club` (`id_fraccionamientoclub`),
  ADD KEY `idx_solicitudes_facturacion_usuario` (`id_usuario`),
  ADD KEY `idx_solicitudes_facturacion_status` (`status`),
  ADD KEY `idx_solicitudes_facturacion_admin_visto` (`admin_visto`),
  ADD KEY `idx_solicitudes_facturacion_club_visto` (`club_visto`);

--
-- Indices de la tabla `soporte_categories`
--
ALTER TABLE `soporte_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `soporte_tickets`
--
ALTER TABLE `soporte_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_usuario` (`id_usuario`),
  ADD KEY `idx_assigned` (`assigned_to`),
  ADD KEY `idx_category` (`category_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_tickets_created` (`created_at`),
  ADD KEY `idx_tickets_user_status` (`id_usuario`,`status`);

--
-- Indices de la tabla `soporte_ticket_attachments`
--
ALTER TABLE `soporte_ticket_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket` (`ticket_id`);

--
-- Indices de la tabla `soporte_ticket_responses`
--
ALTER TABLE `soporte_ticket_responses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket` (`ticket_id`),
  ADD KEY `idx_usuario` (`id_usuario`),
  ADD KEY `idx_responses_created` (`created_at`);

--
-- Indices de la tabla `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id_status`);

--
-- Indices de la tabla `suscripciones`
--
ALTER TABLE `suscripciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_plan` (`id_plan`);

--
-- Indices de la tabla `tarifas`
--
ALTER TABLE `tarifas`
  ADD PRIMARY KEY (`id_tarifa`),
  ADD KEY `id_cancha_idx` (`id_canchas`),
  ADD KEY `fk_tarifas_horarios_club` (`id_horario_club`),
  ADD KEY `fk_tarifas_status` (`tipo`);

--
-- Indices de la tabla `tipos`
--
ALTER TABLE `tipos`
  ADD PRIMARY KEY (`id_tipo`);

--
-- Indices de la tabla `tipos_banners`
--
ALTER TABLE `tipos_banners`
  ADD PRIMARY KEY (`nombre`);

--
-- Indices de la tabla `tipo_organizacion`
--
ALTER TABLE `tipo_organizacion`
  ADD PRIMARY KEY (`id_tipo_organizacion`),
  ADD KEY `id_status` (`id_status`);

--
-- Indices de la tabla `torneos`
--
ALTER TABLE `torneos`
  ADD PRIMARY KEY (`id_torneos`),
  ADD KEY `id_modojuego_idx` (`id_modojuego`),
  ADD KEY `id_status_torneo_idx` (`id_status`),
  ADD KEY `fk_id_horario_club_torneos` (`id_cancha`),
  ADD KEY `fk_id_nivelJuego_torneos` (`id_nivelJuego`),
  ADD KEY `fk_id_horario_club_torneos2` (`id_horario_club`);

--
-- Indices de la tabla `torneos_localstorage`
--
ALTER TABLE `torneos_localstorage`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_key` (`storage_key`),
  ADD KEY `idx_torneo` (`id_torneo`),
  ADD KEY `idx_tipo` (`tipo_datos`);

--
-- Indices de la tabla `torneos_metodos_pago`
--
ALTER TABLE `torneos_metodos_pago`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_torneo` (`id_torneo`),
  ADD KEY `id_metodo` (`id_metodo`);

--
-- Indices de la tabla `torneo_jugador`
--
ALTER TABLE `torneo_jugador`
  ADD PRIMARY KEY (`id_torneo_jugador`),
  ADD KEY `id_jugador_toneo_idx` (`id_jugador`),
  ADD KEY `id_toneo_jugador_idx` (`id_torneo`),
  ADD KEY `id_pareja` (`id_pareja`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `id_metodopago` (`id_metodopago`);

--
-- Indices de la tabla `user_drafts`
--
ALTER TABLE `user_drafts`
  ADD PRIMARY KEY (`phone_number`),
  ADD KEY `idx_updated_at` (`updated_at`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `id_status_idx` (`id_status`),
  ADD KEY `id_perfil_usuario_idx` (`id_perfil`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Indices de la tabla `usuarios_promotores`
--
ALTER TABLE `usuarios_promotores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_codigo_promotor` (`codigo_promotor`),
  ADD KEY `idx_id_usuario` (`id_usuario`);

--
-- Indices de la tabla `usuarios_suscripciones`
--
ALTER TABLE `usuarios_suscripciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_categoria` (`id_usuario`,`categoria`),
  ADD KEY `idx_stripe_subscription` (`stripe_subscription_id`);

--
-- Indices de la tabla `usuario_premios`
--
ALTER TABLE `usuario_premios`
  ADD PRIMARY KEY (`id_usuario_premio`),
  ADD KEY `id_usuario_idx` (`id_usuario`),
  ADD KEY `id_premio_idx` (`id_premio`),
  ADD KEY `id_status_idx` (`id_status`),
  ADD KEY `fk_usuario_premios_fraccionamiento` (`id_fraccionamientoclub`);

--
-- Indices de la tabla `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `administrador`
--
ALTER TABLE `administrador`
  MODIFY `id_Administrador` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `banners`
--
ALTER TABLE `banners`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  MODIFY `id_calif` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cambios_grupos_torneo`
--
ALTER TABLE `cambios_grupos_torneo`
  MODIFY `id_cambio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cambios_grupo_padel`
--
ALTER TABLE `cambios_grupo_padel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `canchas`
--
ALTER TABLE `canchas`
  MODIFY `id_canchas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `canchasTorneo`
--
ALTER TABLE `canchasTorneo`
  MODIFY `idCanchasTorneo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `categoriasTorneo`
--
ALTER TABLE `categoriasTorneo`
  MODIFY `idCategoriasTorneo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias_finazas`
--
ALTER TABLE `categorias_finazas`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `club_metodo_pago`
--
ALTER TABLE `club_metodo_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `coaches`
--
ALTER TABLE `coaches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `coach_prices`
--
ALTER TABLE `coach_prices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `codigos_prueba`
--
ALTER TABLE `codigos_prueba`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cortes_caja`
--
ALTER TABLE `cortes_caja`
  MODIFY `id_corte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cortes_caja_detalles`
--
ALTER TABLE `cortes_caja_detalles`
  MODIFY `id_detalle_corte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cortes_caja_movimientos`
--
ALTER TABLE `cortes_caja_movimientos`
  MODIFY `id_relacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `direccion`
--
ALTER TABLE `direccion`
  MODIFY `id_direccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `directorio_clubes`
--
ALTER TABLE `directorio_clubes`
  MODIFY `id_directorio_club` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=528;

--
-- AUTO_INCREMENT de la tabla `egresos`
--
ALTER TABLE `egresos`
  MODIFY `id_egreso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `egresos_ingresos`
--
ALTER TABLE `egresos_ingresos`
  MODIFY `id_egresosIngresos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estados`
--
ALTER TABLE `estados`
  MODIFY `id_estados` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `estatus_planes`
--
ALTER TABLE `estatus_planes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `evento_categoria`
--
ALTER TABLE `evento_categoria`
  MODIFY `id_evento_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `faqs`
--
ALTER TABLE `faqs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `faq_categorias`
--
ALTER TABLE `faq_categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `fraccionamientoClub_usuarios`
--
ALTER TABLE `fraccionamientoClub_usuarios`
  MODIFY `id_club_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `fraccionamiento_club`
--
ALTER TABLE `fraccionamiento_club`
  MODIFY `id_fraccionamientoclub` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `horaDiaTorneo`
--
ALTER TABLE `horaDiaTorneo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `horarios_club`
--
ALTER TABLE `horarios_club`
  MODIFY `id_horario_club` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `imagen_club_fraccionamiento`
--
ALTER TABLE `imagen_club_fraccionamiento`
  MODIFY `id_imagen_club_fraccionamiento` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ingresos`
--
ALTER TABLE `ingresos`
  MODIFY `id_ingreso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `juegos`
--
ALTER TABLE `juegos`
  MODIFY `id_juego` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `juegos_prueba`
--
ALTER TABLE `juegos_prueba`
  MODIFY `id_juegosprueba` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `juego_confirmaciones_americana`
--
ALTER TABLE `juego_confirmaciones_americana`
  MODIFY `id_confirmacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT de la tabla `juego_confirmaciones_reta`
--
ALTER TABLE `juego_confirmaciones_reta`
  MODIFY `id_confirmacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `juego_jugadores`
--
ALTER TABLE `juego_jugadores`
  MODIFY `id_juego_jugadores` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT de la tabla `jugadaAmericana`
--
ALTER TABLE `jugadaAmericana`
  MODIFY `id_jugadaAmericana` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jugadaReta`
--
ALTER TABLE `jugadaReta`
  MODIFY `id_jugadaReta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jugadores`
--
ALTER TABLE `jugadores`
  MODIFY `id_jugador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  MODIFY `id_metodo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `modojuego`
--
ALTER TABLE `modojuego`
  MODIFY `id_modojuego` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `modulo`
--
ALTER TABLE `modulo`
  MODIFY `mod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `modulos_superadmin`
--
ALTER TABLE `modulos_superadmin`
  MODIFY `mod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `movimientos_pendientes`
--
ALTER TABLE `movimientos_pendientes`
  MODIFY `id_movimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `municipio`
--
ALTER TABLE `municipio`
  MODIFY `id_municipio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `niveljuego`
--
ALTER TABLE `niveljuego`
  MODIFY `id_nivelJuego` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `noticias`
--
ALTER TABLE `noticias`
  MODIFY `id_noticias` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones_enviadas`
--
ALTER TABLE `notificaciones_enviadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones_juegos`
--
ALTER TABLE `notificaciones_juegos`
  MODIFY `id_notificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones_reservas`
--
ALTER TABLE `notificaciones_reservas`
  MODIFY `id_notificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagos_reserva`
--
ALTER TABLE `pagos_reserva`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pais`
--
ALTER TABLE `pais`
  MODIFY `id_pais` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `perfil`
--
ALTER TABLE `perfil`
  MODIFY `id_perfil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `planes_suscripcion`
--
ALTER TABLE `planes_suscripcion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `precios_torneo`
--
ALTER TABLE `precios_torneo`
  MODIFY `id_precio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `premios`
--
ALTER TABLE `premios`
  MODIFY `id_premios` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de la tabla `programacion_partidos`
--
ALTER TABLE `programacion_partidos`
  MODIFY `id_programacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `programacion_partidos_padel`
--
ALTER TABLE `programacion_partidos_padel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `promotores`
--
ALTER TABLE `promotores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `pts_jugador_club`
--
ALTER TABLE `pts_jugador_club`
  MODIFY `id_pts_jugador_club` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `publicidad`
--
ALTER TABLE `publicidad`
  MODIFY `id_publicidad` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ranking`
--
ALTER TABLE `ranking`
  MODIFY `ranking` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ranking_historial`
--
ALTER TABLE `ranking_historial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recuperarContrasena`
--
ALTER TABLE `recuperarContrasena`
  MODIFY `idRC` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `reservas_participantes`
--
ALTER TABLE `reservas_participantes`
  MODIFY `id_participante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `reservas_recurrentes`
--
ALTER TABLE `reservas_recurrentes`
  MODIFY `id_recurrencia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reserva_historial`
--
ALTER TABLE `reserva_historial`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `resultados_partidos_padel`
--
ALTER TABLE `resultados_partidos_padel`
  MODIFY `id_resultado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rondas_americana`
--
ALTER TABLE `rondas_americana`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT de la tabla `rondas_Reta`
--
ALTER TABLE `rondas_Reta`
  MODIFY `id_ronda_reta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sa_categorias_finazas`
--
ALTER TABLE `sa_categorias_finazas`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `sa_cortes_caja`
--
ALTER TABLE `sa_cortes_caja`
  MODIFY `id_corte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `sa_cortes_caja_detalles`
--
ALTER TABLE `sa_cortes_caja_detalles`
  MODIFY `id_detalle_corte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `sa_cortes_caja_movimientos`
--
ALTER TABLE `sa_cortes_caja_movimientos`
  MODIFY `id_movimiento_corte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sa_egresos`
--
ALTER TABLE `sa_egresos`
  MODIFY `id_egreso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sa_ingresos`
--
ALTER TABLE `sa_ingresos`
  MODIFY `id_ingreso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `sa_metodos_pago`
--
ALTER TABLE `sa_metodos_pago`
  MODIFY `id_metodo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `sa_metodo_pago`
--
ALTER TABLE `sa_metodo_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `id_solicitud` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitudes_facturacion`
--
ALTER TABLE `solicitudes_facturacion`
  MODIFY `id_solicitud` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `soporte_categories`
--
ALTER TABLE `soporte_categories`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `soporte_tickets`
--
ALTER TABLE `soporte_tickets`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT de la tabla `soporte_ticket_attachments`
--
ALTER TABLE `soporte_ticket_attachments`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `soporte_ticket_responses`
--
ALTER TABLE `soporte_ticket_responses`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `status`
--
ALTER TABLE `status`
  MODIFY `id_status` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `suscripciones`
--
ALTER TABLE `suscripciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tarifas`
--
ALTER TABLE `tarifas`
  MODIFY `id_tarifa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1080;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipo_organizacion`
--
ALTER TABLE `tipo_organizacion`
  MODIFY `id_tipo_organizacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `torneos`
--
ALTER TABLE `torneos`
  MODIFY `id_torneos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `torneos_localstorage`
--
ALTER TABLE `torneos_localstorage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `torneos_metodos_pago`
--
ALTER TABLE `torneos_metodos_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `torneo_jugador`
--
ALTER TABLE `torneo_jugador`
  MODIFY `id_torneo_jugador` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1094;

--
-- AUTO_INCREMENT de la tabla `usuarios_promotores`
--
ALTER TABLE `usuarios_promotores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios_suscripciones`
--
ALTER TABLE `usuarios_suscripciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario_premios`
--
ALTER TABLE `usuario_premios`
  MODIFY `id_usuario_premio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT de la tabla `videos`
--
ALTER TABLE `videos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD CONSTRAINT `administrador_ibfk_1` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`),
  ADD CONSTRAINT `id_FraccinamientoClub` FOREIGN KEY (`id_franccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `banners`
--
ALTER TABLE `banners`
  ADD CONSTRAINT `fk_id_promotor` FOREIGN KEY (`id_promotor`) REFERENCES `promotores` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tipos_banners` FOREIGN KEY (`tipo`) REFERENCES `tipos_banners` (`nombre`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD CONSTRAINT `id_usuario_calificacion` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `cambios_grupos_torneo`
--
ALTER TABLE `cambios_grupos_torneo`
  ADD CONSTRAINT `fk_cambios_grupos_torneo` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneos`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `canchas`
--
ALTER TABLE `canchas`
  ADD CONSTRAINT `fk_id_fraccionamientoclub_canchas` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_status_canchas` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `canchasTorneo`
--
ALTER TABLE `canchasTorneo`
  ADD CONSTRAINT `canchasTorneo_ibfk_1` FOREIGN KEY (`idCancha`) REFERENCES `canchas` (`id_canchas`),
  ADD CONSTRAINT `canchasTorneo_ibfk_2` FOREIGN KEY (`idTorneo`) REFERENCES `torneos` (`id_torneos`);

--
-- Filtros para la tabla `categoriasTorneo`
--
ALTER TABLE `categoriasTorneo`
  ADD CONSTRAINT `categoriasTorneo_ibfk_1` FOREIGN KEY (`id_nivelJuego`) REFERENCES `niveljuego` (`id_nivelJuego`),
  ADD CONSTRAINT `categoriasTorneo_ibfk_2` FOREIGN KEY (`id_torneos`) REFERENCES `torneos` (`id_torneos`);

--
-- Filtros para la tabla `categorias_finazas`
--
ALTER TABLE `categorias_finazas`
  ADD CONSTRAINT `fk_categoria_club` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`);

--
-- Filtros para la tabla `club_metodo_pago`
--
ALTER TABLE `club_metodo_pago`
  ADD CONSTRAINT `club_metodo_pago_ibfk_1` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`),
  ADD CONSTRAINT `club_metodo_pago_ibfk_2` FOREIGN KEY (`id_metodo`) REFERENCES `metodos_pago` (`id_metodo`);

--
-- Filtros para la tabla `coaches`
--
ALTER TABLE `coaches`
  ADD CONSTRAINT `coaches_ibfk_1` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE CASCADE,
  ADD CONSTRAINT `coaches_ibfk_2` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE;

--
-- Filtros para la tabla `coach_prices`
--
ALTER TABLE `coach_prices`
  ADD CONSTRAINT `coach_prices_ibfk_1` FOREIGN KEY (`coach_id`) REFERENCES `coaches` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cortes_caja`
--
ALTER TABLE `cortes_caja`
  ADD CONSTRAINT `fk_corte_club` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`),
  ADD CONSTRAINT `fk_corte_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `cortes_caja_detalles`
--
ALTER TABLE `cortes_caja_detalles`
  ADD CONSTRAINT `fk_corte_detalle` FOREIGN KEY (`id_corte`) REFERENCES `cortes_caja` (`id_corte`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cortes_caja_movimientos`
--
ALTER TABLE `cortes_caja_movimientos`
  ADD CONSTRAINT `fk_corte_movimiento` FOREIGN KEY (`id_corte`) REFERENCES `cortes_caja` (`id_corte`) ON DELETE CASCADE;

--
-- Filtros para la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD CONSTRAINT `fk_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_status_direccion` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `egresos`
--
ALTER TABLE `egresos`
  ADD CONSTRAINT `egresos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_finazas` (`id_categoria`),
  ADD CONSTRAINT `egresos_ibfk_2` FOREIGN KEY (`id_club_metodo_pago`) REFERENCES `club_metodo_pago` (`id`),
  ADD CONSTRAINT `fk_egreso_club` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`);

--
-- Filtros para la tabla `egresos_ingresos`
--
ALTER TABLE `egresos_ingresos`
  ADD CONSTRAINT `id_fraccionamientoclubEgresos` FOREIGN KEY (`id_fraccionamientoClub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_usuario_egresos` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `estados`
--
ALTER TABLE `estados`
  ADD CONSTRAINT `id_pais` FOREIGN KEY (`id_pais`) REFERENCES `pais` (`id_pais`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `evento_categoria`
--
ALTER TABLE `evento_categoria`
  ADD CONSTRAINT `evento_categoria_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_finazas` (`id_categoria`);

--
-- Filtros para la tabla `fraccionamientoClub_usuarios`
--
ALTER TABLE `fraccionamientoClub_usuarios`
  ADD CONSTRAINT `fraccionamientoClub_usuarios_ibfk_1` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE CASCADE,
  ADD CONSTRAINT `fraccionamientoClub_usuarios_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `fraccionamientoClub_usuarios_ibfk_3` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fraccionamientoClub_usuarios_ibfk_4` FOREIGN KEY (`cus_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `fraccionamiento_club`
--
ALTER TABLE `fraccionamiento_club`
  ADD CONSTRAINT `fk_estatus` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tipo_organizacion` FOREIGN KEY (`tipo`) REFERENCES `tipo_organizacion` (`id_tipo_organizacion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_direccion` FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `horaDiaTorneo`
--
ALTER TABLE `horaDiaTorneo`
  ADD CONSTRAINT `horaDiaTorneo_ibfk_1` FOREIGN KEY (`id_torneos`) REFERENCES `torneos` (`id_torneos`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `horarios_club`
--
ALTER TABLE `horarios_club`
  ADD CONSTRAINT `fk_id_fraccionamientoclub_horarios` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `imagen_club_fraccionamiento`
--
ALTER TABLE `imagen_club_fraccionamiento`
  ADD CONSTRAINT `imagen_club_fraccionamiento_ibfk_1` FOREIGN KEY (`id_club_fraccionamiento`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`);

--
-- Filtros para la tabla `ingresos`
--
ALTER TABLE `ingresos`
  ADD CONSTRAINT `fk_ingreso_club` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`),
  ADD CONSTRAINT `ingresos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_finazas` (`id_categoria`),
  ADD CONSTRAINT `ingresos_ibfk_2` FOREIGN KEY (`id_pago_reserva`) REFERENCES `pagos_reserva` (`id`),
  ADD CONSTRAINT `ingresos_ibfk_3` FOREIGN KEY (`id_club_metodo_pago`) REFERENCES `club_metodo_pago` (`id`);

--
-- Filtros para la tabla `juegos`
--
ALTER TABLE `juegos`
  ADD CONSTRAINT `fk_id_direccion` FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`),
  ADD CONSTRAINT `fk_id_fraccionamientoclub` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_id_reserva` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_usuario_juego` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_cancha_juego` FOREIGN KEY (`id_cancha`) REFERENCES `canchas` (`id_canchas`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_modojuego_juego` FOREIGN KEY (`id_modojuego`) REFERENCES `modojuego` (`id_modojuego`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_tipo_juego` FOREIGN KEY (`id_tipo`) REFERENCES `tipos` (`id_tipo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_torneo_juego` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneos`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `juegos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`);

--
-- Filtros para la tabla `juegos_prueba`
--
ALTER TABLE `juegos_prueba`
  ADD CONSTRAINT `id_jugador_prueba` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id_jugador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_modojuego_pruebas` FOREIGN KEY (`id_modojuego`) REFERENCES `modojuego` (`id_modojuego`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `juego_canchas`
--
ALTER TABLE `juego_canchas`
  ADD CONSTRAINT `juego_canchas_ibfk_1` FOREIGN KEY (`id_juego`) REFERENCES `juegos` (`id_juego`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `juego_canchas_ibfk_2` FOREIGN KEY (`id_cancha`) REFERENCES `canchas` (`id_canchas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `juego_jugadores`
--
ALTER TABLE `juego_jugadores`
  ADD CONSTRAINT `fk_id_status` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_juego_jugador` FOREIGN KEY (`id_juego`) REFERENCES `juegos` (`id_juego`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_jugador_juego` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id_jugador`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `jugadaAmericana`
--
ALTER TABLE `jugadaAmericana`
  ADD CONSTRAINT `jugadaAmericana_ibfk_1` FOREIGN KEY (`id_jugador1`) REFERENCES `jugadores` (`id_jugador`),
  ADD CONSTRAINT `jugadaAmericana_ibfk_2` FOREIGN KEY (`id_jugador2`) REFERENCES `jugadores` (`id_jugador`),
  ADD CONSTRAINT `jugadaAmericana_ibfk_3` FOREIGN KEY (`id_juego`) REFERENCES `juegos` (`id_juego`);

--
-- Filtros para la tabla `jugadaReta`
--
ALTER TABLE `jugadaReta`
  ADD CONSTRAINT `jugadaReta_ibfk_1` FOREIGN KEY (`id_jugador1`) REFERENCES `jugadores` (`id_jugador`),
  ADD CONSTRAINT `jugadaReta_ibfk_2` FOREIGN KEY (`id_jugador2`) REFERENCES `jugadores` (`id_jugador`),
  ADD CONSTRAINT `jugadaReta_ibfk_3` FOREIGN KEY (`id_juego`) REFERENCES `juegos` (`id_juego`);

--
-- Filtros para la tabla `jugadores`
--
ALTER TABLE `jugadores`
  ADD CONSTRAINT `id_status_jugadores` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_usuario_jugador` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `jugadores_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`);

--
-- Filtros para la tabla `menu_asociados`
--
ALTER TABLE `menu_asociados`
  ADD CONSTRAINT `fk_permiso_modulo` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_permiso_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_permiso_seccion` FOREIGN KEY (`id_seccion`) REFERENCES `secciones` (`id_seccion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `modojuego`
--
ALTER TABLE `modojuego`
  ADD CONSTRAINT `id_status_modojuego` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `modulos`
--
ALTER TABLE `modulos`
  ADD CONSTRAINT `id_perfil_modulo` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_status_modulo` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `movimientos_pendientes`
--
ALTER TABLE `movimientos_pendientes`
  ADD CONSTRAINT `fk_movimiento_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_finazas` (`id_categoria`),
  ADD CONSTRAINT `fk_movimiento_club` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`),
  ADD CONSTRAINT `movimientos_pendientes_ibfk_1` FOREIGN KEY (`id_club_metodo_pago`) REFERENCES `club_metodo_pago` (`id`);

--
-- Filtros para la tabla `municipio`
--
ALTER TABLE `municipio`
  ADD CONSTRAINT `id_estado` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estados`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `noticias`
--
ALTER TABLE `noticias`
  ADD CONSTRAINT `noticias_ibfk_1` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`),
  ADD CONSTRAINT `noticias_ibfk_2` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`),
  ADD CONSTRAINT `noticias_ibfk_3` FOREIGN KEY (`id_tipo`) REFERENCES `tipos` (`id_tipo`);

--
-- Filtros para la tabla `notificaciones_juegos`
--
ALTER TABLE `notificaciones_juegos`
  ADD CONSTRAINT `notificaciones_juegos_ibfk_1` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id_jugador`) ON DELETE CASCADE,
  ADD CONSTRAINT `notificaciones_juegos_ibfk_2` FOREIGN KEY (`id_juego`) REFERENCES `juegos` (`id_juego`) ON DELETE CASCADE;

--
-- Filtros para la tabla `notificaciones_reservas`
--
ALTER TABLE `notificaciones_reservas`
  ADD CONSTRAINT `fk_notificacion_reserva` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_notificacion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pagos_reserva`
--
ALTER TABLE `pagos_reserva`
  ADD CONSTRAINT `pagos_reserva_ibfk_1` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`),
  ADD CONSTRAINT `pagos_reserva_ibfk_2` FOREIGN KEY (`id_participante`) REFERENCES `reservas_participantes` (`id_participante`);

--
-- Filtros para la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD CONSTRAINT `id_status` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `perfil_modulo`
--
ALTER TABLE `perfil_modulo`
  ADD CONSTRAINT `perfil_modulo_ibfk_1` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `perfil_modulo_ibfk_2` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `permisos_admin_rol`
--
ALTER TABLE `permisos_admin_rol`
  ADD CONSTRAINT `fk_id_perfil_super` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mod_id_supers` FOREIGN KEY (`mod_id`) REFERENCES `modulos_superadmin` (`mod_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `permisos_admin_usuario`
--
ALTER TABLE `permisos_admin_usuario`
  ADD CONSTRAINT `fk_id_usuarios_super` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mod_id_Super` FOREIGN KEY (`mod_id`) REFERENCES `modulos_superadmin` (`mod_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `permisos_rol`
--
ALTER TABLE `permisos_rol`
  ADD CONSTRAINT `permisos_rol_ibfk_1` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisos_rol_ibfk_2` FOREIGN KEY (`mod_id`) REFERENCES `modulo` (`mod_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `permisos_usuario`
--
ALTER TABLE `permisos_usuario`
  ADD CONSTRAINT `permisos_usuario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisos_usuario_ibfk_2` FOREIGN KEY (`mod_id`) REFERENCES `modulo` (`mod_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `precios_torneo`
--
ALTER TABLE `precios_torneo`
  ADD CONSTRAINT `fk_id_torneo_precio` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneos`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `premios`
--
ALTER TABLE `premios`
  ADD CONSTRAINT `id_fraccionamientoclub_premios` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_status_premios` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `programacion_partidos`
--
ALTER TABLE `programacion_partidos`
  ADD CONSTRAINT `fk_programacion_cancha` FOREIGN KEY (`id_cancha`) REFERENCES `canchas` (`id_canchas`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_programacion_torneo` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneos`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `promotores`
--
ALTER TABLE `promotores`
  ADD CONSTRAINT `fk_promotores_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pts_jugador_club`
--
ALTER TABLE `pts_jugador_club`
  ADD CONSTRAINT `fk_id_fraccionamientoclub_pts` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_jugador_pts` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id_jugador`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `publicidad`
--
ALTER TABLE `publicidad`
  ADD CONSTRAINT `id_status_banners` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ranking`
--
ALTER TABLE `ranking`
  ADD CONSTRAINT `id_jugador_ranking` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id_jugador`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `fk_reserva_cancha` FOREIGN KEY (`id_cancha`) REFERENCES `canchas` (`id_canchas`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reserva_coach` FOREIGN KEY (`id_coach`) REFERENCES `coaches` (`id`),
  ADD CONSTRAINT `fk_reserva_fraccionamientoclub` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reserva_status` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `reservas_participantes`
--
ALTER TABLE `reservas_participantes`
  ADD CONSTRAINT `fk_id_club_usuarios_fraccionamientoClubUsuarios` FOREIGN KEY (`id_club_usuario`) REFERENCES `fraccionamientoClub_usuarios` (`id_club_usuario`),
  ADD CONSTRAINT `fk_id_reserva_reservas` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`),
  ADD CONSTRAINT `fk_id_usuario_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `reservas_recurrentes`
--
ALTER TABLE `reservas_recurrentes`
  ADD CONSTRAINT `reservas_recurrentes_ibfk_1` FOREIGN KEY (`id_reserva_padre`) REFERENCES `reservas` (`id_reserva`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservas_recurrentes_ibfk_2` FOREIGN KEY (`id_cancha`) REFERENCES `canchas` (`id_canchas`);

--
-- Filtros para la tabla `reserva_historial`
--
ALTER TABLE `reserva_historial`
  ADD CONSTRAINT `fk_id_reservah` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_id_usuariosh` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `resultados_partidos_padel`
--
ALTER TABLE `resultados_partidos_padel`
  ADD CONSTRAINT `fk_resultados_torneo` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneos`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `rondas_Reta`
--
ALTER TABLE `rondas_Reta`
  ADD CONSTRAINT `id_juego->juegos` FOREIGN KEY (`id_juego`) REFERENCES `juegos` (`id_juego`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_usuario1->usuarios` FOREIGN KEY (`id_jugador1`) REFERENCES `jugadores` (`id_jugador`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_usuario2->usuarios` FOREIGN KEY (`id_jugador2`) REFERENCES `jugadores` (`id_jugador`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `secciones`
--
ALTER TABLE `secciones`
  ADD CONSTRAINT `id_modulo` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_status_secciones` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `solicitudes_ibfk_1` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`),
  ADD CONSTRAINT `solicitudes_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `solicitudes_ibfk_3` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`);

--
-- Filtros para la tabla `soporte_ticket_attachments`
--
ALTER TABLE `soporte_ticket_attachments`
  ADD CONSTRAINT `fk_attachment_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `soporte_tickets` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `soporte_ticket_responses`
--
ALTER TABLE `soporte_ticket_responses`
  ADD CONSTRAINT `fk_response_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `soporte_tickets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_response_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `suscripciones`
--
ALTER TABLE `suscripciones`
  ADD CONSTRAINT `suscripciones_ibfk_1` FOREIGN KEY (`id_plan`) REFERENCES `planes_suscripcion` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tarifas`
--
ALTER TABLE `tarifas`
  ADD CONSTRAINT `fk_tarifa_porcancha` FOREIGN KEY (`id_canchas`) REFERENCES `canchas` (`id_canchas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tarifas_horarios_club` FOREIGN KEY (`id_horario_club`) REFERENCES `horarios_club` (`id_horario_club`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tarifas_status` FOREIGN KEY (`tipo`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tipo_organizacion`
--
ALTER TABLE `tipo_organizacion`
  ADD CONSTRAINT `tipo_organizacion_ibfk_1` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`);

--
-- Filtros para la tabla `torneos`
--
ALTER TABLE `torneos`
  ADD CONSTRAINT `fk_id_cancha_torneos` FOREIGN KEY (`id_cancha`) REFERENCES `canchas` (`id_canchas`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_id_horario_club_torneos2` FOREIGN KEY (`id_horario_club`) REFERENCES `horarios_club` (`id_horario_club`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_id_nivelJuego_torneos` FOREIGN KEY (`id_nivelJuego`) REFERENCES `niveljuego` (`id_nivelJuego`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_modojuego` FOREIGN KEY (`id_modojuego`) REFERENCES `modojuego` (`id_modojuego`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_status_torneo` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `torneos_metodos_pago`
--
ALTER TABLE `torneos_metodos_pago`
  ADD CONSTRAINT `torneos_metodos_pago_ibfk_1` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneos`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `torneos_metodos_pago_ibfk_2` FOREIGN KEY (`id_metodo`) REFERENCES `metodos_pago` (`id_metodo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `torneo_jugador`
--
ALTER TABLE `torneo_jugador`
  ADD CONSTRAINT `id_jugador_toneo` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id_jugador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_toneo_jugador` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneos`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `torneo_jugador_ibfk_2` FOREIGN KEY (`id_pareja`) REFERENCES `jugadores` (`id_jugador`),
  ADD CONSTRAINT `torneo_jugador_ibfk_3` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  ADD CONSTRAINT `torneo_jugador_ibfk_4` FOREIGN KEY (`id_metodopago`) REFERENCES `metodos_pago` (`id_metodo`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `id_perfil_usuario` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_status_usuario` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`);

--
-- Filtros para la tabla `usuarios_promotores`
--
ALTER TABLE `usuarios_promotores`
  ADD CONSTRAINT `usuarios_promotores_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuarios_suscripciones`
--
ALTER TABLE `usuarios_suscripciones`
  ADD CONSTRAINT `fk_usuarios_suscripciones_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `usuario_premios`
--
ALTER TABLE `usuario_premios`
  ADD CONSTRAINT `fk_usuario_premios_fraccionamiento` FOREIGN KEY (`id_fraccionamientoclub`) REFERENCES `fraccionamiento_club` (`id_fraccionamientoclub`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuario_premios_premios` FOREIGN KEY (`id_premio`) REFERENCES `premios` (`id_premios`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuario_premios_status` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuario_premios_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
