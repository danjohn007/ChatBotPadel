<?php
/**
 * Endpoint para recibir imágenes de tickets desde WhatsApp
 * Ruta: https://arosports.app/api/api/uploads/tickets
 * Método: POST
 * Content-Type: multipart/form-data
 */

// Configuración de headers
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Manejar solicitudes OPTIONS (preflight CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Solo permitir método POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'error' => 'Método no permitido. Use POST'
    ]);
    exit;
}

// Configuración del directorio de uploads
// Asegúrate de que esta ruta sea correcta en tu servidor
$uploadDir = __DIR__ . '/';  // Guarda en el mismo directorio donde está este PHP

// Crear directorio si no existe
if (!file_exists($uploadDir)) {
    if (!mkdir($uploadDir, 0755, true)) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'No se pudo crear el directorio de uploads'
        ]);
        exit;
    }
}

// Log de la solicitud (opcional, para debugging)
$logFile = $uploadDir . 'upload_log.txt';
$logMessage = date('Y-m-d H:i:s') . " - Nueva solicitud de upload\n";
file_put_contents($logFile, $logMessage, FILE_APPEND);

try {
    // Validar que se recibió un archivo
    if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
        throw new Exception('No se recibió ningún archivo válido');
    }

    $file = $_FILES['file'];
    $ticketId = isset($_POST['ticket_id']) ? intval($_POST['ticket_id']) : 0;

    // Log de información del archivo
    $logMessage = "Archivo recibido: " . $file['name'] . " | Tamaño: " . $file['size'] . " bytes | Ticket ID: $ticketId\n";
    file_put_contents($logFile, $logMessage, FILE_APPEND);

    // Validar que es una imagen
    $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    $fileType = strtolower($file['type']);
    
    if (!in_array($fileType, $allowedTypes)) {
        throw new Exception('Tipo de archivo no permitido. Solo se permiten imágenes (JPG, PNG, GIF, WEBP)');
    }

    // Validar tamaño (máximo 10MB)
    $maxSize = 10 * 1024 * 1024; // 10MB en bytes
    if ($file['size'] > $maxSize) {
        throw new Exception('El archivo es demasiado grande. Tamaño máximo: 10MB');
    }

    // Validar que el archivo temporal existe
    if (!is_uploaded_file($file['tmp_name'])) {
        throw new Exception('Error en la carga del archivo');
    }

    // Usar el nombre original del archivo que viene del chatbot
    $filename = basename($file['name']);
    
    // Sanitizar el nombre del archivo por seguridad
    $filename = preg_replace('/[^a-zA-Z0-9_\-\.]/', '_', $filename);
    
    $filepath = $uploadDir . $filename;

    // Mover archivo al directorio de uploads
    if (!move_uploaded_file($file['tmp_name'], $filepath)) {
        throw new Exception('Error al guardar el archivo en el servidor');
    }

    // Verificar que el archivo se guardó correctamente
    if (!file_exists($filepath)) {
        throw new Exception('El archivo no se guardó correctamente');
    }

    // Log de éxito
    $logMessage = "✅ Archivo guardado exitosamente: $filename\n";
    file_put_contents($logFile, $logMessage, FILE_APPEND);

    // Construir la ruta relativa para guardar en la BD
    $relativePath = 'uploads/tickets/' . $filename;
    
    // Construir la URL completa de la imagen
    $imageUrl = 'https://arosports.app/api/api/uploads/tickets/' . $filename;

    // Respuesta exitosa
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'filepath' => $relativePath,
        'filename' => $filename,
        'url' => $imageUrl,
        'size' => filesize($filepath),
        'ticket_id' => $ticketId
    ]);

} catch (Exception $e) {
    // Log de error
    $logMessage = "❌ Error: " . $e->getMessage() . "\n";
    file_put_contents($logFile, $logMessage, FILE_APPEND);
    
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>
