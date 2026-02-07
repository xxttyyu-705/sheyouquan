@echo off
chcp 65001 >nul
echo ========================================
echo 摄友圈社区系统 - 启动脚本
echo ========================================
echo.

echo [1] 启动后端服务 (Spring Boot)
echo [2] 启动前端服务 (Vue)
echo [3] 执行数据初始化
echo [4] 验证数据
echo [5] 查看项目说明
echo [6] 退出
echo.

set /p choice="请选择操作 [1-6]: "

if "%choice%"=="1" (
    echo 正在启动后端服务...
    cd /d "%~dp0backend"
    call mvn spring-boot:run
) else if "%choice%"=="2" (
    echo 正在启动前端服务...
    cd /d "%~dp0frontend"
    call npm run dev
) else if "%choice%"=="3" (
    echo 正在执行数据初始化...
    echo 请确保MySQL数据库已启动，并且数据库名为 shengyouquan
    echo.
    set /p db_user="请输入数据库用户名 [默认: root]: "
    if "!db_user!"=="" set db_user=root
    set /p db_pass="请输入数据库密码 [默认: 123456]: "
    if "!db_pass!"=="" set db_pass=123456
    
    echo 正在执行初始化脚本...
    mysql -u!db_user! -p!db_pass! -D shengyouquan < "%~dp0database\init_data.sql"
    
    if %errorlevel% equ 0 (
        echo.
        echo ========================================
        echo 数据初始化成功！
        echo ========================================
    ) else (
        echo.
        echo ========================================
        echo 数据初始化失败！请检查数据库连接和配置。
        echo ========================================
    )
) else if "%choice%"=="4" (
    echo 正在打开数据验证脚本...
    call "%~dp0验证数据.bat"
) else if "%choice%"=="5" (
    echo 正在打开项目说明...
    if exist "%~dp0README.md" (
        start "" "%~dp0README.md"
    ) else (
        echo README.md 文件不存在
    )
) else if "%choice%"=="6" (
    echo 退出脚本
    exit /b 0
) else (
    echo 无效的选择！
)

pause
