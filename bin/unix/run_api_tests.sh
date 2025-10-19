#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

JMETER_HOME=${JMETER_HOME:-"/opt/apache-jmeter-5.6.3"}
TEST_PLAN="$ROOT/test-plans/api-performance-tests.jmx"
RESULTS_DIR="$ROOT/results/api-tests"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="${RESULTS_DIR}/api_results_${TIMESTAMP}.jtl"
REPORT_DIR="${RESULTS_DIR}/api_report_${TIMESTAMP}"
HTML_NAME="api(${TIMESTAMP}).html"
FINAL_HTML="${RESULTS_DIR}/api(${TIMESTAMP}).html"

USERS=${USERS:-20}
RAMPUP=${RAMPUP:-60}
PERIOD=${DURATION:-300}
BASE_URL=${BASE_URL:-"https://petstore.octoperf.com"}

log() { echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Variabilidad configurable
SLOW_PCT=${SLOW_PCT:-20}
SLOW_MIN=${SLOW_MIN:-800}
SLOW_MAX=${SLOW_MAX:-3000}
ERR_PCT=${ERR_PCT:-10}
RT_MAX=${RT_MAX:-1000}

# Flags CLI
while [[ $# -gt 0 ]]; do
  case $1 in
    --slow-pct) SLOW_PCT="$2"; shift 2 ;;
    --slow-min) SLOW_MIN="$2"; shift 2 ;;
    --slow-max) SLOW_MAX="$2"; shift 2 ;;
    --err-pct)  ERR_PCT="$2";  shift 2 ;;
    --rt-max)   RT_MAX="$2";   shift 2 ;;
    *) shift ;;
  esac
done

mkdir -p "$RESULTS_DIR" "$REPORT_DIR"

if [ ! -f "$JMETER_HOME/bin/jmeter" ]; then error "JMeter no encontrado en $JMETER_HOME"; exit 1; fi
if [ ! -f "$TEST_PLAN" ]; then error "Plan no encontrado: $TEST_PLAN"; exit 1; fi

log "Ejecutando pruebas de API..."
"$JMETER_HOME/bin/jmeter" -n -t "$TEST_PLAN" -l "$RESULTS_FILE" \
  -Jusers="$USERS" -Jrampup="$RAMPUP" -Jduration="$PERIOD" -JBASE_URL="$BASE_URL" \
  -JSLOW_PCT="$SLOW_PCT" -JSLOW_MIN="$SLOW_MIN" -JSLOW_MAX="$SLOW_MAX" -JERR_PCT="$ERR_PCT" -JRT_MAX="$RT_MAX" \
  -Jjmeter.save.saveservice.output_format=csv

log "Generando dashboard..."
"$JMETER_HOME/bin/jmeter" -g "$RESULTS_FILE" -o "$REPORT_DIR"

if command -v python3 >/dev/null 2>&1; then
  log "Aplicando formato HTML personalizado..."
  python3 "$ROOT/scripts/generate_enhanced_report.py" "$RESULTS_FILE" -o "$REPORT_DIR/$HTML_NAME" -v || warning "No se pudo aplicar el formato personalizado"
fi

src="$REPORT_DIR/$HTML_NAME"; [ ! -f "$src" ] && src="$REPORT_DIR/index.html"; cp -f "$src" "$FINAL_HTML" 2>/dev/null || true
success "Reporte: $FINAL_HTML"
echo "Para abrir: open $FINAL_HTML"
