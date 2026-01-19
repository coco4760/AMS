@echo off
chcp 65001 >nul
echo ========================================
echo 打包授权码生成系统（Windows）
echo ========================================
echo.

set PROJECT_NAME=invitation-code-system
REM 使用标准日期时间格式（避免中文）
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set VERSION=%datetime:~0,8%_%datetime:~8,6%
set VERSION=%VERSION: =0%
set PACKAGE_NAME=%PROJECT_NAME%-%VERSION%.zip

echo [1/3] 创建临时目录...
set TEMP_DIR=%TEMP%\%PROJECT_NAME%
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

echo.
echo [2/3] 复制项目文件...

REM 需要打包的文件
copy "invitation_code_api.py" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ invitation_code_api.py
copy "app.py" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ app.py
copy "invitation_code_generator.html" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ invitation_code_generator.html
copy "invitation_code_manager.html" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ invitation_code_manager.html
copy "config.json.example" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ config.json.example
copy "requirements_api.txt" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ requirements_api.txt
copy "gunicorn_config.py" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ gunicorn_config.py
copy "deploy.sh" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ deploy.sh
copy "start_all.sh" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ start_all.sh
copy "stop_all.sh" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ stop_all.sh
copy "systemd_service.sh" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ systemd_service.sh
copy "README.md" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ README.md
copy "DEPLOY_LINUX.md" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ DEPLOY_LINUX.md
copy "WINDOWS_ACCESS.md" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ WINDOWS_ACCESS.md
copy "DEPLOY_TROUBLESHOOTING.md" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ DEPLOY_TROUBLESHOOTING.md
copy ".gitignore" "%TEMP_DIR%\" >nul 2>&1 && echo   ✓ .gitignore

echo.
echo [3/3] 创建压缩包...

REM 使用PowerShell创建ZIP文件
powershell -Command "Compress-Archive -Path '%TEMP_DIR%\*' -DestinationPath '%PACKAGE_NAME%' -Force"

REM 清理临时目录
rmdir /s /q "%TEMP_DIR%"

echo.
echo ========================================
echo ✓ 打包完成！
echo ========================================
echo.
echo 压缩包: %PACKAGE_NAME%
echo.
echo 上传到Linux服务器:
echo   scp %PACKAGE_NAME% user@server:/opt/
echo.
echo 在服务器上解压:
echo   cd /opt
echo   unzip %PACKAGE_NAME%
echo   cd %PROJECT_NAME%
echo   chmod +x *.sh
echo   ./deploy.sh
echo.
pause

