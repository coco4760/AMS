@echo off
chcp 65001 >nul
echo ========================================
echo 安装授权码生成系统依赖包
echo ========================================
echo.

REM 检查Python是否安装
python --version
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.7+
    pause
    exit /b 1
)

echo.
echo 正在安装依赖包...
echo.

python -m pip install --upgrade pip
python -m pip install flask==3.0.0
python -m pip install flask-cors==4.0.0
python -m pip install mysql-connector-python==8.2.0

echo.
echo ========================================
echo 验证安装...
echo ========================================
echo.

python -c "import flask; print('✓ Flask installed')"
python -c "import flask_cors; print('✓ flask-cors installed')"
python -c "import mysql.connector; print('✓ mysql-connector-python installed')"

echo.
echo ========================================
echo 安装完成！
echo ========================================
echo.
pause

