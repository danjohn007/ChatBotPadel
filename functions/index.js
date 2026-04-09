// =========================================================
// 📱 ChatBot – Chatbot de WhatsApp (versión mínima: responde "Hola")
// Node.js 22 con ESM y Firebase Functions
// =========================================================

// Importación de módulos principales
import { onRequest } from "firebase-functions/v2/https"; // Define una función HTTPS en Firebase
import * as logger from "firebase-functions/logger";      // Para registrar logs (info, error, etc.)
import { defineSecret } from "firebase-functions/params"; // Permite usar variables secretas seguras
import axios from "axios";                                // Cliente HTTP (para enviar mensajes a WhatsApp)
import mysql from "mysql2/promise";                       // Cliente MySQL para conexión a BD
import Stripe from "stripe";                              // Stripe SDK para pagos

// =========================================================
// 🔐 SECRETS (valores sensibles, definidos en Firebase)
// =========================================================
// Cada uno corresponde a un valor almacenado en Firebase Secrets Manager.
// Así evitamos exponer contraseñas o tokens en el código.

const VERIFY_TOKEN = defineSecret("VERIFY_TOKEN_PADEL");// 080126
const WHATSAPP_TOKEN = defineSecret("WHATSAPP_TOKEN_PADEL");//      EAAWo4kbaxUUBQamz7cU7r4R5JTZACZBaDRMnfWALtCrI6352WepUPkubugp7lHOKZAM02PBTwtVWKeZBe448WDOZA3mjWHBtoRjZCq1ULkZAugf5IVb7ZBFtDzo0Vweem5qoSZBqbFnMTLf1huDG8ZAAarVMZCWfNfdOebNhZBN32GYoKi8jrBJ3foAjZCXSqg542xQdmeQZDZD
const WHATSAPP_PHONE_NUMBER_ID = defineSecret("WHATSAPP_PHONE_NUMBER_ID_PADEL"); //    959279237268322


// Configuración de conexión a base de datos MySQL
const DB_HOST = defineSecret("DB_HOST_PADEL");//           arosports.app
const DB_USER = defineSecret("DB_USER_PADEL");//           arosport_arosports
const DB_PASSWORD = defineSecret("DB_PASSWORD_PADEL");//   6F*HkXyk!udw
const DB_NAME = defineSecret("DB_NAME_PADEL");//           arosport_arosports

// Stripe
const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY_PADEL");
const STRIPE_WEBHOOK_SECRET = defineSecret("STRIPE_WEBHOOK_SECRET_PADEL");

// =========================================================
// 🗄️ CONEXIÓN A MYSQL (Pool Lazy)
// =========================================================
// Se crea un pool de conexiones reutilizable (lazy), lo que optimiza el rendimiento
// evitando reconexiones constantes cada vez que se procesa un mensaje.

let pool = null;
function getPool(cfg) {
  if (!pool) {
    pool = mysql.createPool({
      host: cfg.DB_HOST,
      user: cfg.DB_USER,
      password: cfg.DB_PASSWORD,
      database: cfg.DB_NAME,
      waitForConnections: true,
      connectionLimit: 5,
      queueLimit: 0,
      timezone: "Z", // UTC (evita desfases de hora)
    });
  }
  return pool;
}

// =========================================================
// 💬 FUNCIONES PARA ENVIAR MENSAJES POR WHATSAPP
// =========================================================

/**
 * Descarga una imagen de WhatsApp y la sube al servidor de ArosPorts
 * @param {string} imageId - ID de la imagen en WhatsApp
 * @param {string} token - Token de acceso de WhatsApp
 * @param {number} ticketId - ID del ticket para nombrar el archivo
 * @returns {Object|null} - Objeto con filepath, filesize y mimetype o null si falla
 */
