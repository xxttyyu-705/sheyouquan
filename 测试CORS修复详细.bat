@echo off
echo ========================================
echo 摄友圈 - CORS修复详细测试
echo ========================================
echo.

echo 1. 启动后端服务...
cd /d backend
start "后端服务" java -jar target/shengyouquan-backend-1.0.0.jar
echo 等待后端服务启动...
timeout /t 10 /nobreak >nul

echo.
echo 2. 测试CORS预检请求（OPTIONS）...
echo 测试URL: http://localhost:8082/user/login
echo.

echo 发送OPTIONS请求测试预检...
curl -X OPTIONS http://localhost:8082/user/login ^
  -H "Origin: http://localhost:3003" ^
  -H "Access-Control-Request-Method: POST" ^
  -H "Access-Control-Request-Headers: Content-Type,Authorization" ^
  -v 2>&1 | findstr "Access-Control"

echo.
echo 3. 测试登录接口CORS...
echo 发送POST请求测试登录...
curl -X POST http://localhost:8082/user/login ^
  -H "Origin: http://localhost:3003" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"test\",\"password\":\"test123\"}" ^
  -v 2>&1 | findstr "Access-Control"

echo.
echo ========================================
echo 测试完成！
echo ========================================
echo.
echo 如果看到 Access-Control-Allow-Origin 等头信息，
echo 说明CORS配置已生效。
echo.
echo 按任意键关闭此窗口...
pause >nul

echo.
echo 正在关闭服务...
taskkill /f /im java.exe >nul 2>&1
echo 服务已关闭
timeout /t 2 /nobreak >nul
