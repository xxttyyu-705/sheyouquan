@echo off
echo ========================================
echo 摄友圈 - 注册登录CORS修复测试
echo ========================================
echo.

echo 1. 启动后端服务...
cd /d backend
start "后端服务" java -jar target/shengyouquan-backend-1.0.0.jar
echo 等待后端服务启动...
timeout /t 10 /nobreak >nul

echo.
echo 2. 启动前端服务...
cd /d frontend
start "前端服务" npm run dev
echo 等待前端服务启动...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo 服务已启动，请手动测试：
echo ========================================
echo.
echo 后端地址: http://localhost:8082
echo 前端地址: http://localhost:3003
echo.
echo 测试步骤：
echo 1. 打开浏览器访问 http://localhost:3003
echo 2. 尝试注册新用户
echo 3. 尝试登录
echo 4. 检查浏览器控制台是否有CORS错误
echo.
echo 按任意键关闭此窗口...
pause >nul

echo.
echo 正在关闭服务...
taskkill /f /im java.exe >nul 2>&1
taskkill /f /im node.exe >nul 2>&1
echo 服务已关闭
timeout /t 2 /nobreak >nul
