@echo off
echo ========================================================
echo   KHOI DONG HUMAN DESIGN CORE API & WEB PORTAL
echo   TH Group - Tinh Hoa Ban Menh
echo ========================================================
set PYTHONIOENCODING=utf-8
cd /d C:\HumanDesign\core\api
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
pause
