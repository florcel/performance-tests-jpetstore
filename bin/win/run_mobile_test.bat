@echo off
setlocal

if "%JMETER_HOME%"=="" set JMETER_HOME=C:\apache-jmeter-5.6.3
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..") do set "ROOT=%%~fI"
set "TEST_PLAN=%ROOT%\test-plans\mobile-performance-tests.jmx"
set "RESULTS_DIR=%ROOT%\results\mobile-tests"

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,8%_%dt:~8,6%"
set RESULTS=%RESULTS_DIR%\mobile_%TIMESTAMP%.jtl
set REPORT_DIR=%RESULTS_DIR%\report_%TIMESTAMP%
set HTML_NAME=mobile(%TIMESTAMP%).html
set FINAL_HTML=%RESULTS_DIR%\%HTML_NAME%

if not exist "%RESULTS_DIR%" mkdir "%RESULTS_DIR%"
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

rem Variabilidad/errores (defaults / env)
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
echo [WARN] Opcion desconocida: %~1 & shift & goto parse

:after_args

"%JMETER_HOME%\bin\jmeter" -n -t "%TEST_PLAN%" -l "%RESULTS%" -JBASE_HOST=petstore.octoperf.com -JBASE_SCHEME=https ^
  -JSLOW_PCT=%SLOW_PCT% -JSLOW_MIN=%SLOW_MIN% -JSLOW_MAX=%SLOW_MAX% ^
  -JERR_PCT=%ERR_PCT% -JRT_MAX=%RT_MAX%
"%JMETER_HOME%\bin\jmeter" -g "%RESULTS%" -o "%REPORT_DIR%"

where python >nul 2>nul && (
  python -X utf8 "%ROOT%\scripts\generate_enhanced_report.py" "%RESULTS%" -o "%REPORT_DIR%\%HTML_NAME%" -v
) || (
  py -3 "%ROOT%\scripts\generate_enhanced_report.py" "%RESULTS%" -o "%REPORT_DIR%\%HTML_NAME%" -v
)

if not exist "%REPORT_DIR%\%HTML_NAME%" (
  set "HTML_SRC=%REPORT_DIR%\index.html"
) else (
  set "HTML_SRC=%REPORT_DIR%\%HTML_NAME%"
)
copy /Y "%HTML_SRC%" "%FINAL_HTML%" >nul 2>nul
echo Reporte movil listo: "%FINAL_HTML%"
start "" "%FINAL_HTML%"
endlocal


