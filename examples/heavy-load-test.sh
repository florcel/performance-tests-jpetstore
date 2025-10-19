#!/bin/bash


echo "ðŸ”´ Ejecutando Prueba de Carga Pesada"
echo "=================================="

export USERS=100
export RAMPUP=300
export DURATION=600
export TARGET_URL="https://petstore.octoperf.com"

echo "ConfiguraciÃ³n:"
echo "  - Usuarios concurrentes: $USERS"
echo "  - Ramp-up: ${RAMPUP}s (5 minutos)"
echo "  - DuraciÃ³n: ${DURATION}s (10 minutos)"
echo "  - URL objetivo: $TARGET_URL"
echo ""

echo "âš ï¸  ADVERTENCIA: Esta prueba requiere recursos significativos"
echo "   - MÃ­nimo 8GB RAM recomendado"
echo "   - CPU de 4+ cores recomendado"
echo "   - ConexiÃ³n de red estable"
echo ""

read -p "Â¿Continuar con la prueba de carga pesada? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "âŒ Prueba cancelada por el usuario"
    exit 1
fi

./scripts/run_test.sh

echo ""
echo "âœ… Prueba de carga pesada completada"
echo "ðŸ“Š Revisa los resultados en: results/report_*/index.html"
echo "âš ï¸  Analiza cuidadosamente los resultados para identificar cuellos de botella"
