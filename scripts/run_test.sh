#!/bin/bash


set -e  # Salir si cualquier comando falla

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

JMETER_HOME=${JMETER_HOME:-"/opt/apache-jmeter-5.6.3"}
TEST_PLAN=${TEST_PLAN:-"jpetstore_jmeter_testplan.jmx"}
RESULTS_DIR=${RESULTS_DIR:-"results"}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="${RESULTS_DIR}/results_${TIMESTAMP}.jtl"
REPORT_DIR="${RESULTS_DIR}/report_${TIMESTAMP}"

USERS=${USERS:-10}
RAMPUP=${RAMPUP:-60}
DURATION=${DURATION:-300}
TARGET_URL=${TARGET_URL:-"https://petstore.octoperf.com"}

show_help() {
    cat << EOF
Uso: $0 [OPCIONES]

OPCIONES:
    -h, --help              Mostrar esta ayuda
    -u, --users NUM         NÃºmero de usuarios concurrentes (default: $USERS)
    -r, --rampup SEC        Tiempo de ramp-up en segundos (default: $RAMPUP)
    -d, --duration SEC      DuraciÃ³n de la prueba en segundos (default: $DURATION)
    -t, --target URL        URL objetivo (default: $TARGET_URL)
    -j, --jmeter-home PATH  Ruta de instalaciÃ³n de JMeter (default: $JMETER_HOME)
    --gui                   Ejecutar en modo GUI (no recomendado para CI/CD)
    --clean                 Limpiar resultados anteriores

EJEMPLOS:
    $0                                    # Ejecutar con configuraciÃ³n por defecto
    $0 -u 50 -d 600                      # 50 usuarios por 10 minutos
    $0 --clean -u 100 -r 300 -d 1800     # Limpiar y ejecutar prueba larga
    $0 --gui                              # Modo GUI para desarrollo

EOF
}

check_dependencies() {
    log "Verificando dependencias..."
    
    if ! command -v java &> /dev/null; then
        error "Java no estÃ¡ instalado o no estÃ¡ en el PATH"
        exit 1
    fi
    
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 8 ]; then
        error "Se requiere Java 8 o superior. VersiÃ³n actual: $JAVA_VERSION"
        exit 1
    fi
    
    if [ ! -f "$JMETER_HOME/bin/jmeter" ]; then
        error "JMeter no encontrado en $JMETER_HOME"
        error "Por favor, instala JMeter o configura JMETER_HOME correctamente"
        exit 1
    fi
    
    success "Todas las dependencias verificadas correctamente"
}

clean_results() {
    log "Limpiando resultados anteriores..."
    rm -rf "$RESULTS_DIR"/*
    success "Resultados anteriores eliminados"
}

setup_directories() {
    log "Configurando directorios..."
    mkdir -p "$RESULTS_DIR"
    mkdir -p "$REPORT_DIR"
    success "Directorios configurados"
}

run_tests() {
    log "Iniciando pruebas de rendimiento..."
    log "ConfiguraciÃ³n:"
    log "  - Usuarios: $USERS"
    log "  - Ramp-up: ${RAMPUP}s"
    log "  - DuraciÃ³n: ${DURATION}s"
    log "  - URL objetivo: $TARGET_URL"
    log "  - Archivo de resultados: $RESULTS_FILE"
    
    JMETER_CMD="$JMETER_HOME/bin/jmeter"
    
    JMETER_ARGS=(
        -n  # Modo no grÃ¡fico
        -t "$TEST_PLAN"  # Plan de pruebas
        -l "$RESULTS_FILE"  # Archivo de resultados
        -Jusers="$USERS"
        -Jrampup="$RAMPUP"
        -Jduration="$DURATION"
        -Jtarget_url="$TARGET_URL"
        -Jjmeter.save.saveservice.output_format=csv
        -Jjmeter.save.saveservice.response_data=false
        -Jjmeter.save.saveservice.samplerData=false
        -Jjmeter.save.saveservice.requestHeaders=false
        -Jjmeter.save.saveservice.responseHeaders=false
    )
    
    if "$JMETER_CMD" "${JMETER_ARGS[@]}"; then
        success "Pruebas ejecutadas correctamente"
    else
        error "Error durante la ejecuciÃ³n de las pruebas"
        exit 1
    fi
}

generate_report() {
    log "Generando reporte HTML..."
    
    if [ ! -f "$RESULTS_FILE" ]; then
        error "Archivo de resultados no encontrado: $RESULTS_FILE"
        exit 1
    fi
    
    if "$JMETER_HOME/bin/jmeter" -g "$RESULTS_FILE" -o "$REPORT_DIR"; then
        success "Reporte HTML generado en: $REPORT_DIR"
    else
        error "Error generando reporte HTML"
        exit 1
    fi
}

show_summary() {
    log "Resumen de la ejecuciÃ³n:"
    echo "  ðŸ“Š Archivo de resultados: $RESULTS_FILE"
    echo "  ðŸ“ˆ Reporte HTML: $REPORT_DIR/index.html"
    echo "  ðŸ“ Directorio de resultados: $RESULTS_DIR"
    
    if [ -f "$RESULTS_FILE" ]; then
        TOTAL_SAMPLES=$(tail -n +2 "$RESULTS_FILE" | wc -l)
        echo "  ðŸ§ª Total de muestras: $TOTAL_SAMPLES"
    fi
    
    success "Â¡Pruebas completadas exitosamente!"
    echo ""
    echo "Para ver los resultados:"
    echo "  open $REPORT_DIR/index.html"
    echo "  # o"
    echo "  firefox $REPORT_DIR/index.html"
}

GUI_MODE=false
CLEAN_RESULTS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -u|--users)
            USERS="$2"
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
        --gui)
            GUI_MODE=true
            shift
            ;;
        --clean)
            CLEAN_RESULTS=true
            shift
            ;;
        *)
            error "OpciÃ³n desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

main() {
    echo "ðŸš€ JMeter Performance Testing Suite"
    echo "=================================="
    
    check_dependencies
    
    if [ "$CLEAN_RESULTS" = true ]; then
        clean_results
    fi
    
    setup_directories
    
    if [ "$GUI_MODE" = true ]; then
        warning "Ejecutando en modo GUI..."
        "$JMETER_HOME/bin/jmeter" -t "$TEST_PLAN"
    else
        run_tests
        generate_report
        show_summary
    fi
}

main "$@"
