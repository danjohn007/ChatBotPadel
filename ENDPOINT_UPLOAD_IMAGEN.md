# 📤 Endpoint Requerido para Subir Imágenes de Tickets

El chatbot ahora descarga las imágenes de WhatsApp y las sube a tu servidor. Necesitas crear un endpoint en tu backend de AroSports.

## 🎯 Endpoint Necesario

**URL:** `https://arosports.app/api/upload-ticket-attachment`  
**Método:** `POST`  
**Content-Type:** `multipart/form-data`

### 📥 Datos que Recibe

```javascript
{
  file: File,           // Archivo de imagen (JPG, PNG, GIF, WEBP)
  ticket_id: Number     // ID del ticket al que pertenece la imagen
}
```

### 📤 Respuesta Esperada

**Éxito (200):**
```json
{
  "success": true,
  "filepath": "uploads/tickets/698a1909c75c0_AB33308.jpg",
  "filename": "698a1909c75c0_AB33308.jpg",
  "url": "https://arosports.app/api/uploads/tickets/698a1909c75c0_AB33308.jpg"
}
```

**Error (400/500):**
```json
{
  "success": false,
  "error": "Descripción del error"
}
```

## 🔧 Ejemplo de Implementación (Node.js/Express)

```javascript
const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();

// Configurar multer para guardar en uploads/tickets/
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const dir = './uploads/tickets/';
    
    // Crear directorio si no existe
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    
    cb(null, dir);
  },
  filename: function (req, file, cb) {
    // Mantener el nombre original del archivo
    cb(null, file.originalname);
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // Máximo 10MB
  },
  fileFilter: function (req, file, cb) {
    // Validar que sea una imagen
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Tipo de archivo no permitido'));
    }
  }
});

// Endpoint para subir imagen
app.post('/api/upload-ticket-attachment', upload.single('file'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No se recibió ningún archivo'
      });
    }

    const filepath = `uploads/tickets/${req.file.filename}`;
    
    console.log(`✅ Imagen guardada: ${filepath}`);
    
    res.json({
      success: true,
      filepath: filepath,
      filename: req.file.filename,
      url: `https://arosports.app/api/${filepath}`
    });
    
  } catch (error) {
    console.error('Error al subir archivo:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

app.listen(3000, () => {
  console.log('Servidor corriendo en puerto 3000');
});
```

## 🔧 Ejemplo de Implementación (PHP/Laravel)

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TicketAttachmentController extends Controller
{
    public function upload(Request $request)
    {
        try {
            // Validar el archivo
            $request->validate([
                'file' => 'required|image|mimes:jpeg,png,jpg,gif,webp|max:10240', // Max 10MB
                'ticket_id' => 'required|integer'
            ]);

            $file = $request->file('file');
            $ticketId = $request->input('ticket_id');

            // Generar nombre del archivo (mantener el nombre original)
            $filename = $file->getClientOriginalName();

            // Guardar en public/uploads/tickets/
            $path = $file->storeAs('uploads/tickets', $filename, 'public');

            return response()->json([
                'success' => true,
                'filepath' => $path,
                'filename' => $filename,
                'url' => url('storage/' . $path)
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
```

**Ruta en `routes/api.php`:**
```php
Route::post('/upload-ticket-attachment', [TicketAttachmentController::class, 'upload']);
```

## 📋 Checklist de Implementación

- [ ] Crear el endpoint `POST /api/upload-ticket-attachment`
- [ ] Configurar multer o el equivalente para recibir archivos
- [ ] Crear el directorio `uploads/tickets/` si no existe
- [ ] Guardar el archivo con el nombre que viene del chatbot
- [ ] Retornar la respuesta JSON con `filepath`
- [ ] Probar el endpoint con Postman o curl

## 🧪 Probar el Endpoint

```bash
curl -X POST https://arosports.app/api/upload-ticket-attachment \
  -F "file=@imagen.jpg" \
  -F "ticket_id=123"
```

## 🔒 Seguridad (Recomendaciones)

1. **Validar tipo de archivo:** Solo permitir imágenes
2. **Límite de tamaño:** Máximo 10MB
3. **Sanitizar nombres:** Evitar caracteres especiales
4. **Autenticación:** Opcional, pero recomendado con API key
5. **Escanear virus:** Considerar escaneo de malware

## ❓ Problemas Comunes

### Error: "Cannot read property 'filepath' of undefined"
→ El endpoint no está devolviendo `filepath` en la respuesta

### Error: "ENOENT: no such file or directory"
→ El directorio `uploads/tickets/` no existe, créalo manualmente

### Error: "File too large"
→ Aumentar el límite de tamaño en multer o PHP

---

Una vez implementado el endpoint, el chatbot funcionará así:

1. Usuario envía imagen por WhatsApp ✅
2. Chatbot descarga imagen de WhatsApp ✅
3. Chatbot sube imagen a tu servidor ✅
4. Tu servidor guarda en `uploads/tickets/` ✅
5. Tu servidor retorna la ruta ✅
6. Chatbot guarda ruta en la BD ✅
