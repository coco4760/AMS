@echo off
chcp 65001 >nul
echo ========================================
echo 授权码生成系统 - 完整启动
echo ========================================
echo.

REM 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.7+
    pause
    exit /b 1
)

echo [1/4] 检查配置文件...
if not exist "config.json" (
    if exist "config.json.example" (
        echo 配置文件不存在，从示例文件创建...
        copy "config.json.example" "config.json" >nul
        echo ⚠️  请编辑 config.json 文件，设置正确的数据库密码！
        echo 按任意键继续（请确保已配置数据库信息）...
        pause >nul
    ) else (
        echo ⚠️  警告: 配置文件 config.json 不存在，将使用默认配置
    )
) else (
    echo 配置文件已存在
)

echo.
echo [2/4] 检查依赖包...
python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo 正在安装依赖包...
    python -m pip install -r requirements_api.txt
    if errorlevel 1 (
        echo [错误] 依赖包安装失败
        pause
        exit /b 1
    )
) else (
    python -c "import flask_cors" >nul 2>&1
    if errorlevel 1 (
        echo 正在安装 flask-cors...
        python -m pip install flask-cors
    )
    python -c "import mysql.connector" >nul 2>&1
    if errorlevel 1 (
        echo 正在安装 mysql-connector-python...
        python -m pip install mysql-connector-python
    )
    echo 依赖包检查完成
)

echo.
echo [3/4] 启动API服务...
echo.

REM 获取当前脚本所在目录
set "SCRIPT_DIR=%~dp0"

REM 在新窗口中启动集成服务（API + UI）
start "InvitationCodeSystem" cmd /k "cd /d "%SCRIPT_DIR%" && python invitation_code_api.py"

REM 等待服务启动
echo 等待API服务启动（3秒）...
timeout /t 3 /nobreak >nul

echo.
echo [4/4] 打开浏览器...
REM 等待服务启动
timeout /t 2 /nobreak >nul
start "" "http://localhost:30111"

echo.
echo ========================================
echo 启动完成！
echo ========================================
echo.
echo 服务窗口：已在新窗口中打开
echo 浏览器：已自动打开
echo.
echo 访问地址: http://localhost:30111
echo.
echo 提示：
echo - UI和API已集成在同一服务中
echo - 访问根路径查看UI界面
echo - API接口路径: /api/*
echo - 关闭服务：关闭"授权码生成系统"窗口
echo.
pause

