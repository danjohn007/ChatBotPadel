# 🤖 Chatbot de Soporte Técnico - AroSport Padel

## 📋 Descripción

Chatbot conversacional de WhatsApp que ayuda a los usuarios a:
- Reservar canchas de pádel
- Buscar clubs cercanos
- Obtener información de clubs específicos
- Reportar problemas con reservas

**MODO DEMO**: El chatbot solo **LEE** la base de datos, **NO GUARDA** ninguna información.

---

## 🎯 Flujos Implementados

### 1️⃣ Reservar Cancha
**Flujo completo paso a paso:**
1. Usuario selecciona opción "1"
2. Bot pregunta: ¿En qué ciudad?
3. Usuario responde: "Querétaro"
4. Bot pregunta: ¿A qué hora?
5. Usuario responde: "7pm"
6. Bot muestra clubs disponibles en esa ciudad
7. Usuario selecciona un club (1, 2, 3...)
8. Bot pregunta: ¿Cuántos jugadores?
9. Usuario responde: "4"
10. Bot pregunta: ¿Cuántas horas?
11. Usuario responde: "2"
12. Bot confirma la reserva (DEMO - no se guarda)

### 2️⃣ Buscar Clubs Cercanos
**Flujo:**
1. Usuario selecciona opción "2"
2. Bot pregunta: ¿En qué ciudad estás?
3. Usuario responde: "Ciudad de México"
4. Bot muestra lista de clubs con direcciones
5. Vuelve al menú principal

### 3️⃣ Información de un Club
**Flujo:**
1. Usuario selecciona opción "3"
2. Bot pregunta: ¿Qué club te interesa?
3. Usuario responde: "The Club"
4. Bot muestra:
   - Dirección completa
   - Número de canchas
   - Horarios de operación
5. Bot ofrece opciones:
   - Hacer una reservación (lleva al flujo 1 con club preseleccionado)
   - Volver al menú

### 4️⃣ Problemas con Reservas
**Flujo:**
1. Usuario selecciona opción "4"
2. Bot muestra menú de problemas comunes:
   - Club no disponible
   - Error al confirmar
   - Pago no procesado
   - Otro problema
3. Bot ofrece soluciones según el problema
4. En un sistema real, levantaría tickets de soporte

---

## 🔄 Comandos Especiales

### "Hola"
- Reinicia completamente el flujo
- Limpia todos los datos temporales
- Muestra el menú principal

### "Cancelar"
- Cancela el flujo actual
- Limpia datos temporales
- Vuelve al menú principal
- Funciona en **cualquier momento** de la conversación

---

## 🗄️ Arquitectura Técnica

### Sistema de Estados (User Drafts)
Cada usuario tiene un registro en la tabla `user_drafts` con estructura JSON:

```json
{
  "flow": "reservas",
  "step": "pedir_horario",
  "user": {
    "phone": "5214421234567"
  },
  "data": {
    "ciudad": "Querétaro",
    "horario": "7pm",
    "clubs_disponibles": [...]
  }
}
```

### Flujos y Pasos

| Flujo | Pasos |
|-------|-------|
| **reservas** | inicio → pedir_ciudad → pedir_horario → seleccionar_club → pedir_jugadores → pedir_duracion |
| **buscar_clubs** | inicio → pedir_ubicacion |
| **info_club** | inicio → pedir_nombre → menu_info |
| **problemas** | inicio → seleccionar_problema → [diversos sub-pasos] |

---

## 📊 Tablas de Base de Datos Consultadas

El chatbot **solo lee** de estas tablas:

- `fraccionamiento_club`: Información de clubs
- `direccion`: Ubicaciones y coordenadas
- `canchas`: Canchas disponibles por club
- `horarios_club`: Horarios de operación
- `user_drafts`: Estado conversacional (read/write)

---

## 🚀 Despliegue

