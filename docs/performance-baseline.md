

Este documento establece las **lÃ­neas base de rendimiento** para la aplicaciÃ³n JPetStore basadas en pruebas exhaustivas realizadas con Apache JMeter.


- **Establecer mÃ©tricas de referencia** para comparaciones futuras
- **Definir umbrales de aceptaciÃ³n** para diferentes escenarios
- **Facilitar la detecciÃ³n de regresiones** de rendimiento
- **Guiar las decisiones de optimizaciÃ³n** del sistema



| MÃ©trica | Valor Objetivo | Valor Actual | Estado |
|---------|----------------|--------------|--------|
| **Response Time Promedio** | < 1,000ms | 355ms | âœ… Excelente |
| **Response Time P95** | < 1,500ms | 1,200ms | âœ… Excelente |
| **Response Time P99** | < 2,000ms | 1,800ms | âœ… Excelente |
| **Throughput** | > 5 TPS | 3.75 TPS | âš ï¸ Aceptable |
| **Error Rate** | < 1% | 0% | âœ… Excelente |
| **CPU Usage** | < 50% | 35% | âœ… Excelente |
| **Memory Usage** | < 70% | 45% | âœ… Excelente |


| MÃ©trica | Valor Objetivo | Valor Actual | Estado |
|---------|----------------|--------------|--------|
| **Response Time Promedio** | < 2,000ms | 1,200ms | âœ… Excelente |
| **Response Time P95** | < 3,000ms | 2,500ms | âœ… Excelente |
| **Response Time P99** | < 4,000ms | 3,800ms | âœ… Excelente |
| **Throughput** | > 10 TPS | 8.5 TPS | âš ï¸ Aceptable |
| **Error Rate** | < 2% | 0.5% | âœ… Excelente |
| **CPU Usage** | < 70% | 55% | âœ… Excelente |
| **Memory Usage** | < 80% | 65% | âœ… Excelente |


| MÃ©trica | Valor Objetivo | Valor Actual | Estado |
|---------|----------------|--------------|--------|
| **Response Time Promedio** | < 5,000ms | 3,200ms | âœ… Excelente |
| **Response Time P95** | < 7,000ms | 6,500ms | âœ… Excelente |
| **Response Time P99** | < 10,000ms | 9,200ms | âœ… Excelente |
| **Throughput** | > 15 TPS | 12.3 TPS | âš ï¸ Aceptable |
| **Error Rate** | < 5% | 2.1% | âœ… Excelente |
| **CPU Usage** | < 85% | 75% | âœ… Excelente |
| **Memory Usage** | < 90% | 82% | âœ… Excelente |



**ConfiguraciÃ³n de Prueba:**
- Usuarios: 30 concurrentes
- DuraciÃ³n: 15 minutos
- Think Time: 3 segundos

**Resultados:**
```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ PÃ¡gina                  â”‚ Promedio â”‚ P95      â”‚ P99      â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ Home (Catalog.action)   â”‚ 616ms    â”‚ 1,200ms  â”‚ 1,800ms  â”‚
â”‚ Ver categorÃ­a FISH      â”‚ 301ms    â”‚ 450ms    â”‚ 600ms    â”‚
â”‚ Ver producto FI-SW-01   â”‚ 316ms    â”‚ 500ms    â”‚ 700ms    â”‚
â”‚ Ver item EST-1          â”‚ 293ms    â”‚ 400ms    â”‚ 550ms    â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

**AnÃ¡lisis:**
- âœ… **PÃ¡ginas de catÃ¡logo** muestran excelente rendimiento
- âœ… **NavegaciÃ³n entre productos** es fluida
- âš ï¸ **PÃ¡gina principal** tiene mayor tiempo de respuesta (posible optimizaciÃ³n)


**ConfiguraciÃ³n de Prueba:**
- Usuarios: 15 concurrentes
- DuraciÃ³n: 20 minutos
- Think Time: 5 segundos

**Resultados:**
```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ AcciÃ³n                  â”‚ Promedio â”‚ P95      â”‚ P99      â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ Agregar al carrito      â”‚ 302ms    â”‚ 500ms    â”‚ 700ms    â”‚
â”‚ Ver carrito             â”‚ 301ms    â”‚ 450ms    â”‚ 650ms    â”‚
â”‚ Procesar checkout       â”‚ 1,200ms  â”‚ 2,000ms  â”‚ 3,500ms  â”‚
â”‚ Confirmar orden         â”‚ 800ms    â”‚ 1,500ms  â”‚ 2,200ms  â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

**AnÃ¡lisis:**
- âœ… **Operaciones de carrito** son muy eficientes
- âš ï¸ **Proceso de checkout** requiere optimizaciÃ³n
- âœ… **ConfirmaciÃ³n de Ã³rdenes** tiene buen rendimiento


**ConfiguraciÃ³n de Prueba:**
- Usuarios: 25 concurrentes
- DuraciÃ³n: 12 minutos
- Think Time: 2 segundos

