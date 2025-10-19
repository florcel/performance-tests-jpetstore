#!/bin/bash


set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

JMETER_HOME=${JMETER_HOME:-"/opt/apache-jmeter-5.6.3"}
TEST_PLAN="test-plans/stress-tests.jmx"
RESULTS_DIR="results/stress-tests"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="${RESULTS_DIR}/stress_results_${TIMESTAMP}.jtl"
REPORT_DIR="${RESULTS_DIR}/stress_report_${TIMESTAMP}"

MAX_USERS=${MAX_USERS:-200}
RAMPUP=${RAMPUP:-600}
DURATION=${DURATION:-1200}
TARGET_URL=${TARGET_URL:-"https://petstore.octoperf.com"}

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

show_help() {
    cat << EOF
Uso: $0 [OPCIONES]

Pruebas de estrÃ©s para encontrar el punto de falla del sistema

OPCIONES:
    -h, --help              Mostrar esta ayuda
    -m, --max-users NUM     NÃºmero mÃ¡ximo de usuarios (default: $MAX_USERS)
    -r, --rampup SEC        Tiempo de ramp-up en segundos (default: $RAMPUP)
    -d, --duration SEC      DuraciÃ³n de la prueba en segundos (default: $DURATION)
    -t, --target URL        URL objetivo (default: $TARGET_URL)
    -j, --jmeter-home PATH  Ruta de instalaciÃ³n de JMeter (default: $JMETER_HOME)

EJEMPLOS:
    $0                                    # Ejecutar con configuraciÃ³n por defecto
    $0 -m 500 -d 1800                    # 500 usuarios por 30 minutos
    $0 -m 100 -r 300 -d 600              # Prueba mÃ¡s corta con 100 usuarios

âš ï¸  ADVERTENCIA: Las pruebas de estrÃ©s requieren recursos significativos
   - MÃ­nimo 8GB RAM recomendado
   - CPU de 4+ cores recomendado
   - ConexiÃ³n de red estable

EOF
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -m|--max-users)
            MAX_USERS="$2"
            shift 2
            ;;
        -r|--rampup)
            RAMPUP="$2"
            shift 2
            ;;
        -d|--duration)
            DURATION="$2"
            shift 2
            ;;
        -t|--target)
            TARGET_URL="$2"
            shift 2
            ;;
        -j|--jmeter-home)
            JMETER_HOME="$2"
            shift 2
            ;;
        *)
            error "OpciÃ³n desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

main() {
    echo "ðŸ”¥ Stress Tests - JPetStore"
    echo "==========================="
    
    warning "ADVERTENCIA: Esta es una prueba de estrÃ©s que puede sobrecargar el sistema"
    warning "AsegÃºrate de tener suficientes recursos disponibles"
    echo ""
    
    log "ConfiguraciÃ³n:"
    log "  - Usuarios mÃ¡ximos: $MAX_USERS"
    log "  - Ramp-up: ${RAMPUP}s ($(($RAMPUP/60)) minutos)"
    log "  - DuraciÃ³n: ${DURATION}s ($(($DURATION/60)) minutos)"
    log "  - URL objetivo: $TARGET_URL"
    log "  - Archivo de resultados: $RESULTS_FILE"
    
    read -p "Â¿Continuar con la prueba de estrÃ©s? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "âŒ Prueba cancelada por el usuario"
        exit 1
    fi
    
    mkdir -p "$RESULTS_DIR"
    mkdir -p "$REPORT_DIR"
    
    if [ ! -f "$JMETER_HOME/bin/jmeter" ]; then
        error "JMeter no encontrado en $JMETER_HOME"
        exit 1
    fi
    
    if [ ! -f "$TEST_PLAN" ]; then
        error "Plan de pruebas no encontrado: $TEST_PLAN"
        exit 1
    fi
    
    log "Ejecutando pruebas de estrÃ©s..."
    "$JMETER_HOME/bin/jmeter" \
        -n \
        -t "$TEST_PLAN" \
        -l "$RESULTS_FILE" \
        -JMAX_USERS="$MAX_USERS" \
        -JTARGET_URL="$TARGET_URL" \
        -Jjmeter.save.saveservice.output_format=csv
    
    if [ $? -eq 0 ]; then
        success "Pruebas de estrÃ©s ejecutadas correctamente"
    else
        error "Error durante la ejecuciÃ³n de las pruebas"
        exit 1
    fi
    
    log "Generando reporte HTML..."
    "$JMETER_HOME/bin/jmeter" -g "$RESULTS_FILE" -o "$REPORT_DIR"
    
    if [ $? -eq 0 ]; then
        success "Reporte HTML generado en: $REPORT_DIR"
    else
        error "Error generando reporte HTML"
        exit 1
    fi
    
    log "Resumen de la ejecuciÃ³n:"
    echo "  ðŸ“Š Archivo de resultados: $RESULTS_FILE"
    echo "  ðŸ“ˆ Reporte HTML: $REPORT_DIR/index.html"
    echo "  ðŸ“ Directorio de resultados: $RESULTS_DIR"
    
    if [ -f "$RESULTS_FILE" ]; then
        TOTAL_SAMPLES=$(tail -n +2 "$RESULTS_FILE" | wc -l)
        echo "  ðŸ§ª Total de muestras: $TOTAL_SAMPLES"
    fi
    
    success "Â¡Pruebas de estrÃ©s completadas exitosamente!"
    echo ""
    echo "Para ver los resultados:"
    echo "  open $REPORT_DIR/index.html"
    echo ""
    warning "Analiza cuidadosamente los resultados para identificar:"
    echo "  - Punto de degradaciÃ³n del rendimiento"
    echo "  - Tiempo de respuesta bajo carga extrema"
    echo "  - Tasa de errores en condiciones de estrÃ©s"
    echo "  - Comportamiento de recuperaciÃ³n del sistema"
}

main "$@"
