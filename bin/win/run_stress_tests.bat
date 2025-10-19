@echo off
setlocal enabledelayedexpansion

if "%JMETER_HOME%"=="" set JMETER_HOME=C:\apache-jmeter-5.6.3
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..") do set "ROOT=%%~fI"
set "TEST_PLAN=%ROOT%\test-plans\stress-tests.jmx"
set "RESULTS_DIR=%ROOT%\results\stress-tests"
set BASE_HOST=petstore.octoperf.com
set BASE_SCHEME=https
set USERS=100
set RAMPUP=300
set DURATION=600

:parse
if "%~1"=="" goto after_args
if "%~1"=="-u" set USERS=%~2& shift & shift & goto parse
if "%~1"=="-r" set RAMPUP=%~2& shift & shift & goto parse
if "%~1"=="-d" set DURATION=%~2& shift & shift & goto parse
if "%~1"=="-h" set BASE_HOST=%~2& shift & shift & goto parse
if "%~1"=="-s" set BASE_SCHEME=%~2& shift & shift & goto parse
if "%~1"=="-j" set JMETER_HOME=%~2& shift & shift & goto parse
if "%~1"=="-t" set TEST_PLAN=%~2& shift & shift & goto parse
if "%~1"=="-p" set TEST_PLAN=%~2& shift & shift & goto parse
if "%~1"=="-o" set RESULTS_DIR=%~2& shift & shift & goto parse
if "%~1"=="-sp" set SLOW_PCT=%~2& shift & shift & goto parse
if "%~1"=="-smin" set SLOW_MIN=%~2& shift & shift & goto parse
if "%~1"=="-smax" set SLOW_MAX=%~2& shift & shift & goto parse
if "%~1"=="-ep" set ERR_PCT=%~2& shift & shift & goto parse
if "%~1"=="-rt" set RT_MAX=%~2& shift & shift & goto parse
if "%~1"=="-h" goto :show_help
if "%~1"=="--help" goto :show_help
echo [WARN] Opcion desconocida: %~1 & shift & goto parse

:after_args
if not exist "%JMETER_HOME%\bin\jmeter.bat" (
  echo [ERROR] JMeter no encontrado en %JMETER_HOME%
  exit /b 1
)
if not exist "%TEST_PLAN%" (
  echo [ERROR] Test plan no encontrado: %TEST_PLAN%
  exit /b 1
)

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,8%_%dt:~8,6%"
set RESULTS=%RESULTS_DIR%\stress_%TIMESTAMP%.jtl
set REPORT_DIR=%RESULTS_DIR%\stress_report_%TIMESTAMP%
set HTML_NAME=stress(%TIMESTAMP%).html
set FINAL_HTML=%RESULTS_DIR%\%HTML_NAME%

if not exist "%RESULTS_DIR%" mkdir "%RESULTS_DIR%"
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

echo [INFO] Iniciando stress test API
echo   JMETER_HOME   = %JMETER_HOME%
echo   TEST_PLAN     = %TEST_PLAN%
echo   BASE_HOST     = %BASE_HOST%
echo   BASE_SCHEME   = %BASE_SCHEME%
echo   USERS         = %USERS%
echo   RAMPUP (s)    = %RAMPUP%
echo   DURATION (s)  = %DURATION%
echo   RESULTS JTL   = %RESULTS%
echo   REPORT DIR    = %REPORT_DIR%

"%JMETER_HOME%\bin\jmeter" -n -t "%TEST_PLAN%" -l "%RESULTS%" ^
  -JBASE_HOST=%BASE_HOST% -JBASE_SCHEME=%BASE_SCHEME% ^
  -JSLOW_PCT=%SLOW_PCT% -JSLOW_MIN=%SLOW_MIN% -JSLOW_MAX=%SLOW_MAX% ^
  -JERR_PCT=%ERR_PCT% -JRT_MAX=%RT_MAX% ^
  -Jusers=%USERS% -Jrampup=%RAMPUP% -Jduration=%DURATION%

if errorlevel 1 (
  echo [ERROR] Falla durante la ejecucion del test
  exit /b 1
)

echo [INFO] Generando dashboard HTML de JMeter...
"%JMETER_HOME%\bin\jmeter" -g "%RESULTS%" -o "%REPORT_DIR%"
if errorlevel 1 (
  echo [ERROR] Falla generando el dashboard de JMeter
  exit /b 1
)

echo [INFO] Aplicando formato HTML personalizado...
python -X utf8 scripts\generate_enhanced_report.py "%RESULTS%" -o "%REPORT_DIR%\%HTML_NAME%" -v >nul 2>nul
if errorlevel 1 (
  echo [WARN] No se pudo aplicar el formato personalizado; quedara el dashboard estandar de JMeter
)

if not exist "%REPORT_DIR%\%HTML_NAME%" (
  set "HTML_SRC=%REPORT_DIR%\index.html"
) else (
  set "HTML_SRC=%REPORT_DIR%\%HTML_NAME%"
)
copy /Y "%HTML_SRC%" "%FINAL_HTML%" >nul 2>nul
echo [SUCCESS] Reporte listo: %FINAL_HTML%
start "" "%FINAL_HTML%"
exit /b 0

:show_help
echo Uso: %~nx0 [-u USERS] [-r RAMPUP] [-d DURATION] [-h HOST] [-s SCHEME] [-j JMETER_HOME] [-t TEST_PLAN] [-o RESULTS_DIR] [-sp PCT] [-smin MS] [-smax MS] [-ep PCT] [-rt MS]
echo Ejemplos:
echo   %~nx0                                                ^(valores por defecto^)
echo   %~nx0 -u 200 -r 600 -d 1800                          ^(stress mayor^)
echo   %~nx0 -h api.mi-dominio.com -s https                 ^(cambiar host y esquema^)
echo   %~nx0 -t test-plans\otro-plan.jmx                    ^(cambiar test plan^)
echo   %~nx0 -o results\stress-enero                        ^(cambiar carpeta base de resultados^)
echo   %~nx0 -sp 30 -smin 700 -smax 2500 -ep 8 -rt 1200     ^(variabilidad/errores^)
exit /b 0
