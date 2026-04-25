<?php
/**
 * Endpoint para recibir imágenes de tickets desde WhatsApp
 * 
 * INSTRUCCIONES DE INSTALACIÓN:
 * 1. Sube este archivo a tu servidor dentro de la ruta de tu API, por ejemplo:
 *       /public_html/api/api/uploads/tickets/upload.php
 *    O bien, configura tu router para que POST /api/api/uploads/tickets apunte aquí.
 *
 * 2. Ajusta las dos constantes de configuración:
 *       UPLOAD_DIR  → ruta absoluta en el servidor donde se guardarán las imágenes
 *       BASE_URL    → URL pública base de esa carpeta
 *
 * 3. Asegúrate de que la carpeta UPLOAD_DIR tenga permisos de escritura (chmod 755 o 775).
 *
 * Método: POST
 * Content-Type: multipart/form-data
 * Campos esperados:
 *   - file       : archivo de imagen (JPG, PNG, GIF, WEBP, máx 10 MB)
 *   - ticket_id  : ID del ticket (entero)
 */

// ─────────────────────────────────────────
//  CONFIGURACIÓN — ajusta estos dos valores
// ─────────────────────────────────────────

// Ruta absoluta en el servidor donde se guardarán las imágenes.
// Ejemplos:
//   '/home/tu_usuario/public_html/api/api/uploads/tickets/'
//   '/var/www/html/arosports/api/api/uploads/tickets/'
define('UPLOAD_DIR', '/home2/arosports/public_html/api/api/uploads/tickets/');

// URL pública de esa misma carpeta (sin barra al final no importa, se agrega).
define('BASE_URL', 'https://arosports.app/api/api/uploads/tickets');

// ─────────────────────────────────────────

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método no permitido. Use POST']);
    exit;
}

$uploadDir = rtrim(UPLOAD_DIR, '/') . '/';

// Crear directorio si no existe
if (!file_exists($uploadDir)) {
    if (!mkdir($uploadDir, 0755, true)) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'No se pudo crear el directorio de uploads']);
        exit;
    }
}

// Log de la solicitud (para debugging)
$logFile = $uploadDir . 'upload_log.txt';
file_put_contents($logFile, date('Y-m-d H:i:s') . " - Nueva solicitud de upload\n", FILE_APPEND);

try {
    if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
        throw new Exception('No se recibió ningún archivo válido');
    }

    $file     = $_FILES['file'];
    $ticketId = isset($_POST['ticket_id']) ? intval($_POST['ticket_id']) : 0;

    file_put_contents($logFile,
        "Archivo recibido: " . $file['name'] . " | Tamaño: " . $file['size'] . " bytes | Ticket ID: $ticketId\n",
        FILE_APPEND
    );

    // Validar tipo de archivo
    $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    if (!in_array(strtolower($file['type']), $allowedTypes)) {
        throw new Exception('Tipo de archivo no permitido. Solo se permiten imágenes (JPG, PNG, GIF, WEBP)');
    }

    // Validar tamaño (máximo 10 MB)
    if ($file['size'] > 10 * 1024 * 1024) {
        throw new Exception('El archivo es demasiado grande. Tamaño máximo: 10MB');
    }

    if (!is_uploaded_file($file['tmp_name'])) {
        throw new Exception('Error en la carga del archivo');
    }

    // Sanitizar nombre del archivo
    $filename = preg_replace('/[^a-zA-Z0-9_\-\.]/', '_', basename($file['name']));
    $filepath = $uploadDir . $filename;

    if (!move_uploaded_file($file['tmp_name'], $filepath)) {
        throw new Exception('Error al guardar el archivo en el servidor');
    }

    if (!file_exists($filepath)) {
        throw new Exception('El archivo no se guardó correctamente');
    }

    file_put_contents($logFile, "✅ Archivo guardado exitosamente: $filename\n", FILE_APPEND);

    $relativePath = 'uploads/tickets/' . $filename;
    $imageUrl     = rtrim(BASE_URL, '/') . '/' . $filename;

    http_response_code(200);
    echo json_encode([
        'success'   => true,
        'filepath'  => $relativePath,
        'filename'  => $filename,
        'url'       => $imageUrl,
        'size'      => filesize($filepath),
        'ticket_id' => $ticketId,
    ]);

} catch (Exception $e) {
    file_put_contents($logFile, "❌ Error: " . $e->getMessage() . "\n", FILE_APPEND);
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
?>
