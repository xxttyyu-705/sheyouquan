@echo off
chcp 65001 >nul
echo ========================================
echo 摄友圈社区系统部署脚本
echo ========================================
echo.

:: 检查环境
echo [1/5] 检查环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未安装JDK 17+
    pause
    exit /b 1
)
echo ✓ JDK 检查通过

node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未安装Node.js 16+
    pause
    exit /b 1
)
echo ✓ Node.js 检查通过

mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 警告: 未检测到MySQL，请确保MySQL已安装并启动
)
echo ✓ MySQL 检查完成

mvn -v >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未安装Maven 3.6+
    pause
    exit /b 1
)
echo ✓ Maven 检查通过

echo.
echo [2/5] 编译后端项目...
cd /d "摄友圈社区系统/backend"
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo 错误: 后端编译失败
    pause
    exit /b 1
)
echo ✓ 后端编译成功

echo.
echo [3/5] 启动后端服务...
start "后端服务" cmd /c "java -jar target/shengyouquan-backend-1.0.0.jar"
echo ✓ 后端服务已启动 (http://localhost:8081)

echo.
echo [4/5] 安装前端依赖...
cd /d "摄友圈社区系统/frontend"
call npm install
if %errorlevel% neq 0 (
    echo 错误: 前端依赖安装失败
    pause
    exit /b 1
)
echo ✓ 前端依赖安装成功

echo.
echo [5/5] 启动前端服务...
start "前端服务" cmd /c "npm run dev"
echo ✓ 前端服务已启动 (http://localhost:3002)

echo.
echo ========================================
echo 部署完成！
echo ========================================
echo.
echo 访问地址:
echo   前端: http://localhost:3002
echo   后端API: http://localhost:8081
echo   API文档: http://localhost:8081/swagger-ui.html
echo.
echo 测试账号:
echo   管理员: admin / 123456
echo   普通用户: test / 123456
echo.
echo 按任意键关闭此窗口...
pause >nul