async function downloadAndUploadWhatsAppImage(imageId, token, ticketId) {
  try {
    logger.info(`📥 Descargando imagen de WhatsApp: ${imageId}`);
    
    // 1. Obtener URL de la imagen desde WhatsApp
    const mediaUrlResponse = await axios.get(
      `https://graph.facebook.com/v20.0/${imageId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
        timeout: 15000,
      }
    );
    
    const mediaUrl = mediaUrlResponse.data.url;
    logger.info(`📍 URL de la imagen obtenida: ${mediaUrl}`);
    
    // 2. Descargar la imagen de WhatsApp
    const imageResponse = await axios.get(mediaUrl, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
      responseType: 'arraybuffer',
      timeout: 30000,
    });
    
    const imageBuffer = Buffer.from(imageResponse.data);
    const contentType = imageResponse.headers['content-type'] || 'image/jpeg';
    
    logger.info(`✅ Imagen descargada, tamaño: ${imageBuffer.length} bytes, tipo: ${contentType}`);
    
    // 3. Generar nombre único para el archivo
    const timestamp = Date.now().toString(36);
    const random = Math.random().toString(36).substring(2, 10);
    const extension = contentType.includes('png') ? 'png' : 'jpg';
    const filename = `${timestamp}_${random}_TK${ticketId}.${extension}`;
    
    logger.info(`📝 Nombre de archivo generado: ${filename}`);
    
    // 4. Subir la imagen al servidor de ArosPorts
    // Convertir el buffer a FormData para subirlo
    const FormData = (await import('form-data')).default;
    const formData = new FormData();
    
    // Importante: agregar el buffer como archivo con todas las opciones necesarias
    formData.append('file', imageBuffer, {
      filename: filename,
      contentType: contentType,
      knownLength: imageBuffer.length, // Especificar el tamaño del archivo
    });
    formData.append('ticket_id', ticketId.toString());
    
    logger.info(`📤 Subiendo imagen al servidor de ArosPorts...`);
    logger.info(`   - Nombre: ${filename}`);
    logger.info(`   - Tamaño: ${imageBuffer.length} bytes`);
    logger.info(`   - Tipo: ${contentType}`);
    logger.info(`   - Ticket ID: ${ticketId}`);
    
    // Llamar al endpoint de ArosPorts para subir el archivo
    const uploadResponse = await axios.post(
      'https://arosports.app/api/api/uploads/tickets/',
      formData,
      {
        headers: {
          ...formData.getHeaders(),
        },
        timeout: 30000,
        maxContentLength: Infinity,
        maxBodyLength: Infinity,
      }
    );
    
    logger.info(`📨 Respuesta del servidor:`, uploadResponse.data);
    
    if (uploadResponse.data && uploadResponse.data.filepath) {
      const filepath = uploadResponse.data.filepath;
      logger.info(`✅ Imagen subida exitosamente: ${filepath}`);
      
      // Retornar objeto completo con toda la información
      return {
        filepath: filepath,
        filename: uploadResponse.data.filename || filepath.split('/').pop(),
        filesize: uploadResponse.data.size || imageBuffer.length,
        mimetype: contentType,
      };
    } else if (uploadResponse.data && uploadResponse.data.success === false) {
      logger.error(`❌ Error del servidor: ${uploadResponse.data.error}`);
      return null;
    } else {
      logger.error(`❌ El servidor no devolvió una ruta válida:`, uploadResponse.data);
      return null;
    }
    
  } catch (error) {
    logger.error(`❌ Error al descargar/subir imagen de WhatsApp:`, error.message);
    if (error.response) {
      logger.error(`📡 Código de respuesta: ${error.response.status}`);
      logger.error(`📄 Respuesta del servidor:`, error.response.data);
      logger.error(`📋 Headers de respuesta:`, error.response.headers);
    }
    if (error.request) {
      logger.error(`📤 Request enviado pero sin respuesta`);
    }
    logger.error(`🔍 Detalles completos del error:`, error);
    return null;
  }
}

/**
 * Envía un mensaje de texto simple
 */
async function sendWhatsAppText({ to, text, token, phoneNumberId }) {
  const url = `https://graph.facebook.com/v20.0/${phoneNumberId}/messages`;
  await axios.post(
    url,
    {
      messaging_product: "whatsapp",
      to,
      type: "text",
      text: { body: text },
    },
    {
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      timeout: 15000,
    }
  );
}

/**
 * Envía una lista interactiva de WhatsApp
 */
async function sendWhatsAppList({ to, headerText, bodyText, buttonText, sections, token, phoneNumberId }) {
  const url = `https://graph.facebook.com/v20.0/${phoneNumberId}/messages`;
  
  // Construir el objeto interactive
  const interactive = {
    type: "list",
    body: {
      text: bodyText,
    },
    action: {
      button: buttonText,
      sections: sections,
    },
  };
  
  // Solo agregar header si existe
  if (headerText) {
    interactive.header = {
      type: "text",
      text: headerText,
    };
  }
  
  await axios.post(
    url,
    {
      messaging_product: "whatsapp",
      to,
      type: "interactive",
      interactive,
    },
    {
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      timeout: 15000,
    }
  );
}

/**
 * Envía botones interactivos de WhatsApp (máximo 3 botones)
 */
async function sendWhatsAppButtons({ to, bodyText, buttons, token, phoneNumberId }) {
  const url = `https://graph.facebook.com/v20.0/${phoneNumberId}/messages`;
  
  // Construir el objeto interactive
  const interactive = {
    type: "button",
    body: {
      text: bodyText,
    },
    action: {
      buttons: buttons,
    },
  };
  
  await axios.post(
    url,
    {
      messaging_product: "whatsapp",
      to,
      type: "interactive",
      interactive,
    },
    {
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      timeout: 15000,
    }
  );
}

// =========================================================
// 🗄️ FUNCIONES DE MANEJO DE DRAFTS (Estado del Usuario)
// =========================================================

/**
 * Obtiene el draft completo del usuario
 */
async function getDraft(pool, phoneNumber) {
  const [rows] = await pool.query(
    "SELECT draft FROM user_drafts WHERE phone_number = ?",
    [phoneNumber]
  );
  return rows.length > 0 ? rows[0].draft : null;
}

/**
 * Guarda o actualiza el draft completo del usuario
 */
async function saveDraft(pool, phoneNumber, draft) {
  await pool.query(
    `INSERT INTO user_drafts (phone_number, draft) 
     VALUES (?, ?) 
     ON DUPLICATE KEY UPDATE draft = ?, updated_at = CURRENT_TIMESTAMP`,
    [phoneNumber, JSON.stringify(draft), JSON.stringify(draft)]
  );
}

/**
 * Establece el flujo y paso actual del usuario
 */
async function setFlow(pool, phoneNumber, flow, step) {
  const draft = await getDraft(pool, phoneNumber);
  const updated = { ...(draft || {}), flow, step };
  await saveDraft(pool, phoneNumber, updated);
}

/**
 * Guarda un dato temporal en el draft
 */
async function saveDraftData(pool, phoneNumber, key, value) {
  const draft = await getDraft(pool, phoneNumber);
  const updated = {
    ...(draft || {}),
    data: { ...(draft?.data || {}), [key]: value },
  };
  await saveDraft(pool, phoneNumber, updated);
  logger.info(`Draft data guardado para ${phoneNumber}: ${key} = ${value?.substring ? value.substring(0, 50) + '...' : value}`);
}

/**
 * Obtiene un dato específico del draft
 */
async function getDraftData(pool, phoneNumber, key) {
  const draft = await getDraft(pool, phoneNumber);
  const value = draft?.data?.[key];
  logger.info(`Draft data recuperado para ${phoneNumber}: ${key} = ${value?.substring ? value.substring(0, 50) + '...' : value}`);
  return value;
}

/**
 * Limpia el flujo pero mantiene los datos del usuario
 */
async function clearFlow(pool, phoneNumber) {
  const draft = await getDraft(pool, phoneNumber);
  if (draft) {
    const updated = {
      flow: null,
      step: "menu",
      user: draft.user || null,
      data: {},
    };
    await saveDraft(pool, phoneNumber, updated);
  }
}

/**
 * Elimina completamente el draft del usuario
 */
async function clearDraft(pool, phoneNumber) {
  await pool.query("DELETE FROM user_drafts WHERE phone_number = ?", [phoneNumber]);
}

/**
 * Obtiene información del usuario desde la base de datos por número de teléfono
 */
async function getUserByPhone(pool, phoneNumber) {
  try {
    // WhatsApp envía el número en formato internacional (ej: 521234567890)
    // Intentamos varias estrategias de búsqueda:
    
    // 1. Búsqueda exacta
    let [rows] = await pool.query(
      "SELECT us_nombre, us_apellidop FROM usuarios WHERE us_telefono = ? LIMIT 1",
      [phoneNumber]
    );
    
    // 2. Si no encuentra, intenta sin código de país (últimos 10 dígitos)
    if (rows.length === 0 && phoneNumber.length > 10) {
      const localNumber = phoneNumber.slice(-10);
      [rows] = await pool.query(
        "SELECT us_nombre, us_apellidop FROM usuarios WHERE us_telefono LIKE ? LIMIT 1",
        [`%${localNumber}%`]
      );
    }
    
    // 3. Si no encuentra, busca por coincidencia parcial del número completo
    if (rows.length === 0) {
      [rows] = await pool.query(
        "SELECT us_nombre, us_apellidop FROM usuarios WHERE ? LIKE CONCAT('%', us_telefono, '%') AND us_telefono != '0' AND us_telefono != '2147483647' LIMIT 1",
        [phoneNumber]
      );
    }
    
    if (rows.length > 0 && rows[0].us_nombre) {
      return {
        nombre: rows[0].us_nombre,
        apellido: rows[0].us_apellidop
      };
    }
    return null;
  } catch (error) {
    logger.error("Error al obtener usuario:", error);
    return null;
  }
}

/**
 * Verifica si el usuario tiene una suscripción activa (id_estatus = 1)
 * @param {object} pool - Conexión a la base de datos
 * @param {number} userId - ID del usuario
 * @returns {boolean} - true si tiene suscripción activa, false en caso contrario
 */
async function tieneUsuarioSuscripcionActiva(pool, userId) {
  try {
    const [rows] = await pool.query(
      `SELECT id FROM suscripciones 
       WHERE id_usuario = ? 
       AND id_estatus = 1 
       AND fecha_fin > NOW() 
       ORDER BY fecha_fin DESC 
       LIMIT 1`,
      [userId]
    );
    return rows.length > 0;
  } catch (error) {
    logger.error("Error al verificar suscripción:", error);
    return false;
  }
}

/**
 * Obtiene información COMPLETA del usuario desde la base de datos por número de teléfono
 * Usa la misma lógica de búsqueda que getUserByPhone pero devuelve todos los campos necesarios
 */
async function getFullUserByPhone(pool, phoneNumber) {
  try {
    logger.info(`🔍 Buscando usuario completo para teléfono: ${phoneNumber}`);
    
    // WhatsApp envía el número en formato internacional (ej: 521234567890)
    // Intentamos varias estrategias de búsqueda:
    
    // 1. Búsqueda exacta
    let [rows] = await pool.query(
      "SELECT id_usuario, us_nombre, us_apellidop, us_correo, us_telefono, id_perfil FROM usuarios WHERE us_telefono = ? LIMIT 1",
      [phoneNumber]
    );
    logger.info(`Búsqueda exacta: ${rows.length} resultados`);
    
    // 2. Si no encuentra, intenta sin código de país (últimos 10 dígitos)
    if (rows.length === 0 && phoneNumber.length > 10) {
      const localNumber = phoneNumber.slice(-10);
      logger.info(`Intentando con últimos 10 dígitos: ${localNumber}`);
      [rows] = await pool.query(
        "SELECT id_usuario, us_nombre, us_apellidop, us_correo, us_telefono, id_perfil FROM usuarios WHERE us_telefono LIKE ? LIMIT 1",
        [`%${localNumber}%`]
      );
      logger.info(`Búsqueda con últimos 10 dígitos: ${rows.length} resultados`);
    }
    
    // 3. Si no encuentra, busca por coincidencia parcial del número completo
    if (rows.length === 0) {
      logger.info(`Intentando búsqueda por coincidencia parcial`);
      [rows] = await pool.query(
        "SELECT id_usuario, us_nombre, us_apellidop, us_correo, us_telefono, id_perfil FROM usuarios WHERE ? LIKE CONCAT('%', us_telefono, '%') AND us_telefono != '0' AND us_telefono != '2147483647' LIMIT 1",
        [phoneNumber]
      );
      logger.info(`Búsqueda por coincidencia parcial: ${rows.length} resultados`);
    }
    
    if (rows.length > 0 && rows[0].us_nombre) {
      logger.info(`✅ Usuario encontrado: ${rows[0].us_nombre} ${rows[0].us_apellidop} (ID: ${rows[0].id_usuario})`);
      return {
        id_usuario: rows[0].id_usuario,
        nombre: rows[0].us_nombre,
        apellido: rows[0].us_apellidop,
        correo: rows[0].us_correo,
        telefono: rows[0].us_telefono,
        id_perfil: rows[0].id_perfil
      };
    }
    
    logger.warn(`❌ No se encontró usuario con teléfono: ${phoneNumber}`);
    return null;
  } catch (error) {
    logger.error("Error al obtener usuario completo:", error);
    return null;
  }
}

// =========================================================
// 🎯 FLUJOS DEL CHATBOT
// =========================================================

/**
 * Menú principal del chatbot con botones interactivos
 * @param {string} userName - Nombre del usuario (opcional)
 * @param {boolean} tieneSuscripcionActiva - Si el usuario tiene suscripción activa
 */
function menuPrincipal(userName = null, tieneSuscripcionActiva = false) {
  const saludo = userName 
    ? `Hola ${userName}, bienvenido a ArosPorts` 
    : `Bienvenido a ArosPorts`;
  
  // Si NO tiene suscripción activa, solo mostrar opción de soporte
  if (!tieneSuscripcionActiva) {
    return {
      type: "button",
      bodyText: `${saludo}\n\n⚠️ *Tu suscripción no está activa*\n\nPara acceder a todas las funciones, necesitas una suscripción activa.\n\n¿En qué puedo ayudarte hoy?`,
      buttons: [
        {
          type: "reply",
          reply: {
            id: "opcion_5",
            title: "🆘 Soporte técnico",
          },
        },
      ],
    };
  }
  
  // Menú principal con 3 opciones (suscripción activa)
  return {
    type: "button",
    bodyText: `${saludo}\n\n¿En qué puedo ayudarte hoy?`,
    buttons: [
      {
        type: "reply",
        reply: {
          id: "opcion_1",
          title: "🎾 Reservar cancha",
        },
      },
      {
        type: "reply",
        reply: {
          id: "opcion_2",
          title: "📍 Buscar club",
        },
      },
      {
        type: "reply",
        reply: {
          id: "opcion_5",
          title: "🆘 Soporte técnico",
        },
      },
    ],
  };
}

/**
 * Texto para volver al menú principal
 */
function textoVolverMenu() {
  return "\n\n_Escribe 'Hola' o 'Cancelar' para volver al menú principal._";
}

/**
 * Genera los slots de horario disponibles para una cancha, fecha y día de la semana.
 * Reutilizado por el paso de seleccionar club (para filtrar) y por seleccionar horario.
 */
async function generarSlotsDisponibles(pool, canchaId, fecha, diaSemana) {
  // Obtener tarifas para esta cancha y día de la semana
  const [tarifas] = await pool.query(
    `SELECT id_tarifa, precio, intervalo, horario_inicio, horario_fin, dia, moneda
     FROM tarifas
     WHERE id_canchas = ? AND dia = ?
     ORDER BY horario_inicio, intervalo`,
    [canchaId, diaSemana]
  );

  if (tarifas.length === 0) return [];

  // Obtener reservas existentes para esa cancha y fecha
  const [reservasExistentes] = await pool.query(
    `SELECT hora_inicio, hora_fin FROM reservas
     WHERE id_cancha = ? AND fecha = ? AND id_status = 1`,
    [canchaId, fecha]
  );

  // Generar slots desde las tarifas
  const allSlots = [];
  const ahoraMx = new Date(new Date().toLocaleString("en-US", { timeZone: "America/Mexico_City" }));
  const horaActual = ahoraMx.getHours();
  const esHoy = fecha === `${ahoraMx.getFullYear()}-${String(ahoraMx.getMonth() + 1).padStart(2, "0")}-${String(ahoraMx.getDate()).padStart(2, "0")}`;

  for (const tarifa of tarifas) {
    const hiStr = String(tarifa.horario_inicio);
    const hfStr = String(tarifa.horario_fin);
    const intStr = String(tarifa.intervalo);
    const hInicio = parseInt(hiStr.split(":")[0]) || 0;
    const hFin = parseInt(hfStr.split(":")[0]) || 0;
    const intervaloHoras = parseInt(intStr.split(":")[0]) || 1;

    if (intervaloHoras <= 0 || hFin <= hInicio) continue;

    for (let h = hInicio; h + intervaloHoras <= hFin; h += intervaloHoras) {
      if (esHoy && h <= horaActual) continue;

      const slotInicio = `${String(h).padStart(2, "0")}:00`;
      const slotFin = `${String(h + intervaloHoras).padStart(2, "0")}:00`;

      const estaReservado = reservasExistentes.some((r) => {
        const rInicio = String(r.hora_inicio).substring(0, 5);
        const rFin = String(r.hora_fin).substring(0, 5);
        return slotInicio < rFin && slotFin > rInicio;
      });

      if (!estaReservado) {
        allSlots.push({
          inicio: slotInicio,
          fin: slotFin,
          duracion: intervaloHoras,
          precio: parseFloat(tarifa.precio),
          moneda: tarifa.moneda || "MXN",
          id_tarifa: tarifa.id_tarifa,
        });
      }
    }
  }

  // Eliminar duplicados (mismo inicio-fin)
  const slotsUnicos = [];
  const vistos = new Set();
  for (const slot of allSlots) {
    const key = `${slot.inicio}-${slot.fin}`;
    if (!vistos.has(key)) {
      vistos.add(key);
      slotsUnicos.push(slot);
    }
  }

  return slotsUnicos;
}

/**
 * Limita un array de slots a máximo MAX filas para WhatsApp,
 * distribuyendo equitativamente entre duraciones.
 */
function limitarSlotsParaWhatsApp(slotsUnicos, max = 10) {
  if (slotsUnicos.length <= max) return slotsUnicos;

  const porDur = {};
  for (const s of slotsUnicos) {
    if (!porDur[s.duracion]) porDur[s.duracion] = [];
    porDur[s.duracion].push(s);
  }
  const durs = Object.keys(porDur).sort((a, b) => a - b);
  const cuota = Math.floor(max / durs.length);
  let extra = max - cuota * durs.length;
  const resultado = [];
  for (const dur of durs) {
    const grupo = porDur[dur];
    const n = Math.min(grupo.length, cuota + (extra > 0 ? 1 : 0));
    if (extra > 0) extra--;
    const step = grupo.length / n;
    for (let i = 0; i < n; i++) {
      resultado.push(grupo[Math.min(Math.floor(i * step), grupo.length - 1)]);
    }
  }
  return resultado;
}

/**
 * Flujo 1: Reservar Cancha
 * Orden: Estado → Fecha → Clubs con disponibilidad → Cancha + Horarios → Confirmar
 */
async function handleFlujoReservas(pool, phoneNumber, userInput, currentStep, draft, token, phoneNumberId) {
  // ─── PASO 1: Mostrar estados disponibles ───
  if (currentStep === "inicio") {
    const [estados] = await pool.query(
      `SELECT DISTINCT dc.estado
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       INNER JOIN directorio_clubes dc ON dc.nombre = fc.fc_nombre
       WHERE fc.id_status = 1 AND dc.estado IS NOT NULL AND dc.estado != ''
       ORDER BY dc.estado
       LIMIT 10`
    );

    if (estados.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: "No hay estados disponibles en este momento." + textoVolverMenu(),
      };
    }

    await setFlow(pool, phoneNumber, "reservas", "seleccionar_estado");

    const rows = estados.map((e, idx) => ({
      id: `estado_${idx}`,
      title: e.estado || "Sin nombre",
      description: `Clubs en ${e.estado}`,
    }));

    return {
      type: "list",
      headerText: "Estados Disponibles",
      bodyText: "Selecciona el estado donde quieres jugar:",
      buttonText: "Ver estados",
      sections: [{ title: "Selecciona tu estado", rows }],
    };
  }

  // ─── PASO 2: Capturar estado → mostrar fechas (próximos 7 días) ───
  if (currentStep === "seleccionar_estado") {
    const [estados] = await pool.query(
      `SELECT DISTINCT dc.estado
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       INNER JOIN directorio_clubes dc ON dc.nombre = fc.fc_nombre
       WHERE fc.id_status = 1 AND dc.estado IS NOT NULL AND dc.estado != ''
       ORDER BY dc.estado
       LIMIT 10`
    );

    let estadoSeleccionado = null;
    if (userInput.startsWith("estado_")) {
      const index = parseInt(userInput.split("_")[1]);
      if (index >= 0 && index < estados.length) {
        estadoSeleccionado = estados[index].estado;
      }
    }

    if (!estadoSeleccionado) {
      return { type: "text", text: "Selección inválida. Por favor selecciona un estado de la lista." };
    }

    await saveDraftData(pool, phoneNumber, "estado", estadoSeleccionado);

    // Generar próximos 7 días (hora de México)
    const diasSemana = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"];
    const fechas = [];
    for (let i = 0; i < 7; i++) {
      const ahora = new Date(new Date().toLocaleString("en-US", { timeZone: "America/Mexico_City" }));
      ahora.setDate(ahora.getDate() + i);
      const año = ahora.getFullYear();
      const mes = String(ahora.getMonth() + 1).padStart(2, "0");
      const dia = String(ahora.getDate()).padStart(2, "0");
      const fechaStr = `${año}-${mes}-${dia}`;
      const diaNombre = diasSemana[ahora.getDay()];
      const label = i === 0 ? `Hoy (${diaNombre} ${dia}/${mes})` : i === 1 ? `Mañana (${diaNombre} ${dia}/${mes})` : `${diaNombre} ${dia}/${mes}`;
      fechas.push({ fecha: fechaStr, dia: diaNombre, label });
    }

    await saveDraftData(pool, phoneNumber, "fechas_disponibles", fechas);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_fecha");

    const rows = fechas.map((f, idx) => ({
      id: `fecha_${idx}`,
      title: f.label.substring(0, 24),
      description: f.fecha,
    }));

    return {
      type: "list",
      headerText: "Seleccionar Fecha",
      bodyText: `📍 *${estadoSeleccionado}*\n\nSelecciona la fecha para tu reserva:`,
      buttonText: "Ver fechas",
      sections: [{ title: "Próximos días", rows }],
    };
  }

  // ─── PASO 3: Capturar fecha → buscar clubs con disponibilidad ese día ───
  if (currentStep === "seleccionar_fecha") {
    const fechas = await getDraftData(pool, phoneNumber, "fechas_disponibles");
    let fechaSeleccionada = null;

    if (userInput.startsWith("fecha_")) {
      const index = parseInt(userInput.split("_")[1]);
      if (index >= 0 && index < fechas.length) {
        fechaSeleccionada = fechas[index];
      }
    }

    if (!fechaSeleccionada) {
      return { type: "text", text: "Selección inválida. Por favor selecciona una fecha de la lista." };
    }

    await saveDraftData(pool, phoneNumber, "fecha", fechaSeleccionada.fecha);
    await saveDraftData(pool, phoneNumber, "fecha_label", fechaSeleccionada.label);
    await saveDraftData(pool, phoneNumber, "dia_semana", fechaSeleccionada.dia);

    const estadoSeleccionado = await getDraftData(pool, phoneNumber, "estado");

    // Buscar clubs del estado que tengan al menos una cancha con tarifas para ese día
    const [clubs] = await pool.query(
      `SELECT DISTINCT fc.id_fraccionamientoclub AS id_club, fc.fc_nombre AS nombre, dc.direccion AS colonia
       FROM fraccionamiento_club fc
       INNER JOIN directorio_clubes dc ON dc.nombre = fc.fc_nombre
       INNER JOIN canchas c ON c.id_fraccionamientoclub = fc.id_fraccionamientoclub AND c.id_status = 1
       INNER JOIN tarifas t ON t.id_canchas = c.id_canchas AND t.dia = ?
       WHERE dc.estado LIKE ? AND fc.id_status = 1
       ORDER BY fc.fc_nombre
       LIMIT 10`,
      [fechaSeleccionada.dia, `%${estadoSeleccionado}%`]
    );

    if (clubs.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `No encontré clubs con disponibilidad para *${fechaSeleccionada.label}* en *${estadoSeleccionado}*.` + textoVolverMenu(),
      };
    }

    await saveDraftData(pool, phoneNumber, "clubs_disponibles", clubs);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_club");

    const rows = clubs.map((club, idx) => ({
      id: `club_${idx}`,
      title: club.nombre.substring(0, 24),
      description: club.colonia ? club.colonia.substring(0, 72) : "Club de pádel",
    }));

    return {
      type: "list",
      headerText: `Clubs disponibles`,
      bodyText: `📍 *${estadoSeleccionado}* - 📅 *${fechaSeleccionada.label}*\n\nEstos clubs tienen canchas disponibles:`,
      buttonText: "Ver clubs",
      sections: [{ title: "Clubs disponibles", rows }],
    };
  }

  // ─── PASO 3b: Fecha con club preseleccionado (viene desde info_club) ───
  if (currentStep === "seleccionar_fecha_preclub") {
    const fechas = await getDraftData(pool, phoneNumber, "fechas_disponibles");
    let fechaSeleccionada = null;

    if (userInput.startsWith("fecha_")) {
      const index = parseInt(userInput.split("_")[1]);
      if (index >= 0 && index < fechas.length) {
        fechaSeleccionada = fechas[index];
      }
    }

    if (!fechaSeleccionada) {
      return { type: "text", text: "Selección inválida. Por favor selecciona una fecha de la lista." };
    }

    await saveDraftData(pool, phoneNumber, "fecha", fechaSeleccionada.fecha);
    await saveDraftData(pool, phoneNumber, "fecha_label", fechaSeleccionada.label);
    await saveDraftData(pool, phoneNumber, "dia_semana", fechaSeleccionada.dia);

    // Club ya está guardado, ir directo a mostrar canchas
    const clubId = await getDraftData(pool, phoneNumber, "club_id");
    const clubNombre = await getDraftData(pool, phoneNumber, "club_nombre");

    return await handleFlujoReservas(pool, phoneNumber, `club_preseleccionado_${clubId}`, "seleccionar_club", draft, token, phoneNumberId);
  }

  // ─── PASO 4: Capturar club → mostrar canchas con horarios disponibles ───
  if (currentStep === "seleccionar_club") {
    let clubSeleccionado = null;

    // Verificar si viene con club preseleccionado desde info_club
    if (userInput.startsWith("club_preseleccionado_")) {
      const clubId = parseInt(userInput.split("_")[2]);
      const clubNombre = await getDraftData(pool, phoneNumber, "club_nombre");
      clubSeleccionado = { id_club: clubId, nombre: clubNombre };
    } else {
      const clubs = await getDraftData(pool, phoneNumber, "clubs_disponibles");
      if (userInput.startsWith("club_")) {
        const index = parseInt(userInput.split("_")[1]);
        if (index >= 0 && index < clubs.length) {
          clubSeleccionado = clubs[index];
        }
      }

      if (!clubSeleccionado) {
        return { type: "text", text: "Selección inválida. Por favor selecciona un club de la lista." };
      }
    }

    await saveDraftData(pool, phoneNumber, "club_id", clubSeleccionado.id_club);
    await saveDraftData(pool, phoneNumber, "club_nombre", clubSeleccionado.nombre);

    const fecha = await getDraftData(pool, phoneNumber, "fecha");
    const diaSemana = await getDraftData(pool, phoneNumber, "dia_semana");

    // Obtener canchas activas del club
    const [canchasRaw] = await pool.query(
      `SELECT id_canchas, can_nombre, can_deporte, can_tipo
       FROM canchas
       WHERE id_fraccionamientoclub = ? AND id_status = 1
       ORDER BY can_nombre
       LIMIT 10`,
      [clubSeleccionado.id_club]
    );

    // Filtrar solo canchas que tienen slots disponibles para esa fecha
    const canchasConDisponibilidad = [];
    for (const cancha of canchasRaw) {
      const slots = await generarSlotsDisponibles(pool, cancha.id_canchas, fecha, diaSemana);
      if (slots.length > 0) {
        canchasConDisponibilidad.push({ ...cancha, totalSlots: slots.length });
      }
    }

    if (canchasConDisponibilidad.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `No hay canchas con horarios disponibles en *${clubSeleccionado.nombre}* para esa fecha.` + textoVolverMenu(),
      };
    }

    await saveDraftData(pool, phoneNumber, "canchas_disponibles", canchasConDisponibilidad);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_cancha");

    const fechaLabel = await getDraftData(pool, phoneNumber, "fecha_label");
    const rows = canchasConDisponibilidad.map((cancha, idx) => {
      const deporte = cancha.can_deporte || "Padel";
      const tipo = cancha.can_tipo || "";
      const desc = tipo ? `${deporte} - ${tipo} (${cancha.totalSlots} horarios)` : `${deporte} (${cancha.totalSlots} horarios)`;
      return {
        id: `cancha_${idx}`,
        title: (cancha.can_nombre || `Cancha ${idx + 1}`).substring(0, 24),
        description: desc.substring(0, 72),
      };
    });

    return {
      type: "list",
      headerText: "Canchas Disponibles",
      bodyText: `🏟️ *${clubSeleccionado.nombre}*\n📅 *${fechaLabel}*\n\nSelecciona una cancha:`,
      buttonText: "Ver canchas",
      sections: [{ title: "Canchas", rows }],
    };
  }

  // ─── PASO 5: Capturar cancha → mostrar horarios disponibles con precios ───
  if (currentStep === "seleccionar_cancha") {
    const canchas = await getDraftData(pool, phoneNumber, "canchas_disponibles");
    let canchaSeleccionada = null;

    if (userInput.startsWith("cancha_")) {
      const index = parseInt(userInput.split("_")[1]);
      if (index >= 0 && index < canchas.length) {
        canchaSeleccionada = canchas[index];
      }
    }

    if (!canchaSeleccionada) {
      return { type: "text", text: "Selección inválida. Por favor selecciona una cancha de la lista." };
    }

    await saveDraftData(pool, phoneNumber, "cancha_id", canchaSeleccionada.id_canchas);
    await saveDraftData(pool, phoneNumber, "cancha_nombre", canchaSeleccionada.can_nombre);

    const fecha = await getDraftData(pool, phoneNumber, "fecha");
    const diaSemana = await getDraftData(pool, phoneNumber, "dia_semana");

    // Generar slots disponibles (re-calcula en tiempo real)
    const slotsUnicos = await generarSlotsDisponibles(pool, canchaSeleccionada.id_canchas, fecha, diaSemana);

    if (slotsUnicos.length === 0) {
      await clearFlow(pool, phoneNumber);
      const fechaLabel = await getDraftData(pool, phoneNumber, "fecha_label");
      return {
        type: "text",
        text: `No hay horarios disponibles para *${fechaLabel}* en esta cancha. Todos los horarios están ocupados.` + textoVolverMenu(),
      };
    }

    await saveDraftData(pool, phoneNumber, "slots_disponibles", slotsUnicos);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_horario");

    // Limitar a 10 filas para WhatsApp
    const slotsParaMostrar = limitarSlotsParaWhatsApp(slotsUnicos);

    // Agrupar por duración
    const porDuracion = {};
    for (const slot of slotsParaMostrar) {
      if (!porDuracion[slot.duracion]) porDuracion[slot.duracion] = [];
      porDuracion[slot.duracion].push(slot);
    }

    const sections = [];
    const crearFilas = (slots) =>
      slots.map((slot) => ({
        id: `slot_${slotsUnicos.indexOf(slot)}`,
        title: `${slot.inicio} - ${slot.fin}`,
        description: `${slot.duracion}hr - $${slot.precio} ${slot.moneda}`,
      }));

    for (const dur of Object.keys(porDuracion).sort((a, b) => a - b)) {
      const grupo = porDuracion[dur];
      const titulo = `${dur} Hora${dur > 1 ? "s" : ""}`;
      sections.push({ title: titulo, rows: crearFilas(grupo) });
    }

    if (sections.length === 0) {
      sections.push({ title: "Horarios", rows: crearFilas(slotsParaMostrar) });
    }

    const canchaNombre = canchaSeleccionada.can_nombre;
    const fechaLabel = await getDraftData(pool, phoneNumber, "fecha_label");

    const totalRows = sections.reduce((sum, s) => sum + s.rows.length, 0);
    logger.info(`Horarios list: ${slotsUnicos.length} slots totales, mostrando ${totalRows} en ${sections.length} secciones`);

    return {
      type: "list",
      headerText: "Horarios Disponibles",
      bodyText: `*${canchaNombre}* - *${fechaLabel}*\n\nSelecciona un horario:`,
      buttonText: "Ver horarios",
      sections,
    };
  }

  // ─── PASO 6: Capturar horario → mostrar confirmación ───
  if (currentStep === "seleccionar_horario") {
    const slots = await getDraftData(pool, phoneNumber, "slots_disponibles");
    let slotSeleccionado = null;

    if (userInput.startsWith("slot_")) {
      const index = parseInt(userInput.split("_")[1]);
      if (index >= 0 && index < slots.length) {
        slotSeleccionado = slots[index];
      }
    }

    if (!slotSeleccionado) {
      return { type: "text", text: "Selección inválida. Por favor selecciona un horario de la lista." };
    }

    await saveDraftData(pool, phoneNumber, "slot_seleccionado", slotSeleccionado);
    await setFlow(pool, phoneNumber, "reservas", "confirmar_reserva");

    const estado = await getDraftData(pool, phoneNumber, "estado");
    const clubNombre = await getDraftData(pool, phoneNumber, "club_nombre");
    const canchaNombre = await getDraftData(pool, phoneNumber, "cancha_nombre");
    const fechaLabel = await getDraftData(pool, phoneNumber, "fecha_label");

    return {
      type: "button",
      bodyText: `🎾 *Resumen de tu reserva*\n\n📍 *Estado:* ${estado}\n🏟️ *Club:* ${clubNombre}\n🎾 *Cancha:* ${canchaNombre}\n📅 *Fecha:* ${fechaLabel}\n⏰ *Horario:* ${slotSeleccionado.inicio} - ${slotSeleccionado.fin}\n⌛ *Duración:* ${slotSeleccionado.duracion} hora${slotSeleccionado.duracion > 1 ? "s" : ""}\n💰 *Precio total:* $${slotSeleccionado.precio} ${slotSeleccionado.moneda}\n\n¿Confirmas tu reserva?`,
      buttons: [
        { type: "reply", reply: { id: "confirmar_si", title: "✅ Confirmar" } },
        { type: "reply", reply: { id: "confirmar_no", title: "❌ Cancelar" } },
      ],
    };
  }

  // ─── PASO 7: Confirmar → elegir tipo de pago ───
  if (currentStep === "confirmar_reserva") {
    if (userInput === "confirmar_no") {
      await clearFlow(pool, phoneNumber);
      return { type: "text", text: "❌ Reserva cancelada." + textoVolverMenu() };
    }

    if (userInput === "confirmar_si") {
      const slot = await getDraftData(pool, phoneNumber, "slot_seleccionado");
      const precioParcial = Math.ceil(slot.precio / 4);

      await setFlow(pool, phoneNumber, "reservas", "seleccionar_tipo_pago");

      return {
        type: "button",
        bodyText: `💳 *¿Cómo deseas pagar?*\n\n💰 *Pago completo:* $${slot.precio} ${slot.moneda}\n_Paga el total ahora._\n\n💵 *Pago parcial:* $${precioParcial} ${slot.moneda}\n_Paga el 25% ahora y el resto en el club._`,
        buttons: [
          { type: "reply", reply: { id: "pago_completo", title: "💰 Pago completo" } },
          { type: "reply", reply: { id: "pago_parcial", title: "💵 Pago parcial (25%)" } },
        ],
      };
    }

    return { type: "text", text: "Por favor selecciona *Confirmar* o *Cancelar*." };
  }

  // ─── PASO 8: Tipo de pago → crear Stripe Checkout ───
  if (currentStep === "seleccionar_tipo_pago") {
    if (userInput !== "pago_completo" && userInput !== "pago_parcial") {
      return { type: "text", text: "Por favor selecciona *Pago completo* o *Pago parcial*." };
    }

    const esParcial = userInput === "pago_parcial";
    await saveDraftData(pool, phoneNumber, "tipo_pago", esParcial ? "parcial" : "completo");

    if (userInput === "confirmar_si") {
      // This branch shouldn't be reached, but kept for safety
    }

    {
      const clubId = await getDraftData(pool, phoneNumber, "club_id");
      const canchaId = await getDraftData(pool, phoneNumber, "cancha_id");
      const fecha = await getDraftData(pool, phoneNumber, "fecha");
      const slot = await getDraftData(pool, phoneNumber, "slot_seleccionado");
      const clubNombre = await getDraftData(pool, phoneNumber, "club_nombre");
      const canchaNombre = await getDraftData(pool, phoneNumber, "cancha_nombre");
      const fechaLabel = await getDraftData(pool, phoneNumber, "fecha_label");

      // Verificar una última vez que el horario sigue disponible
      const [conflicto] = await pool.query(
        `SELECT id_reserva FROM reservas
         WHERE id_cancha = ? AND fecha = ? AND id_status = 1
         AND hora_inicio < ? AND hora_fin > ?
         LIMIT 1`,
        [canchaId, fecha, slot.fin + ":00", slot.inicio + ":00"]
      );

      if (conflicto.length > 0) {
        await clearFlow(pool, phoneNumber);
        return {
          type: "text",
          text: "⚠️ Lo sentimos, ese horario acaba de ser reservado por alguien más. Por favor intenta de nuevo." + textoVolverMenu(),
        };
      }

      // Obtener la cuenta conectada de Stripe del club
      const [clubRows] = await pool.query(
        `SELECT stripe_account_id FROM fraccionamiento_club WHERE id_fraccionamientoclub = ?`,
        [clubId]
      );
      const stripeAccountId = clubRows[0]?.stripe_account_id;

      if (!stripeAccountId) {
        await clearFlow(pool, phoneNumber);
        return {
          type: "text",
          text: "⚠️ Este club aún no tiene pagos en línea habilitados. Por favor contacta al club directamente para reservar." + textoVolverMenu(),
        };
      }

      // Crear Stripe Checkout Session
      const stripe = new Stripe(STRIPE_SECRET_KEY.value().trim());
      const moneda = (slot.moneda || "MXN").toLowerCase();
      const precioTotal = slot.precio;
      const precioParcial = Math.ceil(precioTotal / 4);
      const montoCobrar = esParcial ? precioParcial : precioTotal;
      const precioEnCentavos = Math.round(montoCobrar * 100);
      const restanteEnClub = esParcial ? precioTotal - precioParcial : 0;

      const descripcionProducto = esParcial
        ? `${fechaLabel} | ${slot.inicio} - ${slot.fin} (${slot.duracion}hr) — Pago parcial 25%`
        : `${fechaLabel} | ${slot.inicio} - ${slot.fin} (${slot.duracion}hr)`;

      const session = await stripe.checkout.sessions.create({
        mode: "payment",
        line_items: [
          {
            price_data: {
              currency: moneda,
              product_data: {
                name: `Reserva: ${canchaNombre}`,
                description: descripcionProducto,
              },
              unit_amount: precioEnCentavos,
            },
            quantity: 1,
          },
        ],
        payment_intent_data: {
          application_fee_amount: 2000, // $20 MXN comisión plataforma
          transfer_data: {
            destination: stripeAccountId,
          },
        },
        metadata: {
          phoneNumber,
          clubId: String(clubId),
          canchaId: String(canchaId),
          fecha,
          slotInicio: slot.inicio,
          slotFin: slot.fin,
          slotDuracion: String(slot.duracion),
          slotPrecio: String(precioTotal),
          slotMoneda: slot.moneda,
          clubNombre,
          canchaNombre,
          fechaLabel,
          tipoPago: esParcial ? "parcial" : "completo",
          montoPagado: String(montoCobrar),
          montoRestante: String(restanteEnClub),
        },
        success_url: "https://soportetecnico-8f595.web.app/pago-exitoso",
        cancel_url: "https://soportetecnico-8f595.web.app/pago-cancelado",
      });

      await clearFlow(pool, phoneNumber);

      const textoPago = esParcial
        ? `💳 *Pago Parcial de Reserva (25%)*\n\n🏟️ *Club:* ${clubNombre}\n🎾 *Cancha:* ${canchaNombre}\n📅 *Fecha:* ${fechaLabel}\n⏰ *Horario:* ${slot.inicio} - ${slot.fin}\n💰 *Precio total:* $${precioTotal} ${slot.moneda}\n💵 *Pagas ahora:* $${montoCobrar} ${slot.moneda}\n🏦 *Pagas en el club:* $${restanteEnClub} ${slot.moneda}\n\n👉 Haz clic en el siguiente enlace para pagar:\n${session.url}\n\n⏱️ El enlace expira en 30 minutos.\n_Tu reserva se confirmará automáticamente al completar el pago._`
        : `💳 *Pago Completo de Reserva*\n\n🏟️ *Club:* ${clubNombre}\n🎾 *Cancha:* ${canchaNombre}\n📅 *Fecha:* ${fechaLabel}\n⏰ *Horario:* ${slot.inicio} - ${slot.fin}\n💰 *Total:* $${precioTotal} ${slot.moneda}\n\n👉 Haz clic en el siguiente enlace para pagar:\n${session.url}\n\n⏱️ El enlace expira en 30 minutos.\n_Tu reserva se confirmará automáticamente al completar el pago._`;

      return { type: "text", text: textoPago };
    }
  }
}

