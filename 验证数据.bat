@echo off
chcp 65001 >nul
echo ========================================
echo 摄友圈社区系统 - 数据验证脚本
echo ========================================
echo.

echo 请选择要验证的数据：
echo.
echo [1] 验证用户数据
echo [2] 验证商品数据
echo [3] 验证帖子数据
echo [4] 验证作品数据
echo [5] 验证课程数据
echo [6] 验证所有数据
echo [7] 返回主菜单
echo [8] 退出
echo.

set /p choice="请选择验证项 [1-8]: "

if "%choice%"=="1" (
    echo 正在验证用户数据...
    echo.
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, username, nickname, role, points, status FROM sys_user ORDER BY id;"
) else if "%choice%"=="2" (
    echo 正在验证商品数据...
    echo.
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, name, price, stock, status FROM mall_goods ORDER BY id;"
) else if "%choice%"=="3" (
    echo 正在验证帖子数据...
    echo.
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, user_id, content, like_count, comment_count, view_count FROM post ORDER BY id;"
) else if "%choice%"=="4" (
    echo 正在验证作品数据...
    echo.
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, user_id, title, category_id, view_count, like_count FROM work ORDER BY id;"
) else if "%choice%"=="5" (
    echo 正在验证课程数据...
    echo.
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, title, price, is_free, difficulty, student_count FROM course ORDER BY id;"
) else if "%choice%"=="6" (
    echo 正在验证所有数据...
    echo.
    echo [1/6] 用户数据
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, username, nickname, role, points, status FROM sys_user ORDER BY id;"
    
    echo.
    echo [2/6] 商品数据
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, name, price, stock, status FROM mall_goods ORDER BY id;"
    
    echo.
    echo [3/6] 帖子数据
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, user_id, content, like_count, comment_count, view_count FROM post ORDER BY id;"
    
    echo.
    echo [4/6] 作品数据
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, user_id, title, category_id, view_count, like_count FROM work ORDER BY id;"
    
    echo.
    echo [5/6] 课程数据
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, title, price, is_free, difficulty, student_count FROM course ORDER BY id;"
    
    echo.
    echo [6/6] 积分记录
    mysql -uroot -p123456 -D shengyouquan -e "SELECT id, user_id, points, type, description, balance FROM points_record ORDER BY id;"
    
    echo.
    echo ========================================
    echo 所有数据验证完成！
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
