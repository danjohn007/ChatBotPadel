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
 * Descarga una imagen de WhatsApp y la sube al servidor de AroSports
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
    
    // 4. Subir la imagen al servidor de AroSports
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
    
    logger.info(`📤 Subiendo imagen al servidor de AroSports...`);
    logger.info(`   - Nombre: ${filename}`);
    logger.info(`   - Tamaño: ${imageBuffer.length} bytes`);
    logger.info(`   - Tipo: ${contentType}`);
    logger.info(`   - Ticket ID: ${ticketId}`);
    
    // Llamar al endpoint de AroSports para subir el archivo
    const uploadResponse = await axios.post(
      'https://arosports.app/api/api/uploads/tickets',
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
    ? `Hola ${userName}, bienvenido a AroSport` 
    : `Bienvenido a AroSport`;
  
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
  
  // Menú principal con 3 opciones
  return {
    type: "button",
    bodyText: `${saludo}\n\n¿En qué puedo ayudarte hoy?`,
    buttons: [
      {
        type: "reply",
        reply: {
          id: "opcion_5",
          title: "🆘 Soporte técnico",
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
          id: "opcion_3",
          title: "ℹ️ Info de un club",
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
 * Flujo 1: Reservar Cancha (Mejorado con listas interactivas)
 */
async function handleFlujoReservas(pool, phoneNumber, userInput, currentStep, draft, token, phoneNumberId) {
  // PASO 1: Mostrar ciudades disponibles en lista interactiva
  if (currentStep === "inicio") {
    // Obtener ciudades únicas de clubs activos
    const [ciudades] = await pool.query(
      `SELECT DISTINCT d.estado as ciudad
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE fc.id_status = 1 AND d.estado IS NOT NULL AND d.estado != ''
       ORDER BY d.estado
       LIMIT 10`
    );

    if (ciudades.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: " No hay ciudades disponibles en este momento." + textoVolverMenu(),
      };
    }

    await setFlow(pool, phoneNumber, "reservas", "seleccionar_ciudad");

    // Crear secciones para la lista interactiva
    const rows = ciudades.map((c, idx) => ({
      id: `ciudad_${idx}`,
      title: c.ciudad || "Sin nombre",
      description: `Clubs en ${c.ciudad}`,
    }));

    return {
      type: "list",
      headerText: "Ciudades Disponibles",
      bodyText: "Selecciona la ciudad donde quieres jugar:",
      buttonText: "Ver ciudades",
      sections: [
        {
          title: "Selecciona tu ciudad",
          rows: rows,
        },
      ],
    };
  }

  // PASO 2: Capturar ciudad y mostrar clubs disponibles
  if (currentStep === "seleccionar_ciudad") {
    // Obtener ciudades para mapear la selección
    const [ciudades] = await pool.query(
      `SELECT DISTINCT d.estado as ciudad
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE fc.id_status = 1 AND d.estado IS NOT NULL AND d.estado != ''
       ORDER BY d.estado
       LIMIT 10`
    );

    let ciudadSeleccionada = null;

    // Si viene de lista interactiva
    if (userInput.startsWith("ciudad_")) {
      const index = parseInt(userInput.split("_")[1]);
      if (index >= 0 && index < ciudades.length) {
        ciudadSeleccionada = ciudades[index].ciudad;
      }
    }

    if (!ciudadSeleccionada) {
      return {
        type: "text",
        text: " Selección inválida. Por favor selecciona una ciudad de la lista.",
      };
    }

    // Guardar ciudad seleccionada
    await saveDraftData(pool, phoneNumber, "ciudad", ciudadSeleccionada);

    // Buscar clubs en esa ciudad
    const [clubs] = await pool.query(
      `SELECT fc.id_fraccionamientoclub, fc.fc_nombre, d.colonia
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE d.estado LIKE ? AND fc.id_status = 1
       LIMIT 10`,
      [`%${ciudadSeleccionada}%`]
    );

    if (clubs.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `No encontré clubs disponibles en *${ciudadSeleccionada}*.` + textoVolverMenu(),
      };
    }

    // Guardar clubs encontrados
    await saveDraftData(pool, phoneNumber, "clubs_disponibles", clubs);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_club");

    // Crear lista interactiva de clubs
    const rows = clubs.map((club, idx) => ({
      id: `club_${idx}`,
      title: club.fc_nombre.substring(0, 24), // WhatsApp limita a 24 chars
      description: club.colonia ? ` ${club.colonia.substring(0, 72)}` : "Club de pádel",
    }));

    return {
      type: "list",
      headerText: ` Clubs en ${ciudadSeleccionada}`,
      bodyText: `Encontré ${clubs.length} club${clubs.length > 1 ? "s" : ""} disponible${clubs.length > 1 ? "s" : ""}. Selecciona uno:`,
      buttonText: "Ver clubs",
      sections: [
        {
          title: "Clubs disponibles",
          rows: rows,
        },
      ],
    };
  }

  // PASO 3: Capturar club y mostrar horarios disponibles
  if (currentStep === "seleccionar_club") {
    let clubSeleccionado = null;

    // Verificar si viene con club preseleccionado desde info_club
    if (userInput.startsWith("club_preseleccionado_")) {
      const clubId = parseInt(userInput.split("_")[2]);
      const clubNombre = await getDraftData(pool, phoneNumber, "club_nombre");
      clubSeleccionado = {
        id_fraccionamientoclub: clubId,
        fc_nombre: clubNombre
      };
    } else {
      // Flujo normal: selección desde lista
      const clubs = await getDraftData(pool, phoneNumber, "clubs_disponibles");

      // Si viene de lista interactiva
      if (userInput.startsWith("club_")) {
        const index = parseInt(userInput.split("_")[1]);
        if (index >= 0 && index < clubs.length) {
          clubSeleccionado = clubs[index];
        }
      }

      if (!clubSeleccionado) {
        return {
          type: "text",
          text: " Selección inválida. Por favor selecciona un club de la lista.",
        };
      }
    }

    // Guardar club seleccionado
    await saveDraftData(pool, phoneNumber, "club_id", clubSeleccionado.id_fraccionamientoclub);
    await saveDraftData(pool, phoneNumber, "club_nombre", clubSeleccionado.fc_nombre);

    // DEMO: Generar horarios simulados (sin consultar BD)
    const slots = [
      { inicio: "08:00", fin: "09:00" },
      { inicio: "09:00", fin: "10:00" },
      { inicio: "10:00", fin: "11:00" },
      { inicio: "11:00", fin: "12:00" },
      { inicio: "12:00", fin: "13:00" },
      { inicio: "13:00", fin: "14:00" },
      { inicio: "14:00", fin: "15:00" },
      { inicio: "15:00", fin: "16:00" },
      { inicio: "16:00", fin: "17:00" },
      { inicio: "17:00", fin: "18:00" },
      { inicio: "18:00", fin: "19:00" },
      { inicio: "19:00", fin: "20:00" },
      { inicio: "20:00", fin: "21:00" },
      { inicio: "21:00", fin: "22:00" },
      { inicio: "22:00", fin: "23:00" },
    ];

    // Limitar a máximo 24 slots (límite de WhatsApp)
    const slotsLimitados = slots.slice(0, 24);
    
    await saveDraftData(pool, phoneNumber, "horarios_disponibles", slotsLimitados);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_horario");

    // Crear lista interactiva de horarios
    const rows = slotsLimitados.map((slot, idx) => {
      return {
        id: `horario_${idx}`,
        title: `${slot.inicio} - ${slot.fin}`,
        description: `Disponible`,
      };
    });

    return {
      type: "list",
      headerText: ` Horarios Disponibles`,
      bodyText: `Selecciona el horario para tu reserva en *${clubSeleccionado.fc_nombre}*:`,
      buttonText: "Ver horarios",
      sections: [
        {
          title: "Horarios del día",
          rows: rows,
        },
      ],
    };
  }

  // PASO 4: Capturar horario y pedir número de jugadores
  if (currentStep === "seleccionar_horario") {
    const horarios = await getDraftData(pool, phoneNumber, "horarios_disponibles");
    let horarioSeleccionado = null;

    // Si viene de lista interactiva
    if (userInput.startsWith("horario_")) {
      const index = parseInt(userInput.split("_")[1]);
      if (index >= 0 && index < horarios.length) {
        horarioSeleccionado = horarios[index];
      }
    }

    if (!horarioSeleccionado) {
      return {
        type: "text",
        text: " Selección inválida. Por favor selecciona un horario de la lista.",
      };
    }

    const horarioDisplay = `${horarioSeleccionado.inicio} - ${horarioSeleccionado.fin}`;
    await saveDraftData(pool, phoneNumber, "horario", horarioDisplay);
    await setFlow(pool, phoneNumber, "reservas", "pedir_jugadores");

    return {
      type: "text",
      text: `Perfecto, has seleccionado el horario *${horarioDisplay}*.\n\n¿Para cuántas personas será la reserva? (Ejemplo: 4 jugadores)`,
    };
  }

  // PASO 5: Capturar número de jugadores y pedir duración
  if (currentStep === "pedir_jugadores") {
    const numJugadores = parseInt(userInput);
    if (isNaN(numJugadores) || numJugadores < 2) {
      return {
        type: "text",
        text: " Por favor ingresa un número válido de jugadores (mínimo 2).",
      };
    }

    await saveDraftData(pool, phoneNumber, "num_jugadores", numJugadores);
    await setFlow(pool, phoneNumber, "reservas", "pedir_duracion");

    return {
      type: "text",
      text: `Genial, la reserva será para ${numJugadores} persona${numJugadores > 1 ? "s" : ""}.\n\n¿Por cuántas horas deseas reservar la cancha? (Ejemplo: 1, 2, 3)`,
    };
  }

  // PASO 6: Confirmar reserva (DEMO - no guarda en BD)
  if (currentStep === "pedir_duracion") {
    const duracion = parseInt(userInput);
    if (isNaN(duracion) || duracion < 1) {
      return {
        type: "text",
        text: " Por favor ingresa un número válido de horas (ejemplo: 1, 2, 3).",
      };
    }

    // Recuperar todos los datos
    const ciudad = await getDraftData(pool, phoneNumber, "ciudad");
    const clubNombre = await getDraftData(pool, phoneNumber, "club_nombre");
    const horario = await getDraftData(pool, phoneNumber, "horario");
    const numJugadores = await getDraftData(pool, phoneNumber, "num_jugadores");

    // Limpiar draft
    await clearFlow(pool, phoneNumber);

    return {
      type: "text",
      text: ` *Reserva Confirmada* 

📍 *Ciudad:* ${ciudad}
🏟️ *Club:* ${clubNombre}
⏰ *Hora:* ${horario}
⌛ *Duración:* ${duracion} hora${duracion > 1 ? "s" : ""}
👥 *Jugadores:* ${numJugadores} persona${numJugadores > 1 ? "s" : ""}

💡 _NOTA: Esta es una DEMO. No se ha guardado ninguna reserva real en la base de datos._

${menuPrincipal()}`,
    };
  }
}

/**
 * Flujo 2: Buscar Clubs Cercanos
 */
async function handleFlujoBuscarClubs(pool, phoneNumber, userInput, currentStep, draft) {
  // PASO 1: Mostrar lista de ciudades disponibles con paginación
  if (currentStep === "inicio") {
    // Obtener página actual (default: 0)
    const offset = (await getDraftData(pool, phoneNumber, "ciudades_offset")) || 0;
    const limit = 9; // Máximo 9 + 1 para "Ver más" = 10 items (límite de WhatsApp)

    // Obtener ciudades únicas desde directorio_clubes
    const [ciudades] = await pool.query(
      `SELECT DISTINCT ciudad 
       FROM directorio_clubes 
       WHERE ciudad IS NOT NULL AND ciudad != '' 
       ORDER BY ciudad ASC 
       LIMIT ? OFFSET ?`,
      [limit + 1, offset] // +1 para saber si hay más
    );

    if (ciudades.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `❌ No hay ciudades disponibles en el directorio.${textoVolverMenu()}`,
      };
    }

    const hayMas = ciudades.length > limit;
    const ciudadesMostrar = ciudades.slice(0, limit);

    // Guardar ciudades en el draft
    await saveDraftData(pool, phoneNumber, "ciudades_lista", ciudadesMostrar);
    await setFlow(pool, phoneNumber, "buscar_clubs", "seleccionar_ciudad");

    // Crear filas para la lista (máximo 9 ciudades + 1 "Ver más")
    const rows = ciudadesMostrar.map((c, idx) => ({
      id: `ciudad_buscar_${idx}`,
      title: c.ciudad,
      description: `Clubs en ${c.ciudad}`,
    }));

    // Agregar opción "Ver más" si hay más ciudades
    if (hayMas) {
      rows.push({
        id: "ver_mas_ciudades",
        title: "Ver más ciudades",
        description: "Mostrar siguientes 9 ciudades",
      });
    }

    return {
      type: "list",
      headerText: "📍 Buscar Clubs",
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

  // PASO 2: Usuario selecciona ciudad o pide ver más
  if (currentStep === "seleccionar_ciudad") {
    // Si selecciona "Ver más ciudades"
    if (userInput === "ver_mas_ciudades") {
      const offset = (await getDraftData(pool, phoneNumber, "ciudades_offset")) || 0;
      await saveDraftData(pool, phoneNumber, "ciudades_offset", offset + 9);
      await setFlow(pool, phoneNumber, "buscar_clubs", "inicio");
      return await handleFlujoBuscarClubs(pool, phoneNumber, userInput, "inicio", draft);
    }

    const ciudades = await getDraftData(pool, phoneNumber, "ciudades_lista");
    
    // Buscar por ID de lista interactiva
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
    const [clubs] = await pool.query(
      `SELECT nombre, direccion, telefonos, ciudad 
       FROM directorio_clubes 
       WHERE ciudad = ? 
       ORDER BY nombre ASC`,
      [ciudadSeleccionada]
    );

    await clearFlow(pool, phoneNumber);

    if (clubs.length === 0) {
      return {
        type: "text",
        text: `❌ No encontré clubs en *${ciudadSeleccionada}*.${textoVolverMenu()}`,
      };
    }

    let text = `🎾 *Clubs en ${ciudadSeleccionada}*\n\n`;
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

    text += `¿Qué deseas hacer?\n\n`;
    text += `1️⃣ Hacer una reservación\n`;
    text += `2️⃣ Volver al menú principal\n`;

    return { type: "text", text };
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
      
      await saveDraftData(pool, phoneNumber, "club_id", clubFC[0].id_fraccionamientoclub);
      await saveDraftData(pool, phoneNumber, "club_nombre", clubFC[0].fc_nombre);
      
      // Cambiar a flujo de reservas y mostrar horarios directamente
      await setFlow(pool, phoneNumber, "reservas", "seleccionar_club");
      
      // Simular que viene desde seleccionar_club con el club ya elegido
      return await handleFlujoReservas(pool, phoneNumber, `club_preseleccionado_${clubFC[0].id_fraccionamientoclub}`, "seleccionar_club", {
        ...draft,
        data: {
          ...draft.data,
          club_id: clubFC[0].id_fraccionamientoclub,
          club_nombre: clubFC[0].fc_nombre
        }
      }, token, phoneNumberId);
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
async function handleFlujoProblemas(pool, phoneNumber, userInput, currentStep, draft) {
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
        response = `📋 *Club no disponible*

Es posible que el club esté lleno para ese horario. Te recomiendo:

● Intentar otro horario
● Revisar otros clubs cercanos

¿Te gustaría buscar clubs disponibles?

1️⃣ Sí, buscar clubs
2️⃣ No, volver al menú`;
        await setFlow(pool, phoneNumber, "problemas", "opciones_no_disponible");
        break;
        
      case "2":
        response = ` *Error al confirmar*

El error puede deberse a:
● Conexión inestable
● Disponibilidad del horario

Te recomiendo:
● Intentar nuevamente en 5 minutos
● Verificar tu conexión a internet

_NOTA DEMO: En un sistema real, aquí se levantaría un ticket de soporte._`;
        await clearFlow(pool, phoneNumber);
        response += textoVolverMenu();
        break;
        
      case "3":
        response = `*Problema con pago*

Para problemas de pago, necesitas contactar directamente con el club o con soporte.

_NOTA DEMO: En un sistema real, aquí se levantaría un ticket de soporte y se solicitarían más detalles._`;
        await clearFlow(pool, phoneNumber);
        response += textoVolverMenu();
        break;
        
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
    await clearFlow(pool, phoneNumber);
    return {
      type: "text",
      text: `Hemos registrado tu problema:

"${userInput}"

_NOTA DEMO: En un sistema real, esto se guardaría como un ticket de soporte._
${textoVolverMenu()}`,
    };
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
      text: `🆘 *Centro de Soporte* 🆘

¿Cómo podemos ayudarte?

1️⃣ Levantar un reporte
2️⃣ Contactar con un asesor
3️⃣ Preguntas frecuentes
4️⃣ Volver al menú principal`,
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
      type: "text",
      text: ` Descripción registrada.

*Paso 3/3*: ¿Deseas adjuntar una imagen? (captura de pantalla, foto del problema, etc.)

1️⃣ Sí, enviaré una imagen
2️⃣ No, continuar sin imagen`,
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

📋 *Ticket #${ticketId}*
👤 Usuario: ${nombreCompleto}
📧 Email: ${emailUsuario}
📱 Teléfono: ${telefonoUsuario}

*Asunto:* ${asunto}
*Descripción:* ${descripcion.substring(0, 100)}${descripcion.length > 100 ? "..." : ""}
${imageUrl ? "📷 Imagen adjunta: Sí" : ""}

🔔 Recibirás una respuesta en las próximas 24-48 horas a tu correo electrónico.

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
// 🚀 WEBHOOK PRINCIPAL - CHATBOT
// =========================================================
// Esta función maneja las peticiones de Meta (Webhook):
// - Verifica el token (GET)
// - Procesa mensajes y enruta según el flujo activo (POST)

export const whatsappWebhookPadel = onRequest(
  {
    cors: true,
    region: "us-central1",
    secrets: [VERIFY_TOKEN, WHATSAPP_TOKEN, WHATSAPP_PHONE_NUMBER_ID, DB_HOST, DB_USER, DB_PASSWORD, DB_NAME],
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
    try {
      const body = req.body;
      logger.info("Webhook body", body);

      // Ignora notificaciones de "status" (mensajes entregados, leídos, etc.)
      const statuses = body?.entry?.[0]?.changes?.[0]?.value?.statuses;
      if (Array.isArray(statuses) && statuses.length) return res.sendStatus(200);

      // Extrae mensaje y número del remitente
      const messages = body?.entry?.[0]?.changes?.[0]?.value?.messages;
      const from = messages?.[0]?.from;
      if (!messages || !from) return res.sendStatus(200);

      const token = cfg.WHATSAPP_TOKEN;
      const phoneNumberId = cfg.WHATSAPP_PHONE_NUMBER_ID;
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
        
        response = menuPrincipal(nombreUsuario, tieneSuscripcion);
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
              response = await handleFlujoProblemas(pool, from, userInput, draft.step, draft);
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
      logger.error("Error webhook:", err?.response?.data || err);
      return res.sendStatus(200);
    }
  }
);