@echo off
REM Script para generar reporte JMeter estándar y mejorarlo
REM Autor: Performance Testing Team
REM Versión: 1.0

setlocal enabledelayedexpansion

REM Configuración
set JMETER_HOME=%JMETER_HOME%
if "%JMETER_HOME%"=="" set JMETER_HOME=C:\apache-jmeter-5.6.3

REM Verificar argumentos
if "%1"=="" (
    echo Uso: %0 archivo.jtl [directorio_salida]
    echo.
    echo Ejemplos:
    echo   %0 results\results_20240115_143022.jtl
    echo   %0 results\results_20240115_143022.jtl mi_reporte
    echo.
    echo Archivos .jtl disponibles:
    if exist "results\*.jtl" (
        for %%f in (results\*.jtl) do echo   %%f
    ) else (
        echo   No se encontraron archivos .jtl en results\
    )
    if exist "*.jtl" (
        for %%f in (*.jtl) do echo   %%f
    )
    echo.
    pause
    exit /b 1
)

set JTL_FILE=%1
set OUTPUT_DIR=%2

REM Verificar que el archivo .jtl existe
if not exist "%JTL_FILE%" (
    echo [ERROR] Archivo no encontrado: %JTL_FILE%
    pause
    exit /b 1
)

REM Determinar directorio de salida
if "%OUTPUT_DIR%"=="" (
    for %%f in ("%JTL_FILE%") do set OUTPUT_DIR=%%~dpfreporte_jmeter_%%~nf
)

echo [INFO] Generando reporte JMeter estándar...
echo   Archivo fuente: %JTL_FILE%
echo   Directorio salida: %OUTPUT_DIR%
echo.

REM Verificar que JMeter está instalado
if not exist "%JMETER_HOME%\bin\jmeter.bat" (
    echo [ERROR] JMeter no encontrado en %JMETER_HOME%
    echo Por favor, instala JMeter o configura JMETER_HOME correctamente
    pause
    exit /b 1
)

REM Crear directorio de salida
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Generar reporte JMeter estándar
echo [INFO] Ejecutando JMeter para generar reporte HTML...
"%JMETER_HOME%\bin\jmeter" -g "%JTL_FILE%" -o "%OUTPUT_DIR%"

if errorlevel 1 (
    echo [ERROR] Error al generar reporte JMeter
    pause
    exit /b 1
)

echo [SUCCESS] Reporte JMeter generado exitosamente
echo.

REM Mejorar el reporte con estilos personalizados
echo [INFO] Aplicando estilos personalizados...
python scripts\copy_jmeter_report.py "%OUTPUT_DIR%" -v

if errorlevel 1 (
    echo [WARNING] No se pudieron aplicar estilos personalizados
    echo El reporte estándar está disponible en: %OUTPUT_DIR%
) else (
    echo [SUCCESS] Reporte mejorado generado exitosamente
)

echo.
echo 📊 Reportes disponibles:
echo   📁 Estándar: %OUTPUT_DIR%\index.html
if exist "%OUTPUT_DIR%_enhanced" (
    echo   🎨 Mejorado: %OUTPUT_DIR%_enhanced\index.html
)
echo.

REM Preguntar si quiere abrir el reporte
set /p OPEN_REPORT="¿Abrir el reporte en el navegador? (S/n): "
if /i "%OPEN_REPORT%"=="S" (
    if exist "%OUTPUT_DIR%_enhanced\index.html" (
        start "" "%OUTPUT_DIR%_enhanced\index.html"
    ) else (
        start "" "%OUTPUT_DIR%\index.html"
    )
) else if /i "%OPEN_REPORT%"=="" (
    if exist "%OUTPUT_DIR%_enhanced\index.html" (
        start "" "%OUTPUT_DIR%_enhanced\index.html"
    ) else (
        start "" "%OUTPUT_DIR%\index.html"
    )
)

echo.
echo ¡Listo! Los reportes están disponibles en: %OUTPUT_DIR%
pause

