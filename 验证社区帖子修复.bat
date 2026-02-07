@echo off
echo ========================================
echo 摄友圈社区系统 - 社区帖子403错误修复验证
echo ========================================
echo.

echo 正在测试API接口...
echo.

echo 1. 测试帖子列表接口 (POST /api/v1/post/list)
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/post/list?page=1&size=10&keyword="
if %%errorlevel%% neq 0 (
    echo    [失败] 无法连接到服务器
) else (
    echo    [成功] 接口可访问
)

echo.
echo 2. 测试作品列表接口 (GET /api/v1/work/list)
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/work/list"
if %%errorlevel%% neq 0 (
    echo    [失败] 无法连接到服务器
) else (
    echo    [成功] 接口可访问
)

echo.
echo 3. 测试课程列表接口 (GET /api/v1/course/list)
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/course/list"
if %%errorlevel%% neq 0 (
    echo    [失败] 无法连接到服务器
) else (
    echo    [成功] 接口可访问
)

echo.
echo 4. 测试商品列表接口 (GET /api/v1/product/list)
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/product/list"
if %%errorlevel%% neq 0 (
    echo    [失败] 无法连接到服务器
) else (
    echo    [成功] 接口可访问
)

echo.
echo 5. 测试评论列表接口 (GET /api/v1/comment/list)
curl -s -o NUL -w "HTTP状态码: %%{http_code}\n" "http://localhost:8082/api/v1/comment/list?postId=1&page=1&size=10"
if %%errorlevel%% neq 0 (
    echo    [失败] 无法连接到服务器
) else (
    echo    [成功] 接口可访问
)

echo.
echo ========================================
echo 验证完成！
echo ========================================
echo.
echo 如果所有接口都返回 HTTP 200，则修复成功！
echo.
echo 接下来请：
echo 1. 启动后端服务: cd 摄友圈社区系统/backend && mvn spring-boot:run
echo 2. 启动前端服务: cd 摄友圈社区系统/frontend && npm run dev
echo 3. 打开浏览器访问: http://localhost:5173
echo 4. 点击社区标签，检查帖子列表是否正常显示
echo 5. 打开开发者工具（F12）查看控制台，确认没有403错误
echo.
echo 按任意键关闭此窗口...
pause >nul
