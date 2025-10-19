#!/bin/bash


echo "ðŸŽ›ï¸  ConfiguraciÃ³n de Escenario Personalizado"
echo "=========================================="

validate_number() {
    local num=$1
    if ! [[ "$num" =~ ^[0-9]+$ ]]; then
        echo "âŒ Error: Debe ingresar un nÃºmero vÃ¡lido"
        return 1
    fi
    return 0
}

validate_url() {
    local url=$1
    if [[ $url =~ ^https?:// ]]; then
        return 0
    else
        echo "âŒ Error: URL debe comenzar con http:// o https://"
        return 1
    fi
}

echo "Configura los parÃ¡metros de tu prueba:"
echo ""

while true; do
    read -p "ðŸ‘¥ NÃºmero de usuarios concurrentes (1-200): " USERS
    if validate_number "$USERS" && [ "$USERS" -ge 1 ] && [ "$USERS" -le 200 ]; then
        break
    fi
    echo "âŒ Por favor, ingresa un nÃºmero entre 1 y 200"
done

while true; do
    read -p "â±ï¸  Tiempo de ramp-up en segundos (10-1800): " RAMPUP
    if validate_number "$RAMPUP" && [ "$RAMPUP" -ge 10 ] && [ "$RAMPUP" -le 1800 ]; then
        break
    fi
    echo "âŒ Por favor, ingresa un nÃºmero entre 10 y 1800"
done

while true; do
    read -p "â° DuraciÃ³n de la prueba en segundos (60-3600): " DURATION
    if validate_number "$DURATION" && [ "$DURATION" -ge 60 ] && [ "$DURATION" -le 3600 ]; then
        break
    fi
    echo "âŒ Por favor, ingresa un nÃºmero entre 60 y 3600"
done

while true; do
    read -p "ðŸŒ URL objetivo (default: https://petstore.octoperf.com): " TARGET_URL
    if [ -z "$TARGET_URL" ]; then
        TARGET_URL="https://petstore.octoperf.com"
        break
    fi
    if validate_url "$TARGET_URL"; then
        break
    fi
done

echo ""
echo "ðŸ”§ ConfiguraciÃ³n adicional:"
read -p "ðŸ“ Nombre del test (opcional): " TEST_NAME
read -p "ðŸ“Š Generar reporte detallado? (y/N): " -n 1 -r GENERATE_DETAILED
echo

export USERS
export RAMPUP
export DURATION
export TARGET_URL

echo ""
echo "ðŸ“‹ Resumen de ConfiguraciÃ³n:"
echo "============================"
echo "  ðŸ‘¥ Usuarios concurrentes: $USERS"
echo "  â±ï¸  Ramp-up: ${RAMPUP}s"
echo "  â° DuraciÃ³n: ${DURATION}s"
echo "  ðŸŒ URL objetivo: $TARGET_URL"
if [ ! -z "$TEST_NAME" ]; then
    echo "  ðŸ“ Nombre del test: $TEST_NAME"
fi
echo "  ðŸ“Š Reporte detallado: $([ "$GENERATE_DETAILED" =~ ^[Yy]$ ] && echo "SÃ­" || echo "No")"
echo ""

read -p "Â¿Ejecutar la prueba con esta configuraciÃ³n? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "âŒ Prueba cancelada por el usuario"
    exit 1
fi

echo ""
echo "ðŸš€ Iniciando prueba personalizada..."
./scripts/run_test.sh

echo ""
echo "âœ… Prueba personalizada completada"
echo "ðŸ“Š Revisa los resultados en: results/report_*/index.html"

echo ""
echo "ðŸ’¡ Recomendaciones:"
if [ "$USERS" -gt 50 ]; then
    echo "  âš ï¸  Con $USERS usuarios, monitorea cuidadosamente los recursos del sistema"
fi
if [ "$DURATION" -gt 1800 ]; then
    echo "  âš ï¸  Prueba larga detectada. Considera ejecutar en horarios de bajo trÃ¡fico"
fi
if [ "$RAMPUP" -lt 60 ] && [ "$USERS" -gt 20 ]; then
    echo "  âš ï¸  Ramp-up rÃ¡pido con muchos usuarios puede causar picos de carga"
fi