/**
 * Flujo 2: Buscar Clubs (Menú → Texto / Estado / Ubicación)
 */
async function handleFlujoBuscarClubs(pool, phoneNumber, userInput, currentStep, draft) {
  // PASO 0: Mostrar menú de opciones de búsqueda
  if (currentStep === "inicio") {
    await setFlow(pool, phoneNumber, "buscar_clubs", "menu_busqueda");
    return {
      type: "button",
      headerText: "📍 Buscar Clubs",
      bodyText: "¿Cómo quieres buscar clubs?\n\n🔍 *Buscar por nombre* - Escribe el nombre del club, ciudad o estado\n📋 *Navegar por estado* - Explora la lista completa\n📍 *Enviar ubicación* - Encuentra clubs cerca de ti",
      buttons: [
        { type: "reply", reply: { id: "buscar_texto", title: "🔍 Buscar por nombre" } },
        { type: "reply", reply: { id: "buscar_estado", title: "📋 Por estado" } },
        { type: "reply", reply: { id: "buscar_ubicacion", title: "📍 Mi ubicación" } },
      ],
    };
  }

  // MENÚ: Procesar selección del tipo de búsqueda
  if (currentStep === "menu_busqueda") {
    if (userInput === "buscar_texto") {
      await setFlow(pool, phoneNumber, "buscar_clubs", "escribir_busqueda");
      return {
        type: "text",
        text: "🔍 *Buscar club*\n\nEscribe el nombre del club, ciudad o estado que buscas.\n\n_Ejemplo: \"Querétaro\", \"Padel Courts\", \"Jalisco\"_",
      };
    }
    if (userInput === "buscar_estado") {
      await setFlow(pool, phoneNumber, "buscar_clubs", "listar_estados");
      return await handleFlujoBuscarClubs(pool, phoneNumber, userInput, "listar_estados", draft);
    }
    if (userInput === "buscar_ubicacion") {
      await setFlow(pool, phoneNumber, "buscar_clubs", "esperar_ubicacion");
      return {
        type: "text",
        text: "📍 *Enviar ubicación*\n\nEnvía tu ubicación actual para encontrar clubs cerca de ti.\n\n_Toca el clip 📎 → Ubicación → Enviar ubicación actual_",
      };
    }
    // Si no reconoce la opción, volver a mostrar menú
    await setFlow(pool, phoneNumber, "buscar_clubs", "inicio");
    return await handleFlujoBuscarClubs(pool, phoneNumber, userInput, "inicio", draft);
  }

  // BÚSQUEDA POR TEXTO: Usuario escribe término de búsqueda
  if (currentStep === "escribir_busqueda") {
    const termino = userInput.trim();
    if (termino.length < 2) {
      return {
        type: "text",
        text: "❌ Escribe al menos 2 caracteres para buscar.",
      };
    }

    const busqueda = `%${termino}%`;
    const [clubs] = await pool.query(
      `SELECT nombre, direccion, telefonos, ciudad, estado 
       FROM directorio_clubes 
       WHERE nombre LIKE ? OR ciudad LIKE ? OR estado LIKE ?
       ORDER BY estado ASC, ciudad ASC, nombre ASC
       LIMIT 15`,
      [busqueda, busqueda, busqueda]
    );

    await clearFlow(pool, phoneNumber);

    if (clubs.length === 0) {
      return {
        type: "text",
        text: `❌ No encontré clubs con *"${termino}"*.\n\nIntenta con otro nombre, ciudad o estado.${textoVolverMenu()}`,
      };
    }

    let text = `🔍 *Resultados para "${termino}"*\n\n`;
    text += `Encontré *${clubs.length}* club${clubs.length > 1 ? 's' : ''}${clubs.length === 15 ? ' (mostrando los primeros 15)' : ''}:\n\n`;

    clubs.forEach((club, idx) => {
      text += `${idx + 1}️⃣ *${club.nombre}*\n`;
      text += `   📍 ${club.ciudad}, ${club.estado}\n`;
      if (club.direccion) {
        text += `   🏠 ${club.direccion}\n`;
      }
      if (club.telefonos) {
        try {
          const telefonos = JSON.parse(club.telefonos);
          if (telefonos.length > 0) {
            text += `   📞 ${telefonos.join(', ')}\n`;
          }
        } catch (e) {}
      }
      text += `\n`;
    });

    text += textoVolverMenu();
    return { type: "text", text };
  }

  // BÚSQUEDA POR UBICACIÓN: Procesada desde el webhook cuando llega un msg tipo location
  if (currentStep === "esperar_ubicacion") {
    // Si el usuario envió texto en vez de ubicación
    return {
      type: "text",
      text: "📍 Por favor envía tu *ubicación actual*, no texto.\n\n_Toca el clip 📎 → Ubicación → Enviar ubicación actual_",
    };
  }

  // RESULTADO DE UBICACIÓN: Mostrar clubs encontrados por cercanía
  if (currentStep === "resultado_ubicacion") {
    // Este paso se llama directamente desde el webhook con userInput = estado encontrado
    const estadoCercano = await getDraftData(pool, phoneNumber, "estado_ubicacion");
    const ciudadCercana = await getDraftData(pool, phoneNumber, "ciudad_ubicacion");

    let clubs;
    if (ciudadCercana) {
      [clubs] = await pool.query(
        `SELECT nombre, direccion, telefonos, ciudad, estado 
         FROM directorio_clubes 
         WHERE ciudad = ?
         ORDER BY nombre ASC
         LIMIT 15`,
        [ciudadCercana]
      );
    }

    if (!clubs || clubs.length === 0) {
      [clubs] = await pool.query(
        `SELECT nombre, direccion, telefonos, ciudad, estado 
         FROM directorio_clubes 
         WHERE estado = ?
         ORDER BY ciudad ASC, nombre ASC
         LIMIT 15`,
        [estadoCercano]
      );
    }

    await clearFlow(pool, phoneNumber);

    if (!clubs || clubs.length === 0) {
      return {
        type: "text",
        text: `❌ No encontré clubs cerca de tu ubicación.\n\nIntenta buscar por nombre o navegar por estado.${textoVolverMenu()}`,
      };
    }

    let text = `📍 *Clubs cerca de ti*\n`;
    text += ciudadCercana ? `_${ciudadCercana}, ${estadoCercano}_\n\n` : `_${estadoCercano}_\n\n`;
    text += `Encontré *${clubs.length}* club${clubs.length > 1 ? 's' : ''}:\n\n`;

    clubs.forEach((club, idx) => {
      text += `${idx + 1}️⃣ *${club.nombre}*\n`;
      text += `   📍 ${club.ciudad}, ${club.estado}\n`;
      if (club.direccion) {
        text += `   🏠 ${club.direccion}\n`;
      }
      if (club.telefonos) {
        try {
          const telefonos = JSON.parse(club.telefonos);
          if (telefonos.length > 0) {
            text += `   📞 ${telefonos.join(', ')}\n`;
          }
        } catch (e) {}
      }
      text += `\n`;
    });

    text += textoVolverMenu();
    return { type: "text", text };
  }

  // LISTAR ESTADOS con paginación
  if (currentStep === "listar_estados") {
    const offset = (await getDraftData(pool, phoneNumber, "estados_offset")) || 0;
    const limit = 9; // Máximo 9 + 1 para "Ver más" = 10 items (límite de WhatsApp)

    // Obtener estados únicos desde directorio_clubes
    const [estados] = await pool.query(
      `SELECT DISTINCT estado, COUNT(DISTINCT ciudad) as num_ciudades
       FROM directorio_clubes 
       WHERE estado IS NOT NULL AND estado != '' 
       GROUP BY estado
       ORDER BY estado ASC 
       LIMIT ? OFFSET ?`,
      [limit + 1, offset]
    );

    if (estados.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `❌ No hay estados disponibles en el directorio.${textoVolverMenu()}`,
      };
    }

    const hayMas = estados.length > limit;
    const estadosMostrar = estados.slice(0, limit);

    await saveDraftData(pool, phoneNumber, "estados_lista", estadosMostrar);
    await setFlow(pool, phoneNumber, "buscar_clubs", "seleccionar_estado");

    const rows = estadosMostrar.map((e, idx) => ({
      id: `estado_buscar_${idx}`,
      title: e.estado.substring(0, 24),
      description: `${e.num_ciudades} ciudad${e.num_ciudades > 1 ? 'es' : ''}`,
    }));

    if (hayMas) {
      rows.push({
        id: "ver_mas_estados",
        title: "Ver más estados",
        description: "Mostrar siguientes 9 estados",
      });
    }

    return {
      type: "list",
      headerText: "📍 Buscar Clubs",
      bodyText: `Selecciona el estado donde deseas buscar clubs:\n\n_Mostrando estados ${offset + 1}-${offset + estadosMostrar.length}_`,
      buttonText: "Ver estados",
      sections: [
        {
          title: "Estados Disponibles",
          rows: rows,
        },
      ],
    };
  }

  // PASO 2: Usuario selecciona estado → mostrar ciudades de ese estado
  if (currentStep === "seleccionar_estado") {
    if (userInput === "ver_mas_estados") {
      const offset = (await getDraftData(pool, phoneNumber, "estados_offset")) || 0;
      await saveDraftData(pool, phoneNumber, "estados_offset", offset + 9);
      await setFlow(pool, phoneNumber, "buscar_clubs", "listar_estados");
      return await handleFlujoBuscarClubs(pool, phoneNumber, userInput, "listar_estados", draft);
    }

    const estados = await getDraftData(pool, phoneNumber, "estados_lista");

    let estadoSeleccionado = null;
    if (userInput.startsWith("estado_buscar_")) {
      const index = parseInt(userInput.replace("estado_buscar_", ""));
      if (!isNaN(index) && estados && estados[index]) {
        estadoSeleccionado = estados[index].estado;
      }
    }

    if (!estadoSeleccionado) {
      return {
        type: "text",
        text: `❌ Opción inválida. Por favor selecciona un estado de la lista.`,
      };
    }

    await saveDraftData(pool, phoneNumber, "estado_seleccionado", estadoSeleccionado);

    // Obtener ciudades del estado seleccionado
    const offset = 0;
    await saveDraftData(pool, phoneNumber, "ciudades_offset", offset);
    const limit = 9;

    const [ciudades] = await pool.query(
      `SELECT DISTINCT ciudad, COUNT(*) as num_clubs
       FROM directorio_clubes 
       WHERE estado = ?
       GROUP BY ciudad
       ORDER BY ciudad ASC 
       LIMIT ? OFFSET ?`,
      [estadoSeleccionado, limit + 1, offset]
    );

    if (ciudades.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `❌ No hay ciudades disponibles en *${estadoSeleccionado}*.${textoVolverMenu()}`,
      };
    }

    const hayMas = ciudades.length > limit;
    const ciudadesMostrar = ciudades.slice(0, limit);

    await saveDraftData(pool, phoneNumber, "ciudades_lista", ciudadesMostrar);
    await setFlow(pool, phoneNumber, "buscar_clubs", "seleccionar_ciudad");

    const rows = ciudadesMostrar.map((c, idx) => ({
      id: `ciudad_buscar_${idx}`,
      title: c.ciudad.substring(0, 24),
      description: `${c.num_clubs} club${c.num_clubs > 1 ? 's' : ''}`,
    }));

    if (hayMas) {
      rows.push({
        id: "ver_mas_ciudades",
        title: "Ver más ciudades",
        description: "Mostrar siguientes 9 ciudades",
      });
    }

    return {
      type: "list",
      headerText: `📍 ${estadoSeleccionado}`,
      bodyText: `Selecciona la ciudad donde deseas buscar clubs:\n\n_Mostrando ciudades ${offset + 1}-${offset + ciudadesMostrar.length}_`,
      buttonText: "Ver ciudades",
      sections: [
        {
          title: "Ciudades Disponibles",
          rows: rows,
        },
      ],
    };
  }

  // PASO 3: Usuario selecciona ciudad → mostrar clubs
  if (currentStep === "seleccionar_ciudad") {
    if (userInput === "ver_mas_ciudades") {
      const offset = (await getDraftData(pool, phoneNumber, "ciudades_offset")) || 0;
      await saveDraftData(pool, phoneNumber, "ciudades_offset", offset + 9);

      const estadoSeleccionado = await getDraftData(pool, phoneNumber, "estado_seleccionado");
      const newOffset = offset + 9;
      const limit = 9;

      const [ciudades] = await pool.query(
        `SELECT DISTINCT ciudad, COUNT(*) as num_clubs
         FROM directorio_clubes 
         WHERE estado = ?
         GROUP BY ciudad
         ORDER BY ciudad ASC 
         LIMIT ? OFFSET ?`,
        [estadoSeleccionado, limit + 1, newOffset]
      );

      if (ciudades.length === 0) {
        return {
          type: "text",
          text: `❌ No hay más ciudades disponibles.${textoVolverMenu()}`,
        };
      }

      const hayMas = ciudades.length > limit;
      const ciudadesMostrar = ciudades.slice(0, limit);

      await saveDraftData(pool, phoneNumber, "ciudades_lista", ciudadesMostrar);
      await setFlow(pool, phoneNumber, "buscar_clubs", "seleccionar_ciudad");

      const rows = ciudadesMostrar.map((c, idx) => ({
        id: `ciudad_buscar_${idx}`,
        title: c.ciudad.substring(0, 24),
        description: `${c.num_clubs} club${c.num_clubs > 1 ? 's' : ''}`,
      }));

      if (hayMas) {
        rows.push({
          id: "ver_mas_ciudades",
          title: "Ver más ciudades",
          description: "Mostrar siguientes 9 ciudades",
        });
      }

      return {
        type: "list",
        headerText: `📍 ${estadoSeleccionado}`,
        bodyText: `Selecciona la ciudad donde deseas buscar clubs:\n\n_Mostrando ciudades ${newOffset + 1}-${newOffset + ciudadesMostrar.length}_`,
        buttonText: "Ver ciudades",
        sections: [
          {
            title: "Ciudades Disponibles",
            rows: rows,
          },
        ],
      };
    }

    const ciudades = await getDraftData(pool, phoneNumber, "ciudades_lista");
    
    let ciudadSeleccionada = null;
    if (userInput.startsWith("ciudad_buscar_")) {
      const index = parseInt(userInput.replace("ciudad_buscar_", ""));
      if (!isNaN(index) && ciudades && ciudades[index]) {
        ciudadSeleccionada = ciudades[index].ciudad;
      }
    }

    if (!ciudadSeleccionada) {
      return {
        type: "text",
        text: `❌ Opción inválida. Por favor selecciona una ciudad de la lista.`,
      };
    }

    // Buscar clubs en la ciudad seleccionada
    const estadoSeleccionado = await getDraftData(pool, phoneNumber, "estado_seleccionado");
    const [clubs] = await pool.query(
      `SELECT nombre, direccion, telefonos, ciudad 
       FROM directorio_clubes 
       WHERE ciudad = ? AND estado = ?
       ORDER BY nombre ASC`,
      [ciudadSeleccionada, estadoSeleccionado]
    );

    await clearFlow(pool, phoneNumber);

    if (clubs.length === 0) {
      return {
        type: "text",
        text: `❌ No encontré clubs en *${ciudadSeleccionada}*.${textoVolverMenu()}`,
      };
    }

    let text = `🎾 *Clubs en ${ciudadSeleccionada}, ${estadoSeleccionado}*\n\n`;
    text += `Encontré *${clubs.length}* club${clubs.length > 1 ? 's' : ''}:\n\n`;
    
    clubs.forEach((club, idx) => {
      text += `${idx + 1}️⃣ *${club.nombre}*\n`;
      if (club.direccion) {
        text += `   📍 ${club.direccion}\n`;
      }
      if (club.telefonos) {
        try {
          const telefonos = JSON.parse(club.telefonos);
          if (telefonos.length > 0) {
            text += `   📞 ${telefonos.join(', ')}\n`;
          }
        } catch (e) {
          // Ignorar si no se puede parsear los teléfonos
        }
      }
      text += `\n`;
    });

    text += textoVolverMenu();
    return { type: "text", text };
  }
}

