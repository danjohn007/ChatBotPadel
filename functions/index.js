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
  await axios.post(
    url,
    {
      messaging_product: "whatsapp",
      to,
      type: "interactive",
      interactive: {
        type: "list",
        header: {
          type: "text",
          text: headerText,
        },
        body: {
          text: bodyText,
        },
        action: {
          button: buttonText,
          sections: sections,
        },
      },
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
        text: "❌ No hay ciudades disponibles en este momento.\n\n" + menuPrincipal(),
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
      headerText: "🏙️ Ciudades Disponibles",
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
        text: "❌ Selección inválida. Por favor selecciona una ciudad de la lista.",
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
        text: `❌ No encontré clubs disponibles en *${ciudadSeleccionada}*.\n\n${menuPrincipal()}`,
      };
    }

    // Guardar clubs encontrados
    await saveDraftData(pool, phoneNumber, "clubs_disponibles", clubs);
    await setFlow(pool, phoneNumber, "reservas", "seleccionar_club");

    // Crear lista interactiva de clubs
    const rows = clubs.map((club, idx) => ({
      id: `club_${idx}`,
      title: club.fc_nombre.substring(0, 24), // WhatsApp limita a 24 chars
      description: club.colonia ? `📍 ${club.colonia.substring(0, 72)}` : "Club de pádel",
    }));

    return {
      type: "list",
      headerText: `🏟️ Clubs en ${ciudadSeleccionada}`,
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
          text: "❌ Selección inválida. Por favor selecciona un club de la lista.",
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
      headerText: `⏰ Horarios Disponibles`,
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
        text: "❌ Selección inválida. Por favor selecciona un horario de la lista.",
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
        text: "❌ Por favor ingresa un número válido de jugadores (mínimo 2).",
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
        text: "❌ Por favor ingresa un número válido de horas (ejemplo: 1, 2, 3).",
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
      text: `✅ *Reserva Confirmada* ✅

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
  // PASO 1: Pedir ubicación
  if (currentStep === "inicio") {
    await setFlow(pool, phoneNumber, "buscar_clubs", "pedir_ubicacion");
    return {
      type: "text",
      text: "¿En qué ciudad te encuentras? (Ejemplo: Ciudad de México, Querétaro)",
    };
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
      return { type: "text", text: `❌ No encontré clubs cerca de *${userInput}*.\n\n${menuPrincipal()}` };
    }

    let text = `He encontrado estos clubs cerca de tu ubicación en *${userInput}*:\n\n`;
    clubs.forEach((club, idx) => {
      text += `${idx + 1}️⃣ *${club.fc_nombre}*\n`;
      text += `   📍 ${club.calle || 'Dirección no disponible'} ${club.num_ext || ''}, ${club.colonia || ''}, CP ${club.cp || ''}\n\n`;
    });

    text += `\n${menuPrincipal()}`;
    return { type: "text", text };
  }
}

/**
 * Flujo 3: Información de un Club
 */
async function handleFlujoInfoClub(pool, phoneNumber, userInput, currentStep, draft, token, phoneNumberId) {
  // PASO 1: Mostrar lista de clubes disponibles
  if (currentStep === "inicio") {
    // Obtener página actual (default: 0)
    const offset = (await getDraftData(pool, phoneNumber, "clubs_offset")) || 0;
    const limit = 9;

    // Consultar todos los clubes disponibles
    const [clubs] = await pool.query(
      `SELECT fc.id_fraccionamientoclub, fc.fc_nombre, 
              d.estado, d.colonia
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE fc.id_status = 1
       ORDER BY fc.fc_nombre
       LIMIT ? OFFSET ?`,
      [limit + 1, offset] // +1 para saber si hay más
    );

    if (clubs.length === 0) {
      await clearFlow(pool, phoneNumber);
      return {
        type: "text",
        text: `❌ No hay clubes disponibles en este momento.\n\n${menuPrincipal()}`,
      };
    }

    const hayMas = clubs.length > limit;
    const clubsMostrar = clubs.slice(0, limit);

    await saveDraftData(pool, phoneNumber, "clubs_lista", clubsMostrar);
    await setFlow(pool, phoneNumber, "info_club", "seleccionar_club");

    // Crear filas para la lista
    const rows = clubsMostrar.map((club, idx) => ({
      id: `club_info_${idx}`,
      title: club.fc_nombre.substring(0, 24), // Max 24 caracteres
      description: `📍 ${club.colonia}, ${club.estado}`.substring(0, 72),
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
      bodyText: "Selecciona el club del que deseas ver información:",
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

    const clubSeleccionado = clubsLista[index];

    // Obtener información completa del club
    const [clubs] = await pool.query(
      `SELECT fc.id_fraccionamientoclub, fc.fc_nombre, 
              d.calle, d.num_ext, d.colonia, d.cp, d.estado,
              (SELECT COUNT(*) FROM canchas c WHERE c.id_fraccionamientoclub = fc.id_fraccionamientoclub AND c.id_status = 1) as num_canchas
       FROM fraccionamiento_club fc
       INNER JOIN direccion d ON fc.id_direccion = d.id_direccion
       WHERE fc.id_fraccionamientoclub = ?`,
      [clubSeleccionado.id_fraccionamientoclub]
    );

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
    await saveDraftData(pool, phoneNumber, "clubs_offset", 0); // Reset offset
    await setFlow(pool, phoneNumber, "info_club", "menu_info");

    let text = `🎾 *${club.fc_nombre}* 🎾\n\n`;
    text += `📍 *Ubicación:*\n${club.calle || 'N/A'} ${club.num_ext || ''}, ${club.colonia || 'N/A'}\nCP ${club.cp || 'N/A'}, ${club.estado || 'N/A'}\n\n`;
    text += `🏟️ *Canchas disponibles:* ${club.num_canchas || 0}\n\n`;
    
    if (horarios.length > 0) {
      text += `⏰ *Horarios:*\n`;
      horarios.forEach(h => {
        text += `   ${h.dia}: ${h.hora_inicio.substring(0, 5)} - ${h.hora_fin.substring(0, 5)}\n`;
      });
    }

    text += `\n¿Qué deseas hacer?\n\n`;
    text += `1️⃣ Hacer una reservación\n`;
    text += `2️⃣ Volver al menú principal\n`;

    return { type: "text", text };
  }

  // PASO 3: Menú de opciones
  if (currentStep === "menu_info") {
    if (userInput === "1") {
      // Iniciar flujo de reservas con el club preseleccionado
      const clubInfo = await getDraftData(pool, phoneNumber, "club_info");
      await saveDraftData(pool, phoneNumber, "club_id", clubInfo.id_fraccionamientoclub);
      await saveDraftData(pool, phoneNumber, "club_nombre", clubInfo.fc_nombre);
      
      // Cambiar a flujo de reservas y mostrar horarios directamente
      await setFlow(pool, phoneNumber, "reservas", "seleccionar_club");
      
      // Simular que viene desde seleccionar_club con el club ya elegido
      // Llamar recursivamente al flujo de reservas con un input especial
      return await handleFlujoReservas(pool, phoneNumber, `club_preseleccionado_${clubInfo.id_fraccionamientoclub}`, "seleccionar_club", {
        ...draft,
        data: {
          ...draft.data,
          club_id: clubInfo.id_fraccionamientoclub,
          club_nombre: clubInfo.fc_nombre
        }
      }, token, phoneNumberId);
    } else if (userInput === "2") {
      await clearFlow(pool, phoneNumber);
      return { type: "text", text: menuPrincipal() };
    } else {
      return { type: "text", text: "❌ Opción inválida. Por favor elige 1 o 2." };
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
      return {
        type: "text",
        text: menuPrincipal(),
      };
    }
  }

  // PASO 4: Capturar descripción de "otro problema"
  if (currentStep === "pedir_descripcion") {
    await clearFlow(pool, phoneNumber);
    return {
      type: "text",
      text: `✅ Hemos registrado tu problema:

"${userInput}"

_NOTA DEMO: En un sistema real, esto se guardaría como un ticket de soporte._

${menuPrincipal()}`,
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

      // Procesa mensajes de texto o interactivos
      let userInput = "";
      if (msg.type === "text") {
        userInput = msg.text.body.trim();
      } else if (msg.type === "interactive") {
        // Mensajes de respuesta a listas o botones interactivos
        userInput = msg.interactive?.list_reply?.id || msg.interactive?.button_reply?.id || "";
      } else {
        return res.sendStatus(200);
      }

      const pool = getPool(cfg);

      // =========================================================
      // 🎯 ROUTER CENTRAL - Procesamiento de mensajes
      // =========================================================

      let response = null;

      // 1. REINICIAR FLUJO: "Hola" o "Cancelar"
      if (userInput.toLowerCase() === "hola" || userInput.toLowerCase() === "cancelar") {
        await clearFlow(pool, from);
        response = { type: "text", text: menuPrincipal() };
      } else {
        // 2. LEER ESTADO ACTUAL
        const draft = await getDraft(pool, from);

        // 3. SIN FLUJO ACTIVO: Mostrar menú principal y procesar selección
        if (!draft || !draft.flow || draft.step === "menu") {
          if (userInput === "1") {
            await setFlow(pool, from, "reservas", "inicio");
            response = await handleFlujoReservas(pool, from, userInput, "inicio", draft, token, phoneNumberId);
          } else if (userInput === "2") {
            await setFlow(pool, from, "buscar_clubs", "inicio");
            response = await handleFlujoBuscarClubs(pool, from, userInput, "inicio", draft);
          } else if (userInput === "3") {
            await setFlow(pool, from, "info_club", "inicio");
            response = await handleFlujoInfoClub(pool, from, userInput, "inicio", draft, token, phoneNumberId);
          } else if (userInput === "4") {
            await setFlow(pool, from, "problemas", "inicio");
            response = await handleFlujoProblemas(pool, from, userInput, "inicio", draft);
          } else {
            response = { type: "text", text: menuPrincipal() };
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

            default:
              await clearFlow(pool, from);
              response = { type: "text", text: "Error: flujo no reconocido. Volviendo al menú principal.\n\n" + menuPrincipal() };
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
      }

      return res.sendStatus(200);
    } catch (err) {
      // Manejo de errores y log detallado
      logger.error("Error webhook:", err?.response?.data || err);
      return res.sendStatus(200);
    }
  }
);