@echo off
echo ========================================================
echo   DAY CODE LEN GITHUB - TH GROUP HUMAN DESIGN
echo ========================================================
echo.
set /p REPO_URL="Nhap link GitHub repository cua ban (vi du https://github.com/user/human-design.git): "
if "%REPO_URL%"=="" (
    echo Ban chua nhap link repository!
    pause
    exit /b
)

cd /d C:\HumanDesign
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%
git branch -M main
echo.
echo Dang day code len GitHub (nhanh hay cham tuy vao toc do mang)...
git push -u origin main
echo.
echo ========================================================
echo   DA HOAN TAT PUSH LEN GITHUB!
echo ========================================================
pause
