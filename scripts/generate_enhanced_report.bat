@echo off
REM Script para generar reporte HTML mejorado desde archivo .jtl
REM Autor: Performance Testing Team
REM Versión: 1.0

setlocal enabledelayedexpansion

REM Configuración
set PYTHON_CMD=python
set SCRIPT_DIR=%~dp0
set TEMPLATE_DIR=%SCRIPT_DIR%..\templates

REM Verificar argumentos
if "%1"=="" (
    echo Uso: %0 archivo.jtl [archivo_salida.html]
    echo.
    echo Ejemplos:
    echo   %0 results\results_20240115_143022.jtl
    echo   %0 results\results_20240115_143022.jtl reporte_personalizado.html
    echo.
    echo Archivos .jtl disponibles:
    if exist "results\*.jtl" (
        for %%f in (results\*.jtl) do echo   %%f
    ) else (
        echo   No se encontraron archivos .jtl en results\
    )
    pause
    exit /b 1
)

set JTL_FILE=%1
set OUTPUT_FILE=%2

REM Verificar que el archivo .jtl existe
if not exist "%JTL_FILE%" (
    echo [ERROR] Archivo no encontrado: %JTL_FILE%
    pause
    exit /b 1
)

REM Determinar archivo de salida si no se especifica
if "%OUTPUT_FILE%"=="" (
    for %%f in ("%JTL_FILE%") do set OUTPUT_FILE=%%~dpfreporte_enhanced_%%~nf.html
)

echo [INFO] Generando reporte HTML mejorado...
echo   Archivo fuente: %JTL_FILE%
echo   Archivo salida: %OUTPUT_FILE%
echo.

REM Verificar que Python está instalado
%PYTHON_CMD% --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no está instalado o no está en el PATH
    echo Por favor, instala Python 3.6+ desde https://python.org
    pause
    exit /b 1
)

REM Verificar que el script Python existe
if not exist "%SCRIPT_DIR%generate_enhanced_report.py" (
    echo [ERROR] Script Python no encontrado: %SCRIPT_DIR%generate_enhanced_report.py
    pause
    exit /b 1
)

REM Verificar que el template existe
if not exist "%TEMPLATE_DIR%\reporte_enhanced.html" (
    echo [ERROR] Template no encontrado: %TEMPLATE_DIR%\reporte_enhanced.html
    pause
    exit /b 1
)

REM Ejecutar el script Python
echo [INFO] Ejecutando generador de reportes...
%PYTHON_CMD% "%SCRIPT_DIR%generate_enhanced_report.py" "%JTL_FILE%" -o "%OUTPUT_FILE%" -v

if errorlevel 1 (
    echo [ERROR] Error al generar el reporte
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Reporte generado exitosamente
echo.
echo Para ver el reporte:
echo   start "" "%OUTPUT_FILE%"
echo.

REM Preguntar si quiere abrir el reporte
set /p OPEN_REPORT="¿Abrir el reporte en el navegador? (S/n): "
if /i "%OPEN_REPORT%"=="S" (
    start "" "%OUTPUT_FILE%"
) else if /i "%OPEN_REPORT%"=="" (
    start "" "%OUTPUT_FILE%"
)

echo.
echo ¡Listo! El reporte está disponible en: %OUTPUT_FILE%
pause
