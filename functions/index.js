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
// 💬 FUNCIÓN PARA ENVIAR MENSAJES DE TEXTO POR WHATSAPP
// =========================================================
// Usa la Graph API v20.0 para enviar mensajes desde el bot al usuario.

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
      timeout: 15000, // Timeout de 15 segundos
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
}

/**
 * Obtiene un dato específico del draft
 */
async function getDraftData(pool, phoneNumber, key) {
  const draft = await getDraft(pool, phoneNumber);
  return draft?.data?.[key];
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

// =========================================================
// 🎯 FLUJOS DEL CHATBOT
// =========================================================

/**
 * Menú principal del chatbot
 */
function menuPrincipal() {
  return `🎾 *Bienvenido a AroSport Padel* 🎾

¿En qué puedo ayudarte hoy?

1️⃣ Reservar cancha
2️⃣ Buscar clubs cercanos
3️⃣ Información de un club
4️⃣ Problemas con reservas

Escribe el número de la opción que desees.
_Escribe "Cancelar" en cualquier momento para volver al menú principal._`;
}

/**
 * Flujo 1: Reservar Cancha
 */
async function handleFlujoReservas(pool, phoneNumber, userInput, currentStep, draft) {
  // PASO 1: Pedir ciudad
  if (currentStep === "inicio") {
    await setFlow(pool, phoneNumber, "reservas", "pedir_ciudad");
    return "¿En qué ciudad quieres jugar? (Ejemplo: Querétaro, Puebla)";
  }

  // PASO 2: Capturar ciudad y pedir horario
  if (currentStep === "pedir_ciudad") {
    await saveDraftData(pool, phoneNumber, "ciudad", userInput);
    await setFlow(pool, phoneNumber, "reservas", "pedir_horario");
    return "¿A qué hora quieres jugar? (Ejemplo: 7pm, 19:00)";
  }

  // PASO 3: Capturar horario y buscar clubs disponibles
  if (currentStep === "pedir_horario") {
    await saveDraftData(pool, phoneNumber, "horario", userInput);
    
    const ciudad = await getDraftData(pool, phoneNumber, "ciudad");
    
    // Consultar clubs disponibles (DEMO - solo lectura)
    const [clubs] = await pool.query(
      `SELECT fc.id_fraccionamientoclub, fc.fc_nombre, d.estado
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE d.estado LIKE ? AND fc.id_status = 1
       LIMIT 3`,
      [`%${ciudad}%`]
    );

    if (clubs.length === 0) {
      await clearFlow(pool, phoneNumber);
      return `No encontré clubs disponibles en *${ciudad}*. 

${menuPrincipal()}`;
    }

    // Guardar clubs encontrados
    await saveDraftData(pool, phoneNumber, "clubs_disponibles", clubs);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_club");

    let response = `He encontrado ${clubs.length} clubs disponibles en *${ciudad}*:\n\n`;
    clubs.forEach((club, idx) => {
      response += `${idx + 1}️⃣ ${club.fc_nombre}\n`;
    });
    response += "\n● Elige el número del club donde quieras reservar.";

    return response;
  }

  // PASO 4: Seleccionar club y pedir número de jugadores
  if (currentStep === "seleccionar_club") {
    const seleccion = parseInt(userInput);
    const clubs = await getDraftData(pool, phoneNumber, "clubs_disponibles");

    if (isNaN(seleccion) || seleccion < 1 || seleccion > clubs.length) {
      return "❌ Selección inválida. Por favor elige un número de la lista.";
    }

    const clubSeleccionado = clubs[seleccion - 1];
    await saveDraftData(pool, phoneNumber, "club_id", clubSeleccionado.id_fraccionamientoclub);
    await saveDraftData(pool, phoneNumber, "club_nombre", clubSeleccionado.fc_nombre);
    await setFlow(pool, phoneNumber, "reservas", "pedir_jugadores");

    return `Perfecto, seleccionaste *${clubSeleccionado.fc_nombre}*. 

¿Para cuántas personas será la reserva? (Ejemplo: 4 jugadores)`;
  }

  // PASO 5: Capturar número de jugadores y pedir duración
  if (currentStep === "pedir_jugadores") {
    const numJugadores = parseInt(userInput);
    if (isNaN(numJugadores) || numJugadores < 2) {
      return "❌ Por favor ingresa un número válido de jugadores (mínimo 2).";
    }

    await saveDraftData(pool, phoneNumber, "num_jugadores", numJugadores);
    await setFlow(pool, phoneNumber, "reservas", "pedir_duracion");

    return "Genial, la reserva será para " + numJugadores + " personas. \n\n¿Por cuántas horas deseas reservar la cancha? (Ejemplo: 1 hora, 2 horas)";
  }

  // PASO 6: Confirmar reserva (DEMO - no guarda en BD)
  if (currentStep === "pedir_duracion") {
    const duracion = parseInt(userInput);
    if (isNaN(duracion) || duracion < 1) {
      return "❌ Por favor ingresa un número válido de horas.";
    }

    // Recuperar todos los datos
    const clubNombre = await getDraftData(pool, phoneNumber, "club_nombre");
    const horario = await getDraftData(pool, phoneNumber, "horario");
    const numJugadores = await getDraftData(pool, phoneNumber, "num_jugadores");

    // Limpiar draft
    await clearFlow(pool, phoneNumber);

    return `✅ *Reserva Confirmada* ✅

● Club: ${clubNombre}
● Hora: ${horario}
● Duración: ${duracion} hora${duracion > 1 ? 's' : ''}
● Jugadores: ${numJugadores} persona${numJugadores > 1 ? 's' : ''}

_NOTA: Esta es una DEMO. No se ha guardado ninguna reserva real en la base de datos._

${menuPrincipal()}`;
  }
}

/**
 * Flujo 2: Buscar Clubs Cercanos
 */
async function handleFlujoBuscarClubs(pool, phoneNumber, userInput, currentStep, draft) {
  // PASO 1: Pedir ubicación
  if (currentStep === "inicio") {
    await setFlow(pool, phoneNumber, "buscar_clubs", "pedir_ubicacion");
    return "¿En qué ciudad te encuentras? (Ejemplo: Ciudad de México, Querétaro)";
  }

  // PASO 2: Buscar clubs y mostrar resultados
  if (currentStep === "pedir_ubicacion") {
    // Consultar clubs en esa ubicación (DEMO)
    const [clubs] = await pool.query(
      `SELECT fc.fc_nombre, d.calle, d.num_ext, d.colonia, d.cp, d.estado
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE d.estado LIKE ? AND fc.id_status = 1
       LIMIT 5`,
      [`%${userInput}%`]
    );

    await clearFlow(pool, phoneNumber);

    if (clubs.length === 0) {
      return `❌ No encontré clubs cerca de *${userInput}*.

${menuPrincipal()}`;
    }

    let response = `He encontrado estos clubs cerca de tu ubicación en *${userInput}*:\n\n`;
    clubs.forEach((club, idx) => {
      response += `${idx + 1}️⃣ *${club.fc_nombre}*\n`;
      response += `   📍 ${club.calle || 'Dirección no disponible'} ${club.num_ext || ''}, ${club.colonia || ''}, CP ${club.cp || ''}\n\n`;
    });

    response += `\n${menuPrincipal()}`;
    return response;
  }
}

/**
 * Flujo 3: Información de un Club
 */
async function handleFlujoInfoClub(pool, phoneNumber, userInput, currentStep, draft) {
  // PASO 1: Pedir nombre del club
  if (currentStep === "inicio") {
    await setFlow(pool, phoneNumber, "info_club", "pedir_nombre");
    return "¿Qué club te interesa? Escribe el nombre del club.";
  }

  // PASO 2: Buscar información del club
  if (currentStep === "pedir_nombre") {
    // Buscar club por nombre (DEMO)
    const [clubs] = await pool.query(
      `SELECT fc.id_fraccionamientoclub, fc.fc_nombre, 
              d.calle, d.num_ext, d.colonia, d.cp, d.estado,
              (SELECT COUNT(*) FROM canchas c WHERE c.id_fraccionamientoclub = fc.id_fraccionamientoclub AND c.id_status = 1) as num_canchas
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE fc.fc_nombre LIKE ? AND fc.id_status = 1
       LIMIT 1`,
      [`%${userInput}%`]
    );

    if (clubs.length === 0) {
      await clearFlow(pool, phoneNumber);
      return `❌ No encontré información sobre *${userInput}*.

${menuPrincipal()}`;
    }

    const club = clubs[0];

    // Obtener horarios (DEMO)
    const [horarios] = await pool.query(
      `SELECT dia, hora_inicio, hora_fin 
       FROM horarios_club 
       WHERE id_fraccionamientoclub = ? AND estatus = 1
       ORDER BY FIELD(dia, 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')`,
      [club.id_fraccionamientoclub]
    );

    await saveDraftData(pool, phoneNumber, "club_info", club);
    await setFlow(pool, phoneNumber, "info_club", "menu_info");

    let response = `🎾 *${club.fc_nombre}* 🎾\n\n`;
    response += `📍 *Ubicación:*\n${club.calle} ${club.num_ext}, ${club.colonia}\nCP ${club.cp}, ${club.estado}\n\n`;
    response += `🏟️ *Canchas disponibles:* ${club.num_canchas}\n\n`;
    
    if (horarios.length > 0) {
      response += `⏰ *Horarios:*\n`;
      horarios.forEach(h => {
        response += `   ${h.dia}: ${h.hora_inicio.substring(0, 5)} - ${h.hora_fin.substring(0, 5)}\n`;
      });
    }

    response += `\n¿Qué deseas saber más?\n\n`;
    response += `1️⃣ Hacer una reservación\n`;
    response += `2️⃣ Volver al menú principal\n`;

    return response;
  }

  // PASO 3: Menú de opciones
  if (currentStep === "menu_info") {
    if (userInput === "1") {
      // Iniciar flujo de reservas con el club preseleccionado
      const clubInfo = await getDraftData(pool, phoneNumber, "club_info");
      await saveDraftData(pool, phoneNumber, "club_id", clubInfo.id_fraccionamientoclub);
      await saveDraftData(pool, phoneNumber, "club_nombre", clubInfo.fc_nombre);
      await setFlow(pool, phoneNumber, "reservas", "pedir_jugadores");
      
      return `Perfecto, reservaremos en *${clubInfo.fc_nombre}*.\n\n¿Para cuántas personas será la reserva? (Ejemplo: 4 jugadores)`;
    } else if (userInput === "2") {
      await clearFlow(pool, phoneNumber);
      return menuPrincipal();
    } else {
      return "❌ Opción inválida. Por favor elige 1 o 2.";
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
    return `Entiendo, vamos a revisar tu problema. Por favor selecciona:

1️⃣ ¿El club aparece como no disponible?
2️⃣ ¿El sistema te marca error al confirmar?
3️⃣ ¿Tu pago no se procesó?
4️⃣ Otro problema`;
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
        response = `⚠️ *Error al confirmar*

El error puede deberse a:
● Conexión inestable
● Disponibilidad del horario

Te recomiendo:
● Intentar nuevamente en 5 minutos
● Verificar tu conexión a internet

_NOTA DEMO: En un sistema real, aquí se levantaría un ticket de soporte._`;
        await clearFlow(pool, phoneNumber);
        response += `\n\n${menuPrincipal()}`;
        break;
        
      case "3":
        response = `💳 *Problema con pago*

Para problemas de pago, necesitas contactar directamente con el club o con soporte.

_NOTA DEMO: En un sistema real, aquí se levantaría un ticket de soporte y se solicitarían más detalles._`;
        await clearFlow(pool, phoneNumber);
        response += `\n\n${menuPrincipal()}`;
        break;
        
      case "4":
        await setFlow(pool, phoneNumber, "problemas", "pedir_descripcion");
        response = "Por favor describe tu problema en un mensaje:";
        break;
        
      default:
        response = "❌ Opción inválida. Por favor elige un número del 1 al 4.";
    }
    
    return response;
  }

  // PASO 3: Opciones después de "no disponible"
  if (currentStep === "opciones_no_disponible") {
    if (userInput === "1") {
      await setFlow(pool, phoneNumber, "reservas", "pedir_ciudad");
      return "¿En qué ciudad quieres buscar clubs? (Ejemplo: Querétaro, Puebla)";
    } else {
      await clearFlow(pool, phoneNumber);
      return menuPrincipal();
    }
  }

  // PASO 4: Capturar descripción de "otro problema"
  if (currentStep === "pedir_descripcion") {
    await clearFlow(pool, phoneNumber);
    return `✅ Hemos registrado tu problema:

"${userInput}"

_NOTA DEMO: En un sistema real, esto se guardaría como un ticket de soporte._

${menuPrincipal()}`;
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

      // Solo procesa mensajes de tipo texto
      if (!msg || msg.type !== "text") {
        return res.sendStatus(200);
      }

      const userInput = msg.text.body.trim();
      const pool = getPool(cfg);

      // =========================================================
      // 🎯 ROUTER CENTRAL - Procesamiento de mensajes
      // =========================================================

      let responseText = "";

      // 1. REINICIAR FLUJO: "Hola" o "Cancelar"
      if (userInput.toLowerCase() === "hola" || userInput.toLowerCase() === "cancelar") {
        await clearFlow(pool, from);
        responseText = menuPrincipal();
      } else {
        // 2. LEER ESTADO ACTUAL
        const draft = await getDraft(pool, from);

        // 3. SIN FLUJO ACTIVO: Mostrar menú principal y procesar selección
        if (!draft || !draft.flow || draft.step === "menu") {
          if (userInput === "1") {
            await setFlow(pool, from, "reservas", "inicio");
            responseText = await handleFlujoReservas(pool, from, userInput, "inicio", draft);
          } else if (userInput === "2") {
            await setFlow(pool, from, "buscar_clubs", "inicio");
            responseText = await handleFlujoBuscarClubs(pool, from, userInput, "inicio", draft);
          } else if (userInput === "3") {
            await setFlow(pool, from, "info_club", "inicio");
            responseText = await handleFlujoInfoClub(pool, from, userInput, "inicio", draft);
          } else if (userInput === "4") {
            await setFlow(pool, from, "problemas", "inicio");
            responseText = await handleFlujoProblemas(pool, from, userInput, "inicio", draft);
          } else {
            responseText = menuPrincipal();
          }
        } else {
          // 4. ENRUTAR A FLUJO ESPECÍFICO
          switch (draft.flow) {
            case "reservas":
              responseText = await handleFlujoReservas(pool, from, userInput, draft.step, draft);
              break;

            case "buscar_clubs":
              responseText = await handleFlujoBuscarClubs(pool, from, userInput, draft.step, draft);
              break;

            case "info_club":
              responseText = await handleFlujoInfoClub(pool, from, userInput, draft.step, draft);
              break;

            case "problemas":
              responseText = await handleFlujoProblemas(pool, from, userInput, draft.step, draft);
              break;

            default:
              await clearFlow(pool, from);
              responseText = "Error: flujo no reconocido. Volviendo al menú principal.\n\n" + menuPrincipal();
          }
        }
      }

      // Enviar respuesta al usuario
      await sendWhatsAppText({
        to: from,
        token,
        phoneNumberId,
        text: responseText,
      });

      return res.sendStatus(200);
    } catch (err) {
      // Manejo de errores y log detallado
      logger.error("Error webhook:", err?.response?.data || err);
      return res.sendStatus(200);
    }
  }
);