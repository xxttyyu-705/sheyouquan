@echo off
chcp 65001 >nul
echo ========================================
echo 摄友圈社区系统 - 测试脚本
echo ========================================
echo.

echo 请选择要测试的功能：
echo.
echo [1] 测试商品列表接口 (GET /api/v1/product/list)
echo [2] 测试帖子列表接口 (GET /api/v1/post/list)
echo [3] 测试文件上传接口 (POST /api/v1/file/upload/image)
echo [4] 测试积分余额接口 (GET /api/v1/point/balance)
echo [5] 测试兑换记录接口 (GET /api/v1/exchange/list)
echo [6] 测试所有接口
echo [7] 返回主菜单
echo [8] 退出
echo.

set /p choice="请选择测试项 [1-8]: "

if "%choice%"=="1" (
    echo 正在测试商品列表接口...
    curl -X GET "http://localhost:8081/api/v1/product/list?page=1&size=12" ^
         -H "Content-Type: application/json" ^
         -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n"
) else if "%choice%"=="2" (
    echo 正在测试帖子列表接口...
    curl -X GET "http://localhost:8081/api/v1/post/list?page=1&size=10" ^
         -H "Content-Type: application/json" ^
         -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n"
) else if "%choice%"=="3" (
    echo 正在测试文件上传接口...
    echo 请选择一个图片文件进行上传...
    set /p image_file="请输入图片文件路径: "
    if exist "!image_file!" (
        curl -X POST "http://localhost:8081/api/v1/file/upload/image" ^
             -F "file=@!image_file!" ^
             -H "Content-Type: multipart/form-data" ^
             -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n"
    ) else (
        echo 文件不存在！
    )
) else if "%choice%"=="4" (
    echo 正在测试积分余额接口...
    echo 注意：此接口需要登录后获取token
    set /p token="请输入用户token (留空使用默认值): "
    if "!token!"=="" (
        echo 使用默认token测试...
        curl -X GET "http://localhost:8081/api/v1/point/balance" ^
             -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc5OTk5OTk5OX0.abc123" ^
             -H "x-user-id: 1" ^
             -H "Content-Type: application/json" ^
             -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n"
    ) else (
        curl -X GET "http://localhost:8081/api/v1/point/balance" ^
             -H "Authorization: Bearer !token!" ^
             -H "x-user-id: 1" ^
             -H "Content-Type: application/json" ^
             -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n"
    )
) else if "%choice%"=="5" (
    echo 正在测试兑换记录接口...
    echo 注意：此接口需要登录后获取token
    set /p token="请输入用户token (留空使用默认值): "
    if "!token!"=="" (
        echo 使用默认token测试...
        curl -X GET "http://localhost:8081/api/v1/exchange/list?page=1&size=10" ^
             -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc5OTk5OTk5OX0.abc123" ^
             -H "x-user-id: 1" ^
             -H "Content-Type: application/json" ^
             -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n"
    ) else (
        curl -X GET "http://localhost:8081/api/v1/exchange/list?page=1&size=10" ^
             -H "Authorization: Bearer !token!" ^
             -H "x-user-id: 1" ^
             -H "Content-Type: application/json" ^
             -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n"
    )
) else if "%choice%"=="6" (
    echo 正在测试所有接口...
    echo.
    echo [1/5] 测试商品列表接口...
    curl -X GET "http://localhost:8081/api/v1/product/list?page=1&size=12" ^
         -H "Content-Type: application/json" ^
         -w "\n状态码: %{http_code}\n"
    
    echo.
    echo [2/5] 测试帖子列表接口...
    curl -X GET "http://localhost:8081/api/v1/post/list?page=1&size=10" ^
         -H "Content-Type: application/json" ^
         -w "\n状态码: %{http_code}\n"
    
    echo.
    echo [3/5] 测试评论列表接口...
    curl -X GET "http://localhost:8081/api/v1/comment/list?postId=1&page=1&size=10" ^
         -H "Content-Type: application/json" ^
         -w "\n状态码: %{http_code}\n"
    
    echo.
    echo [4/5] 测试积分余额接口...
    curl -X GET "http://localhost:8081/api/v1/point/balance" ^
         -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc5OTk5OTk5OX0.abc123" ^
         -H "x-user-id: 1" ^
         -H "Content-Type: application/json" ^
         -w "\n状态码: %{http_code}\n"
    
    echo.
    echo [5/5] 测试兑换记录接口...
    curl -X GET "http://localhost:8081/api/v1/exchange/list?page=1&size=10" ^
         -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc5OTk5OTk5OX0.abc123" ^
         -H "x-user-id: 1" ^
         -H "Content-Type: application/json" ^
         -w "\n状态码: %{http_code}\n"
    
    echo.
    echo ========================================
    echo 所有测试完成！
    echo ========================================
) else if "%choice%"=="7" (
    call "%~dp0启动项目.bat"
) else if "%choice%"=="8" (
    echo 退出脚本
    exit /b 0
) else (
    echo 无效的选择！
)

pause
