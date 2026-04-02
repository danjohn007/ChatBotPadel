# 📤 Instrucciones de Instalación - Receptor de Imágenes

## 🎯 Objetivo
Este archivo PHP recibe las imágenes que los usuarios envían por WhatsApp y las guarda en tu servidor.

## 📋 Pasos de Instalación

### 1. Subir el archivo al servidor

Sube el archivo `upload-ticket-image.php` a tu servidor en esta ruta exacta:

```
/api/api/uploads/tickets/index.php
```

**O renómbralo según tu configuración:**
- Si tu servidor acepta `index.php` como archivo predeterminado, nómbralo así
- Si necesitas una URL específica, configura tu `.htaccess` o nginx

### 2. Estructura de carpetas en el servidor

Asegúrate de que exista esta estructura:

```
arosports.app/
└── api/
    └── api/
        └── uploads/
            └── tickets/
                └── index.php  (o upload-ticket-image.php)
```

### 3. Permisos de carpeta

Asegúrate de que la carpeta tenga permisos de escritura:

```bash
chmod 755 /api/api/uploads/tickets/
```

### 4. Configuración del .htaccess (si usas Apache)

Si necesitas que la URL funcione sin extensión `.php`, crea un archivo `.htaccess` en `/api/api/uploads/`:

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /api/api/uploads/
    
    # Redirigir requests a tickets/ al archivo PHP
    RewriteCond %{REQUEST_METHOD} POST
    RewriteRule ^tickets/?$ tickets/index.php [L]
</IfModule>

# Permitir CORS
<IfModule mod_headers.c>
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "POST, OPTIONS"
    Header set Access-Control-Allow-Headers "Content-Type"
</IfModule>
```

### 5. Verificar que funciona

Prueba el endpoint con este comando (desde tu terminal):

```bash
curl -X POST https://arosports.app/api/api/uploads/tickets \
  -F "file=@ruta/a/una/imagen.jpg" \
  -F "ticket_id=123"
```

Deberías recibir algo como:

```json
{
  "success": true,
  "filepath": "uploads/tickets/imagen_abc123.jpg",
  "filename": "imagen_abc123.jpg",
  "url": "https://arosports.app/api/api/uploads/tickets/imagen_abc123.jpg"
}
```

## 📁 ¿Dónde se guardan las imágenes?

Las imágenes se guardan en la misma carpeta donde subiste el archivo PHP:
```
/api/api/uploads/tickets/imagen1.jpg
/api/api/uploads/tickets/imagen2.jpg
...
```

## 📊 Archivo de log

El script crea automáticamente un archivo `upload_log.txt` en la misma carpeta para hacer debugging:

```
/api/api/uploads/tickets/upload_log.txt
```

Puedes revisar este archivo si algo no funciona.

## 🔧 Troubleshooting

### Error: "No se recibió ningún archivo válido"
- Verifica que el formulario esté enviando el campo `file` correctamente
- Revisa los logs de PHP: `php_error.log`

### Error: "No se pudo crear el directorio"
- Verifica los permisos de la carpeta padre
- Asegúrate de que el usuario de Apache/Nginx tenga permisos de escritura

### Error 404: "Not Found"
- Verifica que el archivo esté en la ruta correcta
- Revisa la configuración de tu servidor web (Apache/Nginx)
- Asegúrate de que `.htaccess` esté funcionando (si usas Apache)

### Las imágenes no se ven en el sistema
- Verifica que la ruta en la base de datos sea correcta
- Asegúrate de que las imágenes tengan permisos de lectura: `chmod 644 *.jpg`

## 🔐 Seguridad

El archivo ya incluye:
- ✅ Validación de tipo de archivo (solo imágenes)
- ✅ Límite de tamaño (10MB máximo)
- ✅ Sanitización de nombres de archivo
- ✅ Validación de método HTTP (solo POST)
- ✅ Headers CORS configurados

## 📞 Soporte

Si tienes problemas, revisa:
1. El archivo `upload_log.txt` en el servidor
2. Los logs de Firebase Functions (del chatbot)
3. Los logs de PHP de tu servidor

---

**¿Listo?** Una vez que hayas subido el archivo al servidor, prueba enviando una imagen por WhatsApp para verificar que todo funcione.
