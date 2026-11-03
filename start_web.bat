@echo off
echo ========================================================
echo   KHOI DONG BAN WEB - TH GROUP (HUMAN DESIGN)
echo ========================================================
echo Dang khoi chay local web server tai http://localhost:8080 ...
start http://localhost:8080
cd /d C:\HumanDesign\web_build
python -m http.server 8080
pause
