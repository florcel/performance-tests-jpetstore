#!/bin/bash
set -e

# Anchor paths relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

JMETER_HOME=${JMETER_HOME:-"/opt/apache-jmeter-5.6.3"}
TEST_PLAN="$ROOT/test-plans/mobile-performance-tests.jmx"
RESULTS_DIR="$ROOT/results/mobile-tests"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="${RESULTS_DIR}/mobile_${TIMESTAMP}.jtl"
REPORT_DIR="${RESULTS_DIR}/report_${TIMESTAMP}"
HTML_NAME="mobile(${TIMESTAMP}).html"
FINAL_HTML="${RESULTS_DIR}/mobile(${TIMESTAMP}).html"

mkdir -p "$RESULTS_DIR" "$REPORT_DIR"
"$JMETER_HOME/bin/jmeter" -n -t "$TEST_PLAN" -l "$RESULTS_FILE" -JBASE_HOST=petstore.octoperf.com -JBASE_SCHEME=https
"$JMETER_HOME/bin/jmeter" -g "$RESULTS_FILE" -o "$REPORT_DIR"

python3 "$ROOT/scripts/generate_enhanced_report.py" "$RESULTS_FILE" -o "$REPORT_DIR/$HTML_NAME" -v || true
src="$REPORT_DIR/$HTML_NAME"; [ ! -f "$src" ] && src="$REPORT_DIR/index.html"; cp -f "$src" "$FINAL_HTML" 2>/dev/null || true
echo "Reporte mobile: $FINAL_HTML"
#!/bin/bash
set -e

# Anchor paths relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

JMETER_HOME=${JMETER_HOME:-"/opt/apache-jmeter-5.6.3"}
TEST_PLAN="$ROOT/test-plans/mobile-performance-tests.jmx"
RESULTS_DIR="$ROOT/results/mobile-tests"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="${RESULTS_DIR}/mobile_${TIMESTAMP}.jtl"
REPORT_DIR="${RESULTS_DIR}/report_${TIMESTAMP}"
HTML_NAME="MOBILE(${TIMESTAMP}).html"

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
"$JMETER_HOME/bin/jmeter" -n -t "$TEST_PLAN" -l "$RESULTS_FILE" \
  -JBASE_HOST=petstore.octoperf.com -JBASE_SCHEME=https \
  -JSLOW_PCT="$SLOW_PCT" -JSLOW_MIN="$SLOW_MIN" -JSLOW_MAX="$SLOW_MAX" -JERR_PCT="$ERR_PCT" -JRT_MAX="$RT_MAX"
"$JMETER_HOME/bin/jmeter" -g "$RESULTS_FILE" -o "$REPORT_DIR"

python3 "$ROOT/scripts/generate_enhanced_report.py" "$RESULTS_FILE" -o "$REPORT_DIR/$HTML_NAME" -v || true
echo "Reporte mobile: $REPORT_DIR/$HTML_NAME"