/**
 * Flujo 3: Información de un Club
 */
async function handleFlujoInfoClub(pool, phoneNumber, userInput, currentStep, draft, token, phoneNumberId) {
  // PASO 1: Mostrar lista de clubes disponibles desde directorio_clubes
  if (currentStep === "inicio") {
    // Obtener página actual (default: 0)
    const offset = (await getDraftData(pool, phoneNumber, "clubs_offset")) || 0;
    const limit = 9;

    // Consultar clubes desde directorio_clubes
    const [clubs] = await pool.query(
      `SELECT id_directorio_club, nombre, direccion, telefonos, ciudad 
       FROM directorio_clubes 
       ORDER BY nombre ASC
       LIMIT ? OFFSET ?`,
      [limit + 1, offset] // +1 para saber si hay más
    );

    if (clubs.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `❌ No hay clubes disponibles en este momento.${textoVolverMenu()}`,
      };
    }

    const hayMas = clubs.length > limit;
    const clubsMostrar = clubs.slice(0, limit);

    await saveDraftData(pool, phoneNumber, "clubs_lista", clubsMostrar);
    await setFlow(pool, phoneNumber, "info_club", "seleccionar_club");

    // Crear filas para la lista
    const rows = clubsMostrar.map((club, idx) => ({
      id: `club_info_${idx}`,
      title: club.nombre.substring(0, 24), // Max 24 caracteres
      description: `📍 ${club.ciudad}`.substring(0, 72),
    }));

    // Agregar opción "Ver más" si hay más clubes
    if (hayMas) {
      rows.push({
        id: "ver_mas_clubs",
        title: "Ver más clubes",
        description: "Mostrar siguientes 9 clubes",
      });
    }

    return {
      type: "list",
      headerText: "🎾 Clubes Disponibles",
      bodyText: `Selecciona el club del que deseas ver información:\n\n_Mostrando ${offset + 1}-${offset + clubsMostrar.length}_`,
      buttonText: "Ver clubes",
      sections: [
        {
          title: "Clubes",
          rows: rows,
        },
      ],
    };
  }

  // PASO 2: Procesar selección de club o paginación
  if (currentStep === "seleccionar_club") {
    // Si seleccionó "Ver más"
    if (userInput === "ver_mas_clubs") {
      const offset = (await getDraftData(pool, phoneNumber, "clubs_offset")) || 0;
      await saveDraftData(pool, phoneNumber, "clubs_offset", offset + 9);
      await setFlow(pool, phoneNumber, "info_club", "inicio");
      
      // Recursivamente llamar a inicio para mostrar siguiente página
      return await handleFlujoInfoClub(pool, phoneNumber, userInput, "inicio", draft);
    }

    // Extraer índice del club seleccionado
    if (!userInput.startsWith("club_info_")) {
      return {
        type: "text",
        text: "❌ Selección inválida. Por favor elige un club de la lista.",
      };
    }

    const index = parseInt(userInput.split("_")[2]);
    const clubsLista = await getDraftData(pool, phoneNumber, "clubs_lista");

    if (index < 0 || index >= clubsLista.length) {
      return {
        type: "text",
        text: "❌ Selección inválida. Por favor elige un club de la lista.",
      };
    }

    const club = clubsLista[index];

    // Buscar horarios del club (intentar match por nombre)
    const [horarios] = await pool.query(
      `SELECT hc.dia, hc.hora_inicio, hc.hora_fin 
       FROM horarios_club hc
       INNER JOIN fraccionamiento_club fc ON hc.id_fraccionamientoclub = fc.id_fraccionamientoclub
       WHERE fc.fc_nombre LIKE ? AND hc.estatus = 1
       ORDER BY FIELD(hc.dia, 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')`,
      [`%${club.nombre}%`]
    );

    await saveDraftData(pool, phoneNumber, "club_info", club);
    await saveDraftData(pool, phoneNumber, "clubs_offset", 0); // Reset offset
    await setFlow(pool, phoneNumber, "info_club", "menu_info");

    let text = `🎾 *${club.nombre}*\n\n`;
    
    // Dirección desde directorio_clubes
    if (club.direccion) {
      text += `📍 *Dirección:*\n${club.direccion}\n`;
      if (club.ciudad) {
        text += `${club.ciudad}\n`;
      }
      text += `\n`;
    }
    
    // Teléfonos desde directorio_clubes
    if (club.telefonos) {
      try {
        const telefonos = JSON.parse(club.telefonos);
        if (telefonos.length > 0) {
          text += `📞 *Teléfono(s):*\n`;
          telefonos.forEach(tel => {
            text += `   ${tel}\n`;
          });
          text += `\n`;
        }
      } catch (e) {
        // Ignorar error de parseo
      }
    }
    
    // Horarios desde horarios_club
    if (horarios.length > 0) {
      text += `⏰ *Horarios:*\n`;
      horarios.forEach(h => {
        text += `   ${h.dia}: ${h.hora_inicio.substring(0, 5)} - ${h.hora_fin.substring(0, 5)}\n`;
      });
      text += `\n`;
    } else {
      text += `⏰ *Horarios:* No disponibles\n\n`;
    }

    return {
      type: "button",
      bodyText: text + `¿Qué deseas hacer?`,
      buttons: [
        { type: "reply", reply: { id: "1", title: "📅 Hacer reservación" } },
        { type: "reply", reply: { id: "2", title: "🏠 Volver al menú" } },
      ],
    };
  }

  // PASO 3: Menú de opciones
  if (currentStep === "menu_info") {
    if (userInput === "1") {
      // Buscar el club en fraccionamiento_club por nombre para hacer reservación
      const clubInfo = await getDraftData(pool, phoneNumber, "club_info");
      
      const [clubFC] = await pool.query(
        `SELECT id_fraccionamientoclub, fc_nombre 
         FROM fraccionamiento_club 
         WHERE fc_nombre LIKE ? AND id_status = 1 
         LIMIT 1`,
        [`%${clubInfo.nombre}%`]
      );
      
      if (clubFC.length === 0) {
        await clearFlow(pool, phoneNumber);
        return {
          type: "text",
          text: `❌ Lo sentimos, este club no está disponible para reservaciones en este momento.${textoVolverMenu()}`
        };
      }
      
      // Guardar club y pasar al flujo de reservas en paso de seleccionar fecha
      // (el club ya está preseleccionado, solo falta que elija fecha)
      await saveDraftData(pool, phoneNumber, "club_id", clubFC[0].id_fraccionamientoclub);
      await saveDraftData(pool, phoneNumber, "club_nombre", clubFC[0].fc_nombre);

      // Generar próximos 7 días
      const diasSemana = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"];
      const fechas = [];
      for (let i = 0; i < 7; i++) {
        const ahora = new Date(new Date().toLocaleString("en-US", { timeZone: "America/Mexico_City" }));
        ahora.setDate(ahora.getDate() + i);
        const año = ahora.getFullYear();
        const mes = String(ahora.getMonth() + 1).padStart(2, "0");
        const dia = String(ahora.getDate()).padStart(2, "0");
        const fechaStr = `${año}-${mes}-${dia}`;
        const diaNombre = diasSemana[ahora.getDay()];
        const label = i === 0 ? `Hoy (${diaNombre} ${dia}/${mes})` : i === 1 ? `Mañana (${diaNombre} ${dia}/${mes})` : `${diaNombre} ${dia}/${mes}`;
        fechas.push({ fecha: fechaStr, dia: diaNombre, label });
      }

      await saveDraftData(pool, phoneNumber, "fechas_disponibles", fechas);
      // Marcar que viene preseleccionado para que al elegir fecha salte directo a canchas
      await saveDraftData(pool, phoneNumber, "club_preseleccionado", true);
      await setFlow(pool, phoneNumber, "reservas", "seleccionar_fecha_preclub");

      const rows = fechas.map((f, idx) => ({
        id: `fecha_${idx}`,
        title: f.label.substring(0, 24),
        description: f.fecha,
      }));

      return {
        type: "list",
        headerText: "Seleccionar Fecha",
        bodyText: `🏟️ *${clubFC[0].fc_nombre}*\n\nSelecciona la fecha para tu reserva:`,
        buttonText: "Ver fechas",
        sections: [{ title: "Próximos días", rows }],
      };
    } else if (userInput === "2") {
      await clearFlow(pool, phoneNumber);
      const tieneSuscripcion = draft?.tieneSuscripcionActiva || false;
      return menuPrincipal(null, tieneSuscripcion);
    } else {
      return { type: "text", text: " Opción inválida. Por favor elige 1 o 2." };
    }
  }
}

