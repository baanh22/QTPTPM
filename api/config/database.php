<?php
// Cấu hình CORS để Frontend có thể gọi API
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=UTF-8');

// Xử lý preflight OPTIONS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

session_start();

$host = "db";             // Tên service MySQL trong docker-compose
$dbname = "QuanLyNhaSach";
$username = "root";       // Dùng root hoặc quanlyuser
$password = "rootpassword"; // Mật khẩu tương ứng (rootpassword hoặc quanlypass)

try {
    // Đã sửa: $db -> $dbname | $user -> $username | $pass -> $password
    $conn = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Lỗi kết nối cơ sở dữ liệu: ' . $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

// Hàm tiện ích trả về JSON
function json_response($data, $code = 200) {
    http_response_code($code);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function json_success($data = [], $message = 'Thành công') {
    json_response(['success' => true, 'message' => $message, 'data' => $data]);
}

function json_error($message = 'Có lỗi xảy ra', $code = 400) {
    json_response(['success' => false, 'message' => $message], $code);
}
?>