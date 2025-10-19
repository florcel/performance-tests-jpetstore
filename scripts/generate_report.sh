#!/bin/bash


set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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
RESULTS_DIR=${RESULTS_DIR:-"results"}

show_help() {
    cat << EOF
Uso: $0 [OPCIONES] [ARCHIVO_JTL]

OPCIONES:
    -h, --help              Mostrar esta ayuda
    -d, --directory DIR     Directorio de resultados (default: $RESULTS_DIR)
    -j, --jmeter-home PATH  Ruta de instalaciÃ³n de JMeter (default: $JMETER_HOME)
    -o, --output DIR        Directorio de salida para el reporte
    -a, --all               Generar reportes para todos los archivos .jtl
    --clean                 Limpiar reportes anteriores

EJEMPLOS:
    $0                                    # Listar archivos .jtl disponibles
    $0 results/results_20240115_143022.jtl # Generar reporte para archivo especÃ­fico
    $0 -a                                 # Generar reportes para todos los archivos
    $0 --clean -a                         # Limpiar y regenerar todos los reportes

EOF
}

check_dependencies() {
    log "Verificando dependencias..."
    
    if ! command -v java &> /dev/null; then
        error "Java no estÃ¡ instalado o no estÃ¡ en el PATH"
        exit 1
    fi
    
    if [ ! -f "$JMETER_HOME/bin/jmeter" ]; then
        error "JMeter no encontrado en $JMETER_HOME"
        error "Por favor, instala JMeter o configura JMETER_HOME correctamente"
        exit 1
    fi
    
    success "Todas las dependencias verificadas correctamente"
}

list_jtl_files() {
    log "Archivos .jtl disponibles en $RESULTS_DIR:"
    echo ""
    
    if [ ! -d "$RESULTS_DIR" ]; then
        warning "Directorio $RESULTS_DIR no existe"
        return 1
    fi
    
    local count=0
    for file in "$RESULTS_DIR"/*.jtl; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local size=$(du -h "$file" | cut -f1)
            local date=$(stat -c %y "$file" 2>/dev/null || stat -f %Sm "$file" 2>/dev/null || echo "N/A")
            echo "  ðŸ“„ $filename ($size) - $date"
            ((count++))
        fi
    done
    
    if [ $count -eq 0 ]; then
        warning "No se encontraron archivos .jtl en $RESULTS_DIR"
        echo ""
        echo "Para generar archivos .jtl, ejecuta primero las pruebas:"
        echo "  ./scripts/run_test.sh"
        return 1
    fi
    
    echo ""
    echo "Total: $count archivo(s) encontrado(s)"
    return 0
}

generate_html_report() {
    local jtl_file="$1"
    local output_dir="$2"
    
    if [ ! -f "$jtl_file" ]; then
        error "Archivo no encontrado: $jtl_file"
        return 1
    fi
    
    log "Generando reporte HTML para: $(basename "$jtl_file")"
    
    mkdir -p "$output_dir"
    
    if "$JMETER_HOME/bin/jmeter" -g "$jtl_file" -o "$output_dir"; then
        success "Reporte HTML generado en: $output_dir"
        return 0
    else
        error "Error generando reporte HTML"
        return 1
    fi
}

clean_reports() {
    log "Limpiando reportes anteriores..."
    
    if [ -d "$RESULTS_DIR" ]; then
        find "$RESULTS_DIR" -name "report_*" -type d -exec rm -rf {} + 2>/dev/null || true
        success "Reportes anteriores eliminados"
    else
        warning "Directorio $RESULTS_DIR no existe"
    fi
}

generate_all_reports() {
    log "Generando reportes para todos los archivos .jtl..."
    
    local count=0
    local success_count=0
    
    for jtl_file in "$RESULTS_DIR"/*.jtl; do
        if [ -f "$jtl_file" ]; then
            local filename=$(basename "$jtl_file" .jtl)
            local output_dir="$RESULTS_DIR/report_$filename"
            
            echo ""
            log "Procesando: $filename"
            
            if generate_html_report "$jtl_file" "$output_dir"; then
                ((success_count++))
            fi
            ((count++))
        fi
    done
    
    echo ""
    success "Procesados $count archivo(s), $success_count reporte(s) generado(s) exitosamente"
}

CLEAN_REPORTS=false
GENERATE_ALL=false
OUTPUT_DIR=""
JTL_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--directory)
            RESULTS_DIR="$2"
            shift 2
            ;;
        -j|--jmeter-home)
            JMETER_HOME="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -a|--all)
            GENERATE_ALL=true
            shift
            ;;
        --clean)
            CLEAN_REPORTS=true
            shift
            ;;
        -*)
            error "OpciÃ³n desconocida: $1"
            show_help
            exit 1
            ;;
        *)
            JTL_FILE="$1"
            shift
            ;;
    esac
done

main() {
    echo "ðŸ“Š JMeter Report Generator"
    echo "========================="
    
    check_dependencies
    
    if [ "$CLEAN_REPORTS" = true ]; then
        clean_reports
    fi
    
    if [ "$GENERATE_ALL" = true ]; then
        generate_all_reports
        exit 0
    fi
    
    if [ -n "$JTL_FILE" ]; then
        if [ -z "$OUTPUT_DIR" ]; then
            local filename=$(basename "$JTL_FILE" .jtl)
            OUTPUT_DIR="$RESULTS_DIR/report_$filename"
        fi
        
        if generate_html_report "$JTL_FILE" "$OUTPUT_DIR"; then
            echo ""
            echo "Para ver el reporte:"
            echo "  open $OUTPUT_DIR/index.html"
            echo "  # o"
            echo "  firefox $OUTPUT_DIR/index.html"
        fi
        exit 0
    fi
    
    list_jtl_files
    
    echo ""
    echo "Para generar un reporte especÃ­fico:"
    echo "  $0 results/nombre_archivo.jtl"
    echo ""
    echo "Para generar reportes para todos los archivos:"
    echo "  $0 -a"
}

main "$@"