/**
 * Flujo 4: Problemas con Reservas
 */
async function handleFlujoProblemas(pool, phoneNumber, userInput, currentStep, draft, token = null, phoneNumberId = null) {
  // PASO 1: Mostrar menú de problemas
  if (currentStep === "inicio") {
    await setFlow(pool, phoneNumber, "problemas", "seleccionar_problema");
    return {
      type: "text",
      text: `Entiendo, vamos a revisar tu problema. Por favor selecciona:

1️⃣ ¿El club aparece como no disponible?
2️⃣ ¿El sistema te marca error al confirmar?
3️⃣ ¿Tu pago no se procesó?
4️⃣ Otro problema`,
    };
  }

  // PASO 2: Procesar problema seleccionado
  if (currentStep === "seleccionar_problema") {
    let response = "";
    
    switch (userInput) {
      case "1":
        await setFlow(pool, phoneNumber, "problemas", "opciones_no_disponible");
        return {
          type: "button",
          bodyText: `📋 *Club no disponible*\n\nEs posible que el club esté lleno para ese horario. Te recomiendo:\n\n● Intentar otro horario\n● Revisar otros clubs cercanos\n\n¿Te gustaría buscar clubs disponibles?`,
          buttons: [
            { type: "reply", reply: { id: "1", title: "🔍 Sí, buscar clubs" } },
            { type: "reply", reply: { id: "2", title: "🏠 Volver al menú" } },
          ],
        };
        
      case "2":
        // Guardar asunto y descripción predefinidos y crear ticket real
        await saveDraftData(pool, phoneNumber, "reporte_asunto", "Error al confirmar reserva");
        await saveDraftData(pool, phoneNumber, "reporte_descripcion", "El usuario reportó un error al confirmar una reserva. Posible causa: conexión inestable o disponibilidad del horario.");
        return await crearReporte(pool, phoneNumber, null, token);
        
      case "3":
        // Guardar asunto y descripción predefinidos y crear ticket real
        await saveDraftData(pool, phoneNumber, "reporte_asunto", "Problema con pago");
        await saveDraftData(pool, phoneNumber, "reporte_descripcion", "El usuario reportó un problema con el procesamiento de su pago. Requiere revisión de soporte o contacto con el club.");
        return await crearReporte(pool, phoneNumber, null, token);
        
      case "4":
        await setFlow(pool, phoneNumber, "problemas", "pedir_descripcion");
        response = "Por favor describe tu problema en un mensaje:";
        break;
        
      default:
        response = " Opción inválida. Por favor elige un número del 1 al 4.";
    }

    return {
      type: "text",
      text: response,
    };
  }

  // PASO 3: Opciones después de "no disponible"
  if (currentStep === "opciones_no_disponible") {
    if (userInput === "1") {
      await setFlow(pool, phoneNumber, "reservas", "inicio");
      return await handleFlujoReservas(pool, phoneNumber, userInput, "inicio", draft);
    } else {
      await clearFlow(pool, phoneNumber);
      const tieneSuscripcion = draft?.tieneSuscripcionActiva || false;
      return menuPrincipal(null, tieneSuscripcion);
    }
  }

  // PASO 4: Capturar descripción de "otro problema"
  if (currentStep === "pedir_descripcion") {
    if (userInput.length < 10) {
      return {
        type: "text",
        text: "❌ La descripción es muy corta (mínimo 10 caracteres). Por favor describe mejor el problema.",
      };
    }
    await saveDraftData(pool, phoneNumber, "reporte_asunto", "Otro problema");
    await saveDraftData(pool, phoneNumber, "reporte_descripcion", userInput);
    return await crearReporte(pool, phoneNumber, null, token);
  }
}

