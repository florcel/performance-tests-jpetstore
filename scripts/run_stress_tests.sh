#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

JMETER_HOME=${JMETER_HOME:-"/opt/apache-jmeter-5.6.3"}
TEST_PLAN="$ROOT/test-plans/stress-tests.jmx"
RESULTS_DIR="$ROOT/results/stress-tests"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="${RESULTS_DIR}/stress_${TIMESTAMP}.jtl"
REPORT_DIR="${RESULTS_DIR}/stress_report_${TIMESTAMP}"
FINAL_HTML="${RESULTS_DIR}/stress(${TIMESTAMP}).html"

MAX_USERS=${MAX_USERS:-200}
RAMPUP=${RAMPUP:-600}
DURATION=${DURATION:-1200}
TARGET_URL=${TARGET_URL:-"https://petstore.octoperf.com"}

log() { echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

show_help() {
  cat << EOF
Uso: $0 [OPCIONES]

Pruebas de estrés para encontrar el punto de falla del sistema

OPCIONES:
  -h, --help              Mostrar esta ayuda
  -m, --max-users NUM     Número máximo de usuarios (default: $MAX_USERS)
  -r, --rampup SEC        Tiempo de ramp-up en segundos (default: $RAMPUP)
  -d, --duration SEC      Duración de la prueba en segundos (default: $DURATION)
  -t, --target URL        URL objetivo (default: $TARGET_URL)
  -j, --jmeter-home PATH  Ruta de instalación de JMeter (default: $JMETER_HOME)
EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help) show_help; exit 0;;
    -m|--max-users) MAX_USERS="$2"; shift 2;;
    -r|--rampup) RAMPUP="$2"; shift 2;;
    -d|--duration) DURATION="$2"; shift 2;;
    -t|--target) TARGET_URL="$2"; shift 2;;
    -j|--jmeter-home) JMETER_HOME="$2"; shift 2;;
    *) error "Opción desconocida: $1"; show_help; exit 1;;
  esac
done

main() {
  echo "🚀 Stress Tests - JPetStore"
  echo "==========================="

  mkdir -p "$RESULTS_DIR" "$REPORT_DIR"

  log "Configuración:"
  log "  - Usuarios máximos: $MAX_USERS"
  log "  - Ramp-up: ${RAMPUP}s ($(($RAMPUP/60)) minutos)"
  log "  - Duración: ${DURATION}s ($(($DURATION/60)) minutos)"
  log "  - URL objetivo: $TARGET_URL"
  log "  - Archivo de resultados: $RESULTS_FILE"

  "$JMETER_HOME/bin/jmeter" \
    -n \
    -t "$TEST_PLAN" \
    -l "$RESULTS_FILE" \
    -JMAX_USERS="$MAX_USERS" \
    -JTARGET_URL="$TARGET_URL" \
    -Jjmeter.save.saveservice.output_format=csv

  log "Generando dashboard HTML de JMeter..."
  "$JMETER_HOME/bin/jmeter" -g "$RESULTS_FILE" -o "$REPORT_DIR"

  if command -v python3 >/dev/null 2>&1; then
    python3 "$ROOT/scripts/generate_enhanced_report.py" "$RESULTS_FILE" -o "$REPORT_DIR/stress(${TIMESTAMP}).html" -v || true
    cp -f "$REPORT_DIR/stress(${TIMESTAMP}).html" "$FINAL_HTML" 2>/dev/null || true
  fi

  success "Reporte: $FINAL_HTML"
  echo "Para abrir: open $FINAL_HTML"
}

main "$@"