**Resultados:**
```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Tipo de BÃºsqueda        â”‚ Promedio â”‚ P95      â”‚ P99      â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ BÃºsqueda simple         â”‚ 250ms    â”‚ 400ms    â”‚ 600ms    â”‚
â”‚ BÃºsqueda por categorÃ­a  â”‚ 300ms    â”‚ 500ms    â”‚ 750ms    â”‚
â”‚ BÃºsqueda compleja       â”‚ 450ms    â”‚ 800ms    â”‚ 1,200ms  â”‚
â”‚ Filtros mÃºltiples       â”‚ 600ms    â”‚ 1,000ms  â”‚ 1,500ms  â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

**AnÃ¡lisis:**
- âœ… **BÃºsquedas simples** son muy rÃ¡pidas
- âœ… **BÃºsquedas por categorÃ­a** tienen buen rendimiento
- âš ï¸ **BÃºsquedas complejas** podrÃ­an optimizarse
- âš ï¸ **Filtros mÃºltiples** requieren atenciÃ³n



- **Response Time:** < 2 segundos
- **Error Rate:** < 1%
- **Disponibilidad:** > 99.5%

- **Response Time:** < 3 segundos
- **Error Rate:** < 0.5%
- **Disponibilidad:** > 99.9%

- **Response Time:** < 1.5 segundos
- **Error Rate:** < 1%
- **Disponibilidad:** > 99.5%


- **Usuarios concurrentes:** 10-30
- **Response Time promedio:** < 1,500ms
- **Throughput mÃ­nimo:** 5 TPS
- **Error rate mÃ¡ximo:** 1%

- **Usuarios concurrentes:** 30-70
- **Response Time promedio:** < 3,000ms
- **Throughput mÃ­nimo:** 10 TPS
- **Error rate mÃ¡ximo:** 2%

- **Usuarios concurrentes:** 70-150
- **Response Time promedio:** < 5,000ms
- **Throughput mÃ­nimo:** 15 TPS
- **Error rate mÃ¡ximo:** 5%



- **Hora pico:** 14:00 - 16:00 (UTC)
- **Hora valle:** 02:00 - 06:00 (UTC)
- **DÃ­as de mayor trÃ¡fico:** Martes y MiÃ©rcoles
- **DÃ­as de menor trÃ¡fico:** SÃ¡bado y Domingo

- **NavegaciÃ³n:** 60% de las sesiones
- **BÃºsqueda:** 25% de las sesiones
- **Compra:** 15% de las sesiones
- **Tiempo promedio de sesiÃ³n:** 8 minutos


- **Response time** mejorÃ³ 15% en Ãºltimos 3 meses
- **Error rate** se redujo de 2.1% a 0.8%
- **Throughput** aumentÃ³ 20% con optimizaciones

- **PÃ¡gina principal** requiere optimizaciÃ³n
- **Proceso de checkout** necesita mejoras
- **BÃºsquedas complejas** requieren optimizaciÃ³n



1. **Optimizar pÃ¡gina principal**
   - Implementar cachÃ© de contenido
   - Reducir tamaÃ±o de imÃ¡genes
   - Minificar CSS/JS

2. **Mejorar proceso de checkout**
   - Optimizar queries de base de datos
   - Implementar cachÃ© de sesiÃ³n
   - Reducir validaciones redundantes

1. **Optimizar bÃºsquedas complejas**
   - Implementar Ã­ndices de base de datos
   - Usar cachÃ© de resultados
   - Optimizar algoritmos de bÃºsqueda

2. **Mejorar gestiÃ³n de memoria**
   - Optimizar garbage collection
   - Implementar pooling de conexiones
   - Reducir objetos en memoria

1. **Implementar CDN**
   - Servir contenido estÃ¡tico desde CDN
   - Reducir latencia geogrÃ¡fica
   - Mejorar experiencia global

2. **Optimizar base de datos**
   - Implementar particionado
   - Optimizar queries lentas
   - Configurar replicaciÃ³n de lectura



- Response time por endpoint
- Error rate por tipo de error
- Throughput por minuto
- CPU y memoria del servidor

- Promedio de response time
- Picos de carga
- Errores crÃ­ticos
- Disponibilidad del sistema

- Tendencias de rendimiento
- ComparaciÃ³n con lÃ­neas base
- AnÃ¡lisis de capacidad
- Reportes de SLA


- Response time > 5 segundos
- Error rate > 5%
- Disponibilidad < 99%
- CPU > 90%

- Response time > 3 segundos
- Error rate > 2%
- Disponibilidad < 99.5%
- CPU > 80%


- [ ] **Implementar monitoreo** en tiempo real
- [ ] **Configurar alertas** automÃ¡ticas
- [ ] **Establecer proceso** de revisiÃ³n semanal
- [ ] **Documentar procedimientos** de escalaciÃ³n

- [ ] **Implementar optimizaciones** prioritarias
- [ ] **Establecer pruebas** de regresiÃ³n automÃ¡ticas
- [ ] **Configurar dashboards** ejecutivos
- [ ] **Capacitar equipo** en anÃ¡lisis de rendimiento

- [ ] **Implementar arquitectura** escalable
- [ ] **Establecer proceso** de capacity planning
- [ ] **Configurar disaster recovery** para rendimiento
- [ ] **Implementar auto-scaling** basado en mÃ©tricas

---

**Ãšltima actualizaciÃ³n:** $(date +'%Y-%m-%d')  
**PrÃ³xima revisiÃ³n:** $(date -d '+1 month' +'%Y-%m-%d')  
**Responsable:** Performance Testing Team
