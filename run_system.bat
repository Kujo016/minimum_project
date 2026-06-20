@echo off
setlocal

set "INTERSYSTEM_EXE=%~dp0system\bin\CUDA_System.exe"

"%INTERSYSTEM_EXE%"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Builder failed.
    pause
    exit /b 1
)


pause
exit /b 0