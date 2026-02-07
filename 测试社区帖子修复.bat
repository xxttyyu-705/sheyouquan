@echo off
echo ========================================
echo 摄友圈社区系统 - 社区帖子403错误修复测试
echo ========================================
echo.

echo 1. 启动后端服务...
cd /d "D:\AAA\摄友圈社区系统\backend"
start "后端服务" mvn spring-boot:run
echo 等待5秒让后端服务启动...
timeout /t 5 /nobreak >nul

echo.
echo 2. 启动前端服务...
cd /d "D:\AAA\摄友圈社区系统\frontend"
start "前端服务" npm run dev
echo 等待5秒让前端服务启动...
timeout /t 5 /nobreak >nul

echo.
echo 3. 测试API接口...
echo 测试帖子列表接口...
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/post/list?page=1&size=10&keyword="

echo.
echo 4. 测试其他公开接口...
echo 测试作品列表接口...
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/work/list"

echo.
echo 测试课程列表接口...
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/course/list"

echo.
echo 测试商品列表接口...
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/product/list"

echo.
echo ========================================
echo 测试完成！
echo ========================================
echo.
echo 请手动打开浏览器访问：
echo 前端地址: http://localhost:5173
echo 后端地址: http://localhost:8082
echo.
echo 在浏览器中：
echo 1. 点击社区标签
echo 2. 检查是否显示帖子列表
echo 3. 打开开发者工具（F12）查看控制台
echo 4. 确认没有403错误
echo.
echo 按任意键关闭此窗口...
pause >nul
