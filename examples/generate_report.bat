@echo off
set JTL_FILE=%1
if "%JTL_FILE%"=="" (
  echo Uso: %~nx0 archivo.jtl
  exit /b 1
)
python -X utf8 scripts\generate_enhanced_report.py "%JTL_FILE%" -v