### Prerequisitos
1. Tabla `user_drafts` creada en la base de datos
2. Secrets configurados en Firebase:
   - `VERIFY_TOKEN_PADEL`
   - `WHATSAPP_TOKEN_PADEL`
   - `WHATSAPP_PHONE_NUMBER_ID_PADEL`
   - `DB_HOST_PADEL`
   - `DB_USER_PADEL`
   - `DB_PASSWORD_PADEL`
   - `DB_NAME_PADEL`

### Comandos
```bash
cd functions
npm install
firebase deploy --only functions
```

---

## 🧪 Ejemplo de Conversación Completa

```
Usuario: Hola
Bot: 🎾 Bienvenido a AroSport Padel 🎾
     ¿En qué puedo ayudarte hoy?
     1️⃣ Reservar cancha
     2️⃣ Buscar clubs cercanos
     3️⃣ Información de un club
     4️⃣ Problemas con reservas

Usuario: 1
Bot: ¿En qué ciudad quieres jugar?

Usuario: Querétaro
Bot: ¿A qué hora quieres jugar?

Usuario: 7pm
Bot: He encontrado 3 clubs disponibles en Querétaro:
     1️⃣ THE CLUB PADEL & ACADEMY
     2️⃣ The Club ID
     3️⃣ ClubPF
     ● Elige el número del club donde quieras reservar.

Usuario: 1
Bot: Perfecto, seleccionaste THE CLUB PADEL & ACADEMY.
     ¿Para cuántas personas será la reserva?

Usuario: 4
Bot: Genial, la reserva será para 4 personas.
     ¿Por cuántas horas deseas reservar la cancha?

Usuario: 2
Bot: ✅ Reserva Confirmada ✅
     ● Club: THE CLUB PADEL & ACADEMY
     ● Hora: 7pm
     ● Duración: 2 horas
     ● Jugadores: 4 personas
     
     NOTA: Esta es una DEMO. No se ha guardado ninguna reserva real.
     
     [Menú Principal]
```

### Ejemplo de Cancelación

```
Usuario: 1
Bot: ¿En qué ciudad quieres jugar?

Usuario: Querétaro
Bot: ¿A qué hora quieres jugar?

Usuario: Cancelar
Bot: [Muestra menú principal - datos descartados]
```

---

## 🔍 Debugging

### Ver estado de un usuario
```sql
SELECT * FROM user_drafts WHERE phone_number = '5214421234567';
```

### Limpiar estado manualmente
```sql
DELETE FROM user_drafts WHERE phone_number = '5214421234567';
```

### Verificar logs en Firebase
```bash
firebase functions:log
```

---

## ✅ Características Implementadas

- ✅ Sistema de estados persistentes con User Drafts
- ✅ 4 flujos conversacionales completos
- ✅ Reinicio con "Hola" y "Cancelar"
- ✅ Navegación por números (1, 2, 3, 4)
- ✅ Validaciones de entrada
- ✅ Consultas a base de datos (solo lectura)
- ✅ Manejo de errores robusto
- ✅ Mensajes formatados con emojis
- ✅ Pool de conexiones MySQL optimizado

---

## 📝 Notas Importantes

1. **Modo DEMO**: No se guardan reservas reales ni tickets de soporte
2. **Solo lectura**: El chatbot solo consulta, no modifica la BD (excepto user_drafts)
3. **Stateless**: Cada mensaje consulta el estado desde la BD
4. **Escalable**: Funciona con múltiples instancias de Firebase Functions
5. **Persistente**: Los usuarios pueden volver días después y continuar donde quedaron

---

## 🔜 Mejoras Futuras (Fuera de DEMO)

- [ ] Guardar reservas reales en la tabla `reservas`
- [ ] Sistema de tickets de soporte
- [ ] Autenticación de usuarios
- [ ] Envío de confirmaciones por correo
- [ ] Integración con sistema de pagos
- [ ] Recordatorios automáticos de reservas
- [ ] Cancelación de reservas
- [ ] Historial de reservas del usuario
