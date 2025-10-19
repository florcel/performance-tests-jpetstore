@echo off
set JTL_FILE=%1
if "%JTL_FILE%"=="" (
  echo Uso: %~nx0 archivo.jtl
  exit /b 1
)
set BASE=%~dp0
set JMETER_HOME=%JMETER_HOME%
if "%JMETER_HOME%"=="" set JMETER_HOME=C:\apache-jmeter-5.6.3
set REPORT_BASE=%~dpfreportes_%~n1
if exist "%REPORT_BASE%" rmdir /s /q "%REPORT_BASE%"
mkdir "%REPORT_BASE%"
"%JMETER_HOME%\bin\jmeter" -g "%JTL_FILE%" -o "%REPORT_BASE%\jmeter_estandar"
python -X utf8 scripts\generate_enhanced_report.py "%JTL_FILE%" -o "%REPORT_BASE%\personalizado.html" -v
echo Reportes en: %REPORT_BASE%

