@echo off
setlocal enabledelayedexpansion

if "%JMETER_HOME%"=="" set JMETER_HOME=C:\apache-jmeter-5.6.3
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..") do set "ROOT=%%~fI"
set "TEST_PLAN=%ROOT%\test-plans\api-performance-tests.jmx"
set "RESULTS_DIR=%ROOT%\results\api-tests"

set USERS=%USERS%
if "%USERS%"=="" set USERS=20
set RAMPUP=%RAMPUP%
if "%RAMPUP%"=="" set RAMPUP=60
set DURATION=%DURATION%
if "%DURATION%"=="" set DURATION=300
set BASE_HOST=%BASE_HOST%
if "%BASE_HOST%"=="" set BASE_HOST=petstore.octoperf.com
set BASE_SCHEME=%BASE_SCHEME%
if "%BASE_SCHEME%"=="" set BASE_SCHEME=https

rem Variabilidad/errores (defaults, sobreescribibles por env o flags)
set SLOW_PCT=%SLOW_PCT%
if "%SLOW_PCT%"=="" set SLOW_PCT=20
set SLOW_MIN=%SLOW_MIN%
if "%SLOW_MIN%"=="" set SLOW_MIN=800
set SLOW_MAX=%SLOW_MAX%
if "%SLOW_MAX%"=="" set SLOW_MAX=3000
set ERR_PCT=%ERR_PCT%
if "%ERR_PCT%"=="" set ERR_PCT=10
set RT_MAX=%RT_MAX%
if "%RT_MAX%"=="" set RT_MAX=1000

:parse
if "%~1"=="" goto after_args
if "%~1"=="-sp" set SLOW_PCT=%~2& shift & shift & goto parse
if "%~1"=="-smin" set SLOW_MIN=%~2& shift & shift & goto parse
if "%~1"=="-smax" set SLOW_MAX=%~2& shift & shift & goto parse
if "%~1"=="-ep" set ERR_PCT=%~2& shift & shift & goto parse
if "%~1"=="-rt" set RT_MAX=%~2& shift & shift & goto parse
if "%~1"=="-t" set TEST_PLAN=%~2& shift & shift & goto parse
if "%~1"=="-o" set RESULTS_DIR=%~2& shift & shift & goto parse
echo [WARN] Opcion desconocida: %~1 & shift & goto parse

:after_args

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,8%_%dt:~8,6%"
set RESULTS=%RESULTS_DIR%\api_results_%TIMESTAMP%.jtl
set REPORT_DIR=%RESULTS_DIR%\api_report_%TIMESTAMP%
set HTML_NAME=API(%TIMESTAMP%).html

if not exist "%RESULTS_DIR%" mkdir "%RESULTS_DIR%"
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

echo [INFO] Ejecutando API tests...
"%JMETER_HOME%\bin\jmeter" -n -t "%TEST_PLAN%" -l "%RESULTS%" ^
  -Jusers=%USERS% -Jrampup=%RAMPUP% -Jduration=%DURATION% ^
  -JBASE_HOST=%BASE_HOST% -JBASE_SCHEME=%BASE_SCHEME% ^
  -JSLOW_PCT=%SLOW_PCT% -JSLOW_MIN=%SLOW_MIN% -JSLOW_MAX=%SLOW_MAX% ^
  -JERR_PCT=%ERR_PCT% -JRT_MAX=%RT_MAX% ^
  -Jjmeter.save.saveservice.output_format=csv

if errorlevel 1 (
  echo [ERROR] Falla durante la ejecucion del test
  exit /b 1
)

echo [INFO] Generando dashboard HTML...
"%JMETER_HOME%\bin\jmeter" -g "%RESULTS%" -o "%REPORT_DIR%"
if errorlevel 1 (
  echo [ERROR] Falla generando dashboard HTML
  exit /b 1
)

echo [INFO] Aplicando formato HTML personalizado...
where python >nul 2>nul && (
  python -X utf8 "%ROOT%\scripts\generate_enhanced_report.py" "%RESULTS%" -o "%REPORT_DIR%\%HTML_NAME%" -v
) || (
  py -3 "%ROOT%\scripts\generate_enhanced_report.py" "%RESULTS%" -o "%REPORT_DIR%\%HTML_NAME%" -v
)
if errorlevel 1 (
  echo [WARN] No se pudo aplicar el formato personalizado; quedara el dashboard estandar de JMeter
)

echo [SUCCESS] Reporte listo: %REPORT_DIR%\%HTML_NAME%
start "" "%REPORT_DIR%\%HTML_NAME%"
exit /b 0
