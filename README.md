# JPetStore Performance Tests

Este repo contiene planes de JMeter y scripts para correr pruebas de rendimiento sobre JPetStore.

Estructura
- `bin/win/` → lanzadores de Windows (`run_api_tests.bat`, `run_stress_tests.bat`, `run_mobile_test.bat`)
- `bin/unix/` → lanzadores Linux/macOS (`run_api_tests.sh`, `run_mobile_tests.sh`)
- `scripts/` → utilidades (generador HTML `generate_enhanced_report.py`)
- `test-plans/` → planes de JMeter (API y mobile)
- `templates/` → template HTML del reporte
- `results/` → resultados y reportes generados (gitignored)
- `examples/` → scripts y utilidades legacy

Cómo correr
- Windows (PowerShell)
  - API: `./bin/win/run_api_tests.bat`
  - Stress/API: `./bin/win/run_stress_tests.bat`
  - Mobile: `./bin/win/run_mobile_test.bat`
- Linux/macOS
  - API: `bash bin/unix/run_api_tests.sh`
  - Mobile: `bash bin/unix/run_mobile_tests.sh`

Variables (Windows, runner API)
- Puedes ajustar los parámetros vía variables de entorno antes de ejecutar:
  - `USERS` (por defecto 20)
  - `RAMPUP` (segundos, por defecto 60)
  - `DURATION` (segundos, por defecto 300)
  - `BASE_HOST` (host sin esquema, por defecto `petstore.octoperf.com`)
  - `BASE_SCHEME` (`https`/`http`, por defecto `https`)

Ejemplo PowerShell:
```
$env:USERS=50; $env:RAMPUP=120; $env:DURATION=600;
$env:BASE_HOST="petstore.octoperf.com"; $env:BASE_SCHEME="https";
./bin/win/run_api_tests.bat
```

Parámetros (Windows, runner Stress)
- El runner de stress acepta flags en línea de comandos:
```
./bin/win/run_stress_tests.bat -u 200 -r 600 -d 1800 -h petstore.octoperf.com -s https
```

Salidas
- Los reportes se guardan con nombre claro por tipo y fecha:
  - Stress: `STRESS(YYYYMMDD_HHMMSS).html`
  - API: `API(YYYYMMDD_HHMMSS).html`
  - Mobile: `MOBILE(YYYYMMDD_HHMMSS).html`
- El dashboard estándar de JMeter también se genera en la misma carpeta. Si está disponible Python 3, el `index.html` se reemplaza por el formato personalizado del template.
