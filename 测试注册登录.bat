@echo off
echo ========================================
echo 摄友圈社区系统 - 注册/登录功能测试
echo ========================================
echo.

echo 1. 启动后端服务...
cd /d 摄友圈社区系统/backend
start cmd /k "mvn spring-boot:run"

timeout /t 10 >nul

echo.
echo 2. 启动前端服务...
cd /d 摄友圈社区系统/frontend
start cmd /k "npm run dev"

timeout /t 10 >nul

echo.
echo 3. 测试注册接口...
echo 请求: POST http://localhost:8081/api/v1/user/register
echo 参数: {"username":"testuser","email":"test@example.com","password":"123456","confirmPassword":"123456"}
echo.

curl -X POST http://localhost:8081/api/v1/user/register ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"123456\",\"confirmPassword\":\"123456\"}"

echo.
echo.
echo 4. 测试登录接口...
echo 请求: POST http://localhost:8081/api/v1/user/login
echo 参数: {"username":"testuser","password":"123456"}
echo.

curl -X POST http://localhost:8081/api/v1/user/login ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"password\":\"123456\"}"

echo.
echo.
echo ========================================
echo 测试完成！
echo ========================================
echo.
echo 请查看上面的测试结果：
echo - 如果返回code:200，说明接口正常
echo - 如果返回错误，请检查后端日志
echo.
echo 前端访问地址：http://localhost:3003
echo 后端API地址：http://localhost:8081/api/v1
echo.
pause
