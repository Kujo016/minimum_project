@echo off
call "%~dp0build.bat" system %*
exit /b %ERRORLEVEL%
