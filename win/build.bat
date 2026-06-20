@echo off
setlocal EnableExtensions

rem ---------------------------------------------------
rem Engine root
rem ---------------------------------------------------
set "ENGINE_DIR=%~dp0.."
cd /d "%ENGINE_DIR%"

rem ---------------------------------------------------
rem Arguments
rem ---------------------------------------------------
if "%~1"=="" (
    echo [ERROR] No build target provided.
    echo Usage:
    echo   build.bat system
    echo   build.bat simulator
    echo   build.bat vectoriso
    exit /b 1
)

set "BUILDER_ARGS=%*"

echo [BOOTSTRAP] Engine root: %CD%
echo [BOOTSTRAP] Builder args: %BUILDER_ARGS%

rem ---------------------------------------------------
rem Clean target bin/obj folders
rem ---------------------------------------------------
echo [BOOTSTRAP] Cleaning target outputs...

for %%T in (%*) do (
    if exist "%%~T\bin" (
        echo [CLEAN] %%~T\bin
        rmdir /s /q "%%~T\bin"
    )

    if exist "%%~T\obj" (
        echo [CLEAN] %%~T\obj
        rmdir /s /q "%%~T\obj"
    )
)

if exist builder\bin (
    echo [CLEAN] builder\bin
    rmdir /s /q builder\bin
)

if exist builder\obj (
    echo [CLEAN] builder\obj
    rmdir /s /q builder\obj
)

del /s /q *.pdb >nul 2>&1

echo [BOOTSTRAP] Clean complete.

rem ---------------------------------------------------
rem Visual Studio prerequisite
rem ---------------------------------------------------
echo [BOOTSTRAP] Searching for Visual Studio...

set "VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
if exist "%VS_PATH%" goto :FOUND_VS

set "VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
if exist "%VS_PATH%" goto :FOUND_VS

set "VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
if exist "%VS_PATH%" goto :FOUND_VS

echo [ERROR] Could not find vcvars64.bat.
echo [ERROR] Install Visual Studio with the C++ workload.
exit /b 1

:FOUND_VS
echo [BOOTSTRAP] Found VS: %VS_PATH%
call "%VS_PATH%" >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Failed to initialize Visual Studio environment.
    exit /b 1
)

echo [BOOTSTRAP] Visual Studio environment initialized.

rem ---------------------------------------------------
rem CUDA prerequisite check
rem ---------------------------------------------------
echo [BOOTSTRAP] Checking for CUDA...

set "BUILD_FLAGS="
where nvcc >nul 2>&1

if errorlevel 1 (
    echo [BOOTSTRAP] CUDA not found. Building CPU-compatible builder.
) else (
    echo [BOOTSTRAP] CUDA found.
    set "BUILD_FLAGS=/D__CUDACC__"
)

rem ---------------------------------------------------
rem Build builder
rem ---------------------------------------------------
echo [BOOTSTRAP] Building C++ builder...

set "BUILDER_BIN_DIR=builder\bin"
set "BUILDER_OBJ_DIR=builder\obj"
set "BUILDER_EXE=%BUILDER_BIN_DIR%\builder.exe"

if not exist "%BUILDER_BIN_DIR%" mkdir "%BUILDER_BIN_DIR%"
if not exist "%BUILDER_OBJ_DIR%" mkdir "%BUILDER_OBJ_DIR%"

cl /nologo /EHsc /std:c++20 /c %BUILD_FLAGS% ^
    /Fo"%BUILDER_OBJ_DIR%\\" ^
    builder\main.cpp ^
    builder\FileTool_Windows.cpp ^
    builder\CompilerTool.cpp ^
    builder\utils\version.cpp

if errorlevel 1 (
    echo [ERROR] Failed to compile builder objects.
    exit /b 1
)

link /nologo ^
    "%BUILDER_OBJ_DIR%\main.obj" ^
    "%BUILDER_OBJ_DIR%\FileTool_Windows.obj" ^
    "%BUILDER_OBJ_DIR%\CompilerTool.obj" ^
    "%BUILDER_OBJ_DIR%\version.obj" ^
    /OUT:"%BUILDER_EXE%"

if errorlevel 1 (
    echo [ERROR] Failed to link builder.
    exit /b 1
)

rem ---------------------------------------------------
rem Run builder
rem ---------------------------------------------------
echo [BOOTSTRAP] Running builder...
echo ---------------------------------------------------

"%BUILDER_EXE%" %BUILDER_ARGS%

if errorlevel 1 (
    echo [ERROR] Builder failed.
    exit /b 1
)

echo ---------------------------------------------------
echo [BOOTSTRAP] Build complete.

pause
endlocal
exit /b 0