/**
 * Flujo 5: Soporte - Levantar Reportes
 */
async function handleFlujoSoporte(pool, phoneNumber, userInput, currentStep, draft, token = null, phoneNumberId = null) {
  // PASO 1: Mostrar opciones de soporte
  if (currentStep === "inicio") {
    await setFlow(pool, phoneNumber, "soporte", "menu_soporte");
    return {
      type: "text",
      type: "list",
      headerText: "🆘 Centro de Soporte",
      bodyText: "¿Cómo podemos ayudarte? Selecciona una opción:",
      buttonText: "Ver opciones",
      sections: [
        {
          title: "Soporte",
          rows: [
            { id: "1", title: "📝 Levantar un reporte", description: "Crea un ticket de soporte" },
            { id: "2", title: "📞 Contactar asesor", description: "Datos de contacto directo" },
            { id: "3", title: "❓ Preguntas frecuentes", description: "Consulta dudas comunes" },
            { id: "4", title: "🏠 Volver al menú", description: "Regresar al menú principal" },
          ],
        },
      ],
    };
  }

  // PASO 2: Procesar selección del menú de soporte
  if (currentStep === "menu_soporte") {
    switch (userInput) {
      case "1":
        // Iniciar flujo de reporte
        await setFlow(pool, phoneNumber, "soporte", "pedir_asunto");
        return {
          type: "text",
          text: `📝 *Levantar Reporte*

Vamos a crear tu reporte paso a paso.

*Paso 1/3*: Por favor escribe el *asunto* de tu reporte (máximo 200 caracteres).

Ejemplo: "Error al reservar cancha" o "Problema con pago"`,
        };

      case "2":
        await clearFlow(pool, phoneNumber);
        return {
          type: "text",
          text: `📞 *Contactar con un asesor*

Puedes contactarnos por:

📧 Email: soporte@arosports.app
📱 WhatsApp: +52 1 33 1234 5678
⏰ Horario: Lun-Vie 9:00 AM - 6:00 PM

_Nota: Esta es información de demostración._
${textoVolverMenu()}`,
        };

      case "3":
        // Obtener categorías de FAQ desde la BD
        const [categorias] = await pool.query(
          `SELECT id, nombre, descripcion FROM faq_categorias ORDER BY id ASC`
        );
        
        if (categorias.length === 0) {
          return {
            type: "text",
            text: `❌ No hay preguntas frecuentes disponibles en este momento.${textoVolverMenu()}`
          };
        }
        
        // Guardar categorías en el draft para usar después
        await saveDraftData(pool, phoneNumber, "faq_categorias", categorias);
        await setFlow(pool, phoneNumber, "soporte", "mostrar_categorias_faq");
        
        // Construir el mensaje con las categorías
        let mensajeCategorias = `❓ *Preguntas Frecuentes*\n\nSelecciona una categoría:\n\n`;
        categorias.forEach((cat, index) => {
          const emoji = ['1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '🔟'][index] || `${index + 1}️⃣`;
          mensajeCategorias += `${emoji} ${cat.nombre}\n`;
        });
        mensajeCategorias += `\n0️⃣ Volver al menú de soporte`;
        
        return {
          type: "text",
          text: mensajeCategorias
        };

      case "4":
        await clearFlow(pool, phoneNumber);
        const tieneSuscripcion = draft?.tieneSuscripcionActiva || false;
        return menuPrincipal(null, tieneSuscripcion);

      default:
        return {
          type: "text",
          text: " Opción inválida. Por favor elige un número del 1 al 4.",
        };
    }
  }

  // PASO 2.1: Capturar asunto del reporte
  if (currentStep === "pedir_asunto") {
    if (userInput.length > 200) {
      return {
        type: "text",
        text: " El asunto es muy largo (máximo 200 caracteres). Por favor escribe un asunto más corto.",
      };
    }

    if (userInput.length < 5) {
      return {
        type: "text",
        text: " El asunto es muy corto (mínimo 5 caracteres). Por favor describe mejor el problema.",
      };
    }

    await saveDraftData(pool, phoneNumber, "reporte_asunto", userInput);
    await setFlow(pool, phoneNumber, "soporte", "pedir_descripcion");
    
    logger.info(`Asunto guardado para ${phoneNumber}: ${userInput}`);

    return {
      type: "text",
      text: ` Asunto registrado: "${userInput}"

*Paso 2/3*: Ahora describe con detalle tu problema.

Puedes escribir hasta 6 renglones explicando qué está pasando, cuándo ocurre, etc.`,
    };
  }

  // PASO 2.2: Capturar descripción del reporte
  if (currentStep === "pedir_descripcion") {
    if (userInput.length < 10) {
      return {
        type: "text",
        text: " La descripción es muy corta (mínimo 10 caracteres). Por favor describe mejor el problema.",
      };
    }

    await saveDraftData(pool, phoneNumber, "reporte_descripcion", userInput);
    await setFlow(pool, phoneNumber, "soporte", "preguntar_imagen");
    
    logger.info(`Descripción guardada para ${phoneNumber}: ${userInput.substring(0, 50)}...`);

    return {
      type: "button",
      bodyText: `✅ Descripción registrada.\n\n*Paso 3/3*: ¿Deseas adjuntar una imagen?\n(captura de pantalla, foto del problema, etc.)`,
      buttons: [
        { type: "reply", reply: { id: "1", title: "📷 Sí, enviar imagen" } },
        { type: "reply", reply: { id: "2", title: "⏭️ No, continuar" } },
      ],
    };
  }

  // PASO 2.3: Preguntar si desea adjuntar imagen
  if (currentStep === "preguntar_imagen") {
    if (userInput === "1") {
      await setFlow(pool, phoneNumber, "soporte", "esperar_imagen");
      logger.info(`Usuario ${phoneNumber} eligió enviar imagen`);
      return {
        type: "text",
        text: `📷 Perfecto, envía tu imagen ahora.

_Solo puedes enviar 1 imagen (JPG, PNG, GIF, WEBP)_`,
      };
    } else if (userInput === "2") {
      // Crear reporte sin imagen
      logger.info(`Usuario ${phoneNumber} eligió crear reporte SIN imagen. Llamando a crearReporte...`);
      // Usar el token que viene como parámetro de la función
      const resultado = await crearReporte(pool, phoneNumber, null, token);
      logger.info(`Reporte creado. Resultado:`, resultado);
      return resultado;
    } else {
      return {
        type: "text",
        text: "Opción inválida. Por favor elige 1 o 2.",
      };
    }
  }

  // PASO 2.4: Esperar imagen (este paso se maneja en el webhook principal)
  if (currentStep === "esperar_imagen") {
    return {
      type: "text",
      text: "⏳ Esperando tu imagen... Por favor envía la imagen ahora.",
    };
  }

  // PASO 3: Mostrar categorías FAQ - Usuario selecciona categoría
  if (currentStep === "mostrar_categorias_faq") {
    const draft = await getDraft(pool, phoneNumber);
    const categorias = draft?.data?.faq_categorias || [];
    
    // Opción para volver
    if (userInput === "0") {
      await setFlow(pool, phoneNumber, "soporte", "inicio");
      return await handleFlujoSoporte(pool, phoneNumber, userInput, "inicio", draft, token, phoneNumberId);
    }
    
    const indiceCategoria = parseInt(userInput) - 1;
    
    if (isNaN(indiceCategoria) || indiceCategoria < 0 || indiceCategoria >= categorias.length) {
      return {
        type: "text",
        text: `❌ Opción inválida. Por favor elige un número del 1 al ${categorias.length}, o 0 para volver.`
      };
    }
    
    const categoriaSeleccionada = categorias[indiceCategoria];
    
    // Obtener preguntas de esta categoría
    const [preguntas] = await pool.query(
      `SELECT id, pregunta, respuesta FROM faqs WHERE id_categoria = ? ORDER BY id ASC`,
      [categoriaSeleccionada.id]
    );
    
    if (preguntas.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `❌ No hay preguntas disponibles en la categoría "${categoriaSeleccionada.nombre}".${textoVolverMenu()}`
      };
    }
    
    // Guardar preguntas y categoría en el draft
    await saveDraftData(pool, phoneNumber, "faq_preguntas", preguntas);
    await saveDraftData(pool, phoneNumber, "faq_categoria_nombre", categoriaSeleccionada.nombre);
    await setFlow(pool, phoneNumber, "soporte", "mostrar_preguntas_faq");
    
    // Construir mensaje con las preguntas
    let mensajePreguntas = `❓ *${categoriaSeleccionada.nombre}*\n\nSelecciona una pregunta:\n\n`;
    preguntas.forEach((preg, index) => {
      const emoji = ['1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '🔟'][index] || `${index + 1}️⃣`;
      // Limitar longitud de pregunta en el menú
      const preguntaCorta = preg.pregunta.length > 60 ? preg.pregunta.substring(0, 60) + '...' : preg.pregunta;
      mensajePreguntas += `${emoji} ${preguntaCorta}\n`;
    });
    mensajePreguntas += `\n0️⃣ Volver a categorías`;
    
    return {
      type: "text",
      text: mensajePreguntas
    };
  }
  
  // PASO 4: Mostrar preguntas FAQ - Usuario selecciona pregunta
  if (currentStep === "mostrar_preguntas_faq") {
    const draft = await getDraft(pool, phoneNumber);
    const preguntas = draft?.data?.faq_preguntas || [];
    const categoriaNombre = draft?.data?.faq_categoria_nombre || "Preguntas Frecuentes";
    
    // Opción para volver a categorías
    if (userInput === "0") {
      // Volver a mostrar categorías
      const [categorias] = await pool.query(
        `SELECT id, nombre, descripcion FROM faq_categorias ORDER BY id ASC`
      );
      
      await saveDraftData(pool, phoneNumber, "faq_categorias", categorias);
      await setFlow(pool, phoneNumber, "soporte", "mostrar_categorias_faq");
      
      let mensajeCategorias = `❓ *Preguntas Frecuentes*\n\nSelecciona una categoría:\n\n`;
      categorias.forEach((cat, index) => {
        const emoji = ['1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '🔟'][index] || `${index + 1}️⃣`;
        mensajeCategorias += `${emoji} ${cat.nombre}\n`;
      });
      mensajeCategorias += `\n0️⃣ Volver al menú de soporte`;
      
      return {
        type: "text",
        text: mensajeCategorias
      };
    }
    
    const indicePregunta = parseInt(userInput) - 1;
    
    if (isNaN(indicePregunta) || indicePregunta < 0 || indicePregunta >= preguntas.length) {
      return {
        type: "text",
        text: `❌ Opción inválida. Por favor elige un número del 1 al ${preguntas.length}, o 0 para volver.`
      };
    }
    
    const preguntaSeleccionada = preguntas[indicePregunta];
    
    // Incrementar contador de vistas
    await pool.query(
      `UPDATE faqs SET vistas = vistas + 1 WHERE id = ?`,
      [preguntaSeleccionada.id]
    );
    
    // Limpiar flujo y mostrar respuesta
    await clearFlow(pool, phoneNumber);
    
    return {
      type: "text",
      text: `❓ *${preguntaSeleccionada.pregunta}*\n\n${preguntaSeleccionada.respuesta}${textoVolverMenu()}`
    };
  }

  // PASO 4: Reportar problema técnico (legacy - para preguntas frecuentes)
  if (currentStep === "reportar_problema_legacy") {
    await clearFlow(pool, phoneNumber);
    return {
      type: "text",
      text: `✅ *Reporte Recibido*

Hemos registrado tu problema:

"${userInput}"

Nuestro equipo técnico lo revisará y te contactará pronto.

📧 Recibirás una respuesta en las próximas 24-48 horas.
${textoVolverMenu()}`,
    };
  }
}

/**
 * Función auxiliar para crear el reporte en la BD
 * @param {object} pool - Conexión a la base de datos
 * @param {string} phoneNumber - Número de teléfono del usuario
 * @param {string|null} imageUrl - ID de la imagen en WhatsApp (si existe)
 * @param {string} whatsappToken - Token de WhatsApp para descargar imágenes
 */
async function crearReporte(pool, phoneNumber, imageUrl, whatsappToken) {
  try {
    logger.info(`🎫 Iniciando creación de reporte para ${phoneNumber}`);
    
    // 1. PRIMERO intentar obtener datos del usuario desde el DRAFT (guardados cuando dijo "Hola")
    const draft = await getDraft(pool, phoneNumber);
    let usuario = draft?.user;
    
    if (usuario && usuario.id_usuario) {
      logger.info(`✅ Usuario obtenido desde DRAFT: ${usuario.nombre} ${usuario.apellido} (ID: ${usuario.id_usuario})`);
    } else {
      // 2. Si NO hay datos en el draft, buscar en la BD con la misma lógica que getUserByPhone
      logger.info(`⚠️ No hay datos de usuario en draft, buscando en BD...`);
      usuario = await getFullUserByPhone(pool, phoneNumber);
      
      if (!usuario) {
        logger.error(` No se encontró usuario con teléfono ${phoneNumber}`);
        await clearFlow(pool, phoneNumber);
        return {
          type: "text",
          text: ` No se encontró tu usuario en el sistema.

Por favor regístrate primero en la app móvil o contacta a soporte.
${textoVolverMenu()}`,
        };
      }
      
      logger.info(`✅ Usuario encontrado en BD: ${usuario.nombre} ${usuario.apellido} (ID: ${usuario.id_usuario})`);
    }

    // 2. Obtener nombre del perfil
    const [perfiles] = await pool.query(
      "SELECT per_nombre FROM perfil WHERE id_perfil = ? LIMIT 1",
      [usuario.id_perfil]
    );

    const perfilNombre = perfiles.length > 0 ? perfiles[0].per_nombre : "Usuario";
    logger.info(`Perfil: ${perfilNombre}`);

    // 3. Recuperar datos del reporte del draft
    const asunto = await getDraftData(pool, phoneNumber, "reporte_asunto");
    const descripcion = await getDraftData(pool, phoneNumber, "reporte_descripcion");

    logger.info(`Datos del reporte - Asunto: ${asunto}, Descripción: ${descripcion?.substring(0, 50)}...`);

    if (!asunto || !descripcion) {
      logger.error(` Faltan datos del reporte: asunto=${asunto}, descripcion=${descripcion}`);
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: ` No se encontraron los datos del reporte.

Por favor intenta crear el reporte nuevamente.
${textoVolverMenu()}`,
      };
    }

    // 4. Crear el ticket en soporte_tickets
    const nombreCompleto = `${usuario.nombre} ${usuario.apellido || ""}`.trim();
    const telefonoUsuario = usuario.telefono || phoneNumber;
    const emailUsuario = usuario.correo || "sin_email@example.com";
    
    logger.info(`📝 Insertando ticket con datos:`);
    logger.info(`   - ID Usuario: ${usuario.id_usuario}`);
    logger.info(`   - Nombre: ${nombreCompleto}`);
    logger.info(`   - Email: ${emailUsuario}`);
    logger.info(`   - Teléfono: ${telefonoUsuario}`);
    logger.info(`   - Perfil: ${perfilNombre} (ID: ${usuario.id_perfil})`);
    logger.info(`   - Asunto: ${asunto}`);
    
    const [result] = await pool.query(
      `INSERT INTO soporte_tickets 
       (id_usuario, user_profile_id, user_profile_name, user_full_name, 
        user_phone, user_email, category_id, subject, description, 
        priority, status, created_at) 
       VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, 'medium', 'open', NOW())`,
      [
        usuario.id_usuario,
        usuario.id_perfil,
        perfilNombre,
        nombreCompleto,
        telefonoUsuario,
        emailUsuario,
        asunto,
        descripcion,
      ]
    );

    const ticketId = result.insertId;
    logger.info(`✅ Ticket creado exitosamente con ID: ${ticketId}`);

    // 5. Si hay imagen, descargar de WhatsApp, subir al servidor y guardar en soporte_ticket_attachments
    if (imageUrl && whatsappToken) {
      logger.info(`📷 Procesando imagen adjunta (ID WhatsApp: ${imageUrl})...`);
      
      // Descargar y subir la imagen
      const imageData = await downloadAndUploadWhatsAppImage(imageUrl, whatsappToken, ticketId);
      
      if (imageData && imageData.filepath) {
        // Guardar la información completa en la BD
        await pool.query(
          `INSERT INTO soporte_ticket_attachments 
           (ticket_id, filename, filepath, filesize, mimetype, created_at) 
           VALUES (?, ?, ?, ?, ?, NOW())`,
          [
            ticketId,
            imageData.filename,
            imageData.filepath,
            imageData.filesize,
            imageData.mimetype,
          ]
        );
        logger.info(`✅ Imagen guardada exitosamente en BD:`);
        logger.info(`   - Ruta: ${imageData.filepath}`);
        logger.info(`   - Nombre: ${imageData.filename}`);
        logger.info(`   - Tamaño: ${imageData.filesize} bytes`);
        logger.info(`   - Tipo: ${imageData.mimetype}`);
      } else {
        logger.error(`❌ No se pudo subir la imagen al servidor`);
      }
    } else if (imageUrl && !whatsappToken) {
      logger.error(`❌ Se recibió una imagen pero no hay token de WhatsApp disponible`);
    }

    // 6. Limpiar el flujo
    await clearFlow(pool, phoneNumber);
    logger.info(`🧹 Flujo limpiado para ${phoneNumber}`);

    // 7. Retornar confirmación
    return {
      type: "text",
      text: `✅ *Reporte Creado Exitosamente*

� Usuario: ${nombreCompleto}
📧 Email: ${emailUsuario}
📱 Teléfono: ${telefonoUsuario}

*Asunto:* ${asunto}
*Descripción:* ${descripcion.substring(0, 100)}${descripcion.length > 100 ? "..." : ""}
${imageUrl ? "📷 Imagen adjunta: Sí" : ""}

📌 Puedes revisar en la página de reportes el estatus de tu reporte, accediendo directamente a:
🔗 https://arosports.app/soporte/login
o
🔗 https://arosports.app/arosport/login

⏰ El reporte puede tardar de 24 a 48 horas en ser respondido.

*Estado:* Abierto
*Prioridad:* Media
${textoVolverMenu()}`,
    };
  } catch (error) {
    logger.error("Error al crear reporte:", error);
    logger.error("Stack trace:", error.stack);
    await clearFlow(pool, phoneNumber);
    return {
      type: "text",
      text: ` Ocurrió un error al crear tu reporte.

Por favor intenta nuevamente o contacta a soporte directamente.

Error: ${error.message}
${textoVolverMenu()}`,
    };
  }
}

// =========================================================
// � COORDENADAS DE CIUDADES CONOCIDAS PARA BÚSQUEDA POR UBICACIÓN
// =========================================================
const CIUDADES_COORDENADAS = [
  { ciudad: "Querétaro", estado: "Querétaro", lat: 20.5888, lng: -100.3899 },
  { ciudad: "San Miguel de Allende", estado: "Guanajuato", lat: 20.9144, lng: -100.7452 },
  { ciudad: "Leon", estado: "Guanajuato", lat: 21.1250, lng: -101.6859 },
  { ciudad: "Celaya", estado: "Guanajuato", lat: 20.5236, lng: -100.8157 },
  { ciudad: "Guanajuato", estado: "Guanajuato", lat: 21.0190, lng: -101.2574 },
  { ciudad: "Irapuato/Salamanca", estado: "Guanajuato", lat: 20.6766, lng: -101.3555 },
  { ciudad: "CDMX/Edo de Mex", estado: "CDMX/Edo de México", lat: 19.4326, lng: -99.1332 },
  { ciudad: "Toluca", estado: "CDMX/Edo de México", lat: 19.2826, lng: -99.6557 },
  { ciudad: "Valle de Bravo", estado: "Estado de México", lat: 19.1925, lng: -100.1314 },
  { ciudad: "Monterrey", estado: "Nuevo León", lat: 25.6866, lng: -100.3161 },
  { ciudad: "Guadalajara", estado: "Jalisco", lat: 20.6597, lng: -103.3496 },
  { ciudad: "Puebla/Tlaxcala", estado: "Puebla", lat: 19.0414, lng: -98.2063 },
  { ciudad: "Cuernavaca", estado: "Morelos", lat: 18.9242, lng: -99.2216 },
  { ciudad: "Pachuca", estado: "Hidalgo", lat: 20.1011, lng: -98.7591 },
  { ciudad: "Veracruz", estado: "Veracruz", lat: 19.1738, lng: -96.1342 },
  { ciudad: "Mérida", estado: "Yucatán", lat: 20.9674, lng: -89.5926 },
  { ciudad: "Tijuana", estado: "Baja California", lat: 32.5149, lng: -117.0382 },
  { ciudad: "Ensenada", estado: "Baja California", lat: 31.8667, lng: -116.5964 },
  { ciudad: "Mexicali", estado: "Baja California", lat: 32.6246, lng: -115.4523 },
  { ciudad: "Riviera Maya", estado: "Quintana Roo", lat: 20.6296, lng: -87.0739 },
  { ciudad: "Los Cabos", estado: "Baja California Sur", lat: 22.8905, lng: -109.9167 },
  { ciudad: "Chihuahua", estado: "Chihuahua", lat: 28.6353, lng: -106.0889 },
  { ciudad: "Ciudad Juarez", estado: "Chihuahua", lat: 31.6904, lng: -106.4245 },
  { ciudad: "Mazatlán", estado: "Sinaloa", lat: 23.2494, lng: -106.4111 },
  { ciudad: "Riviera Nayarit", estado: "Jalisco/Nayarit", lat: 20.6534, lng: -105.2253 },
  { ciudad: "Morelia", estado: "Michoacán", lat: 19.7060, lng: -101.1950 },
  { ciudad: "Moroleón/Uruapan", estado: "Michoacán", lat: 20.1276, lng: -101.1901 },
  { ciudad: "La Piedad", estado: "Michoacán", lat: 20.3439, lng: -102.0255 },
  { ciudad: "San Luis Potosi", estado: "San Luis Potosí", lat: 22.1565, lng: -100.9855 },
  { ciudad: "Oaxaca", estado: "Oaxaca", lat: 17.0732, lng: -96.7266 },
  { ciudad: "Saltillo", estado: "Coahuila", lat: 25.4232, lng: -100.9924 },
  { ciudad: "Torreon", estado: "Coahuila", lat: 25.5428, lng: -103.4068 },
  { ciudad: "Piedras Negras", estado: "Coahuila", lat: 28.7010, lng: -100.5218 },
  { ciudad: "Chiapas", estado: "Chiapas", lat: 16.7528, lng: -93.1152 },
  { ciudad: "Hermosillo", estado: "Sonora", lat: 29.0729, lng: -110.9559 },
  { ciudad: "Tampico", estado: "Tamaulipas", lat: 22.2331, lng: -97.8613 },
  { ciudad: "Matamoros", estado: "Tamaulipas", lat: 25.8697, lng: -97.5027 },
  { ciudad: "Durango", estado: "Durango", lat: 24.0277, lng: -104.6532 },
  { ciudad: "Aguascalientes", estado: "Aguascalientes", lat: 21.8853, lng: -102.2916 },
];

/**
 * Calcula distancia entre dos puntos geográficos (fórmula de Haversine simplificada)
 */
function distanciaEntre(lat1, lng1, lat2, lng2) {
  const dLat = lat2 - lat1;
  const dLng = lng2 - lng1;
  return Math.sqrt(dLat * dLat + dLng * dLng);
}

/**
 * Encuentra la ciudad más cercana a las coordenadas dadas
 */
function encontrarCiudadCercana(lat, lng) {
  if (!lat || !lng) return null;
  
  let mejorMatch = null;
  let menorDistancia = Infinity;

  for (const ciudad of CIUDADES_COORDENADAS) {
    const dist = distanciaEntre(lat, lng, ciudad.lat, ciudad.lng);
    if (dist < menorDistancia) {
      menorDistancia = dist;
      mejorMatch = ciudad;
    }
  }

  // Si la distancia es muy grande (más de ~3 grados ≈ 300km), no hay match razonable
  if (menorDistancia > 3) return null;

  return mejorMatch;
}

/**
 * Helper: envía respuesta de WhatsApp según su tipo
 */
async function enviarRespuesta(response, to, token, phoneNumberId) {
  if (!response) return;
  if (response.type === "text") {
    await sendWhatsAppText({ to, token, phoneNumberId, text: response.text });
  } else if (response.type === "list") {
    await sendWhatsAppList({
      to, token, phoneNumberId,
      headerText: response.headerText,
      bodyText: response.bodyText,
      buttonText: response.buttonText,
      sections: response.sections,
    });
  } else if (response.type === "button") {
    await sendWhatsAppButtons({
      to, token, phoneNumberId,
      bodyText: response.bodyText,
      buttons: response.buttons,
    });
  }
}

// =========================================================
// �🚀 WEBHOOK PRINCIPAL - CHATBOT
// =========================================================
// Esta función maneja las peticiones de Meta (Webhook):
// - Verifica el token (GET)
// - Procesa mensajes y enruta según el flujo activo (POST)

export const whatsappWebhookPadel = onRequest(
  {
    cors: true,
    region: "us-central1",
    secrets: [VERIFY_TOKEN, WHATSAPP_TOKEN, WHATSAPP_PHONE_NUMBER_ID, DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, STRIPE_SECRET_KEY],
  },
  async (req, res) => {
    // Carga las variables desde los secrets
    const cfg = {
      VERIFY_TOKEN: VERIFY_TOKEN.value(),
      WHATSAPP_TOKEN: WHATSAPP_TOKEN.value(),
      WHATSAPP_PHONE_NUMBER_ID: WHATSAPP_PHONE_NUMBER_ID.value(),
      DB_HOST: DB_HOST.value(),
      DB_USER: DB_USER.value(),
      DB_PASSWORD: DB_PASSWORD.value(),
      DB_NAME: DB_NAME.value(),
    };

    // === Fase 1: Verificación inicial de Meta (GET)
    if (req.method === "GET") {
      const mode = req.query["hub.mode"];
      const token = req.query["hub.verify_token"];
      const challenge = req.query["hub.challenge"];

      // Meta verifica que el endpoint es válido devolviendo "challenge"
      return mode === "subscribe" && token === cfg.VERIFY_TOKEN
        ? res.status(200).send(challenge)
        : res.sendStatus(403);
    }

    // === Fase 2: Procesamiento de mensajes entrantes (POST)
    const body = req.body;
    const messages = body?.entry?.[0]?.changes?.[0]?.value?.messages;
    const from = messages?.[0]?.from;
    const token = cfg.WHATSAPP_TOKEN;
    const phoneNumberId = cfg.WHATSAPP_PHONE_NUMBER_ID;

    try {
      logger.info("Webhook body", body);

      // Ignora notificaciones de "status" (mensajes entregados, leídos, etc.)
      const statuses = body?.entry?.[0]?.changes?.[0]?.value?.statuses;
      if (Array.isArray(statuses) && statuses.length) return res.sendStatus(200);

      // Extrae mensaje y número del remitente
      if (!messages || !from) return res.sendStatus(200);

      const msg = messages[0];

      const pool = getPool(cfg);

      // Procesa mensajes de texto, interactivos o imágenes
      let userInput = "";
      let imageUrl = null;
      
      if (msg.type === "text") {
        userInput = msg.text.body.trim();
      } else if (msg.type === "interactive") {
        // Mensajes de respuesta a listas o botones interactivos
        userInput = msg.interactive?.list_reply?.id || msg.interactive?.button_reply?.id || "";
      } else if (msg.type === "image") {
        // Mensaje con imagen
        imageUrl = msg.image?.id; // ID de la imagen en WhatsApp
        
        // Verificar si el usuario está esperando una imagen
        const draft = await getDraft(pool, from);
        logger.info(`Imagen recibida de ${from}, imageId: ${imageUrl}, draft:`, draft);
        
        if (draft?.flow === "soporte" && draft?.step === "esperar_imagen") {
          // Procesar la imagen y crear el reporte
          logger.info(`✅ Usuario está en flujo de soporte esperando imagen. Creando reporte...`);
          
          // Crear reporte con la imagen, pasando el token directamente
          const response = await crearReporte(pool, from, imageUrl, token);
          
          // Enviar respuesta
          await sendWhatsAppText({
            to: from,
            token,
            phoneNumberId,
            text: response.text,
          });
          
          return res.sendStatus(200);
        } else {
          // No está en flujo de imagen, ignorar
          logger.info(`Usuario no está esperando imagen. Draft actual:`, draft);
          return res.sendStatus(200);
        }
      } else if (msg.type === "location") {
        // Mensaje de ubicación
        const lat = msg.location?.latitude;
        const lng = msg.location?.longitude;
        logger.info(`📍 Ubicación recibida de ${from}: lat=${lat}, lng=${lng}`);

        const draft = await getDraft(pool, from);

        if (draft?.flow === "buscar_clubs" && draft?.step === "esperar_ubicacion") {
          // Buscar el estado/ciudad más cercano usando coordenadas conocidas de ciudades
          const resultado = encontrarCiudadCercana(lat, lng);

          if (resultado) {
            await saveDraftData(pool, from, "estado_ubicacion", resultado.estado);
            await saveDraftData(pool, from, "ciudad_ubicacion", resultado.ciudad);
            await setFlow(pool, from, "buscar_clubs", "resultado_ubicacion");

            const response = await handleFlujoBuscarClubs(pool, from, "", "resultado_ubicacion", draft);
            await enviarRespuesta(response, from, token, phoneNumberId);
          } else {
            await clearFlow(pool, from);
            await sendWhatsAppText({
              to: from,
              token,
              phoneNumberId,
              text: `❌ No encontré clubs cerca de tu ubicación.\n\nIntenta buscar por nombre o navegar por estado.${textoVolverMenu()}`,
            });
          }
          return res.sendStatus(200);
        } else {
          logger.info(`Usuario envió ubicación pero no está en flujo de búsqueda.`);
          return res.sendStatus(200);
        }
      } else {
        return res.sendStatus(200);
      }

      // =========================================================
      // 🎯 ROUTER CENTRAL - Procesamiento de mensajes
      // =========================================================

      let response = null;

      // 1. REINICIAR FLUJO: "Hola" o "Cancelar"
      if (userInput.toLowerCase() === "hola" || userInput.toLowerCase() === "cancelar") {
        await clearFlow(pool, from);
        
        // Log para depuración: ver número de teléfono que llega
        logger.info(`Número de teléfono recibido desde WhatsApp: ${from}`);
        
        // Buscar usuario COMPLETO por teléfono para saludo personalizado Y guardarlo en draft
        const usuarioCompleto = await getFullUserByPhone(pool, from);
        
        let tieneSuscripcion = false;
        
        // Log para verificar si se encontró al usuario
        if (usuarioCompleto) {
          logger.info(`✅ Usuario encontrado: ${usuarioCompleto.nombre} ${usuarioCompleto.apellido} (ID: ${usuarioCompleto.id_usuario})`);
          
          // Verificar si tiene suscripción activa
          tieneSuscripcion = await tieneUsuarioSuscripcionActiva(pool, usuarioCompleto.id_usuario);
          logger.info(`📋 Estado de suscripción: ${tieneSuscripcion ? 'ACTIVA ✅' : 'INACTIVA ❌'}`);
          
          // GUARDAR los datos del usuario en el draft para usarlos después
          await saveDraft(pool, from, {
            flow: null,
            step: "menu",
            user: usuarioCompleto, // Guardamos TODOS los datos del usuario
            tieneSuscripcionActiva: tieneSuscripcion, // Guardamos estado de suscripción
            data: {}
          });
        } else {
          logger.info(` No se encontró usuario con teléfono: ${from}`);
        }
        
        const nombreUsuario = usuarioCompleto ? usuarioCompleto.nombre : null;
        
        if (!usuarioCompleto) {
          response = {
            type: "text",
            text: `👋 ¡Bienvenido al bot de ArosPorts!\n\nLo sentimos, no pudimos encontrar tu usuario en nuestro sistema.\n\nPuedes registrarte en:\n🔗 https://arosports.app/arosport/login\n\nUna vez registrado, escribe *Hola* para acceder a todas las funciones del bot.`,
          };
        } else {
          response = menuPrincipal(nombreUsuario, tieneSuscripcion);
        }
      } else {
        // 2. LEER ESTADO ACTUAL
        const draft = await getDraft(pool, from);

        // 3. SIN FLUJO ACTIVO: Mostrar menú principal y procesar selección
        if (!draft || !draft.flow || draft.step === "menu") {
          // Verificar si el usuario tiene suscripción activa (desde el draft)
          const tieneSuscripcion = draft?.tieneSuscripcionActiva || false;
          
          // Solo permitir soporte si NO tiene suscripción activa
          if (!tieneSuscripcion && userInput !== "5" && userInput !== "opcion_5") {
            const usuario = await getUserByPhone(pool, from);
            const nombreUsuario = usuario ? usuario.nombre : null;
            response = {
              type: "text",
              text: `⚠️ *Suscripción Requerida*\n\nHola ${nombreUsuario || 'usuario'}, necesitas una suscripción activa para acceder a esta función.\n\nPor favor, contacta a soporte para activar tu suscripción.${textoVolverMenu()}`
            };
          } else if (userInput === "1" || userInput === "opcion_1") {
            await setFlow(pool, from, "reservas", "inicio");
            response = await handleFlujoReservas(pool, from, userInput, "inicio", draft, token, phoneNumberId);
          } else if (userInput === "2" || userInput === "opcion_2") {
            await setFlow(pool, from, "buscar_clubs", "inicio");
            response = await handleFlujoBuscarClubs(pool, from, userInput, "inicio", draft);
          } else if (userInput === "3" || userInput === "opcion_3") {
            await setFlow(pool, from, "info_club", "inicio");
            response = await handleFlujoInfoClub(pool, from, userInput, "inicio", draft, token, phoneNumberId);
          } else if (userInput === "5" || userInput === "opcion_5") {
            await setFlow(pool, from, "soporte", "inicio");
            response = await handleFlujoSoporte(pool, from, userInput, "inicio", draft, token, phoneNumberId);
          } else {
            // Buscar usuario para saludo personalizado en caso de opción no reconocida
            const usuario = await getUserByPhone(pool, from);
            const nombreUsuario = usuario ? usuario.nombre : null;
            response = menuPrincipal(nombreUsuario, tieneSuscripcion);
          }
        } else {
          // 4. ENRUTAR A FLUJO ESPECÍFICO
          switch (draft.flow) {
            case "reservas":
              response = await handleFlujoReservas(pool, from, userInput, draft.step, draft, token, phoneNumberId);
              break;

            case "buscar_clubs":
              response = await handleFlujoBuscarClubs(pool, from, userInput, draft.step, draft);
              break;

            case "info_club":
              response = await handleFlujoInfoClub(pool, from, userInput, draft.step, draft, token, phoneNumberId);
              break;

            case "problemas":
              response = await handleFlujoProblemas(pool, from, userInput, draft.step, draft, token, phoneNumberId);
              break;

            case "soporte":
              response = await handleFlujoSoporte(pool, from, userInput, draft.step, draft, token, phoneNumberId);
              break;

            case "soporte":
              response = await handleFlujoSoporte(pool, from, userInput, draft.step, draft, token, phoneNumberId);
              break;

            default:
              await clearFlow(pool, from);
              response = { type: "text", text: "Error: flujo no reconocido. Volviendo al menú principal." + textoVolverMenu() };
          }
        }
      }

      // Enviar respuesta al usuario según el tipo
      if (response.type === "text") {
        await sendWhatsAppText({
          to: from,
          token,
          phoneNumberId,
          text: response.text,
        });
      } else if (response.type === "list") {
        logger.info(`Enviando lista: header="${response.headerText}", button="${response.buttonText}", sections=${response.sections?.length}, rows=${JSON.stringify(response.sections?.map(s => ({t: s.title, r: s.rows?.length})))}`);
        await sendWhatsAppList({
          to: from,
          token,
          phoneNumberId,
          headerText: response.headerText,
          bodyText: response.bodyText,
          buttonText: response.buttonText,
          sections: response.sections,
        });
      } else if (response.type === "button") {
        await sendWhatsAppButtons({
          to: from,
          token,
          phoneNumberId,
          bodyText: response.bodyText,
          buttons: response.buttons,
        });
      }

      return res.sendStatus(200);
    } catch (err) {
      // Manejo de errores y log detallado
      const errData = err?.response?.data || err;
      logger.error("Error webhook:", errData);
      if (err?.response?.status === 400) {
        logger.error("Request que falló (payload):", JSON.stringify(err?.config?.data || "N/A").substring(0, 2000));
      }

      // Intentar enviar mensaje de error al usuario para que no se quede sin respuesta
      try {
        if (from && token && phoneNumberId) {
          await sendWhatsAppText({
            to: from,
            token,
            phoneNumberId,
            text: "⚠️ Ocurrió un error al procesar tu solicitud. Por favor intenta de nuevo.\n\n_Escribe 'Hola' para volver al menú principal._",
          });
        }
      } catch (sendErr) {
        logger.error("Error al enviar mensaje de error al usuario:", sendErr.message);
      }

      return res.sendStatus(200);
    }
  }
);

// =========================================================
// 💳 STRIPE WEBHOOK – Recibe eventos de pago completado
// =========================================================
export const stripeWebhookPadel = onRequest(
  {
    cors: false,
    region: "us-central1",
    invoker: "public",
    secrets: [STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, WHATSAPP_TOKEN, WHATSAPP_PHONE_NUMBER_ID, DB_HOST, DB_USER, DB_PASSWORD, DB_NAME],
  },
  async (req, res) => {
    if (req.method !== "POST") return res.sendStatus(405);

    const stripe = new Stripe(STRIPE_SECRET_KEY.value().trim());

    // Verificar la firma del webhook de Stripe
    const sig = req.headers["stripe-signature"];
    let event;
    try {
      event = stripe.webhooks.constructEvent(
        req.rawBody,
        sig,
        STRIPE_WEBHOOK_SECRET.value().trim()
      );
    } catch (err) {
      logger.error("⚠️ Stripe webhook signature verification failed:", err.message);
      return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    // Solo procesar checkout.session.completed
    if (event.type !== "checkout.session.completed") {
      logger.info(`Stripe event ignorado: ${event.type}`);
      return res.sendStatus(200);
    }

    const session = event.data.object;
    const meta = session.metadata;

    if (!meta?.phoneNumber || !meta?.clubId || !meta?.canchaId) {
      logger.error("Stripe webhook: metadata incompleta", meta);
      return res.sendStatus(200);
    }

    const cfg = {
      DB_HOST: DB_HOST.value(),
      DB_USER: DB_USER.value(),
      DB_PASSWORD: DB_PASSWORD.value(),
      DB_NAME: DB_NAME.value(),
    };
    const pool = getPool(cfg);

    try {
      // Verificar que el horario sigue disponible
      const [conflicto] = await pool.query(
        `SELECT id_reserva FROM reservas
         WHERE id_cancha = ? AND fecha = ? AND id_status = 1
         AND hora_inicio < ? AND hora_fin > ?
         LIMIT 1`,
        [meta.canchaId, meta.fecha, meta.slotFin + ":00", meta.slotInicio + ":00"]
      );

      if (conflicto.length > 0) {
        logger.warn("Stripe webhook: horario ya fue ocupado después del pago", meta);
        // Aun así guardar con status especial o notificar
        const token = WHATSAPP_TOKEN.value();
        const phoneNumberId = WHATSAPP_PHONE_NUMBER_ID.value();
        await sendWhatsAppText({
          to: meta.phoneNumber,
          token,
          phoneNumberId,
          text: `⚠️ *Pago recibido pero horario ocupado*\n\nTu pago fue procesado, pero el horario ${meta.slotInicio} - ${meta.slotFin} en ${meta.canchaNombre} el ${meta.fechaLabel} fue reservado por alguien más mientras pagabas.\n\nNos pondremos en contacto para ofrecerte otro horario o un reembolso.\n\n_Escribe 'Hola' para volver al menú._`,
        });
        return res.sendStatus(200);
      }

      // Guardar la reserva
      const duracion = parseInt(meta.slotDuracion);
      const duracionTime = `${String(duracion).padStart(2, "0")}:00:00`;
      const precio = parseFloat(meta.slotPrecio);

      const [resultado] = await pool.query(
        `INSERT INTO reservas (id_fraccionamientoclub, fecha, hora_inicio, hora_fin, id_cancha, id_status, precio, duracion, moneda, tipo_evento)
         VALUES (?, ?, ?, ?, ?, 1, ?, ?, ?, 'reserva')`,
        [meta.clubId, meta.fecha, meta.slotInicio + ":00", meta.slotFin + ":00", meta.canchaId, precio, duracionTime, meta.slotMoneda]
      );

      const idReserva = resultado.insertId;

      // Obtener id_usuario del que reserva y vincularlo
      const usuario = await getFullUserByPhone(pool, meta.phoneNumber);
      if (usuario) {
        await pool.query(
          `INSERT INTO reservas_participantes (id_reserva, id_usuario, costo_individual)
           VALUES (?, ?, ?)`,
          [idReserva, usuario.id_usuario, precio]
        );
      }

      // Enviar confirmación por WhatsApp
      const token = WHATSAPP_TOKEN.value();
      const phoneNumberId = WHATSAPP_PHONE_NUMBER_ID.value();

      const esParcial = meta.tipoPago === "parcial";
      const montoPagado = meta.montoPagado || meta.slotPrecio;
      const montoRestante = meta.montoRestante || "0";

      const textoConfirmacion = esParcial
        ? `✅ *¡Pago parcial recibido y reserva confirmada!*\n\n🆔 *Folio:* #${idReserva}\n🏟️ *Club:* ${meta.clubNombre}\n🎾 *Cancha:* ${meta.canchaNombre}\n📅 *Fecha:* ${meta.fechaLabel}\n⏰ *Horario:* ${meta.slotInicio} - ${meta.slotFin}\n⌛ *Duración:* ${duracion} hora${duracion > 1 ? "s" : ""}\n💰 *Precio total:* $${meta.slotPrecio} ${meta.slotMoneda}\n💵 *Pagado en línea:* $${montoPagado} ${meta.slotMoneda}\n🏦 *Restante a pagar en club:* $${montoRestante} ${meta.slotMoneda}\n\n¡Te esperamos! 🎾\n\n_Escribe 'Hola' para volver al menú._`
        : `✅ *¡Pago recibido y reserva confirmada!*\n\n🆔 *Folio:* #${idReserva}\n🏟️ *Club:* ${meta.clubNombre}\n🎾 *Cancha:* ${meta.canchaNombre}\n📅 *Fecha:* ${meta.fechaLabel}\n⏰ *Horario:* ${meta.slotInicio} - ${meta.slotFin}\n⌛ *Duración:* ${duracion} hora${duracion > 1 ? "s" : ""}\n💰 *Pagado:* $${meta.slotPrecio} ${meta.slotMoneda}\n\n¡Te esperamos! 🎾\n\n_Escribe 'Hola' para volver al menú._`;

      await sendWhatsAppText({
        to: meta.phoneNumber,
        token,
        phoneNumberId,
        text: textoConfirmacion,
      });

      logger.info(`✅ Reserva #${idReserva} creada tras pago Stripe session ${session.id}`);
      return res.sendStatus(200);
    } catch (err) {
      logger.error("Error en stripeWebhookPadel:", err);
      return res.status(500).send("Error procesando webhook");
    }
  }
);