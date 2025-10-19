#!/bin/bash


echo "ðŸŸ¢ Ejecutando Prueba de Carga Ligera"
echo "=================================="

export USERS=5
export RAMPUP=30
export DURATION=120
export TARGET_URL="https://petstore.octoperf.com"

echo "ConfiguraciÃ³n:"
echo "  - Usuarios concurrentes: $USERS"
echo "  - Ramp-up: ${RAMPUP}s"
echo "  - DuraciÃ³n: ${DURATION}s"
echo "  - URL objetivo: $TARGET_URL"
echo ""

./scripts/run_test.sh

echo ""
echo "âœ… Prueba de carga ligera completada"
echo "ðŸ“Š Revisa los resultados en: results/report_*/index.html"
