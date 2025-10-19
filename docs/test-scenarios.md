

Este documento describe los diferentes escenarios de prueba implementados en el plan de pruebas de JMeter para la aplicaciÃ³n JPetStore.


- **Medir el rendimiento** bajo diferentes cargas de usuarios
- **Identificar cuellos de botella** en la aplicaciÃ³n
- **Validar la escalabilidad** del sistema
- **Establecer lÃ­neas base** de rendimiento

- **Comparar versiones** de la aplicaciÃ³n
- **Optimizar recursos** del servidor
- **Mejorar la experiencia** del usuario
- **Planificar capacidad** futura


```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚   JMeter        â”‚    â”‚   Load Balancer â”‚    â”‚   JPetStore     â”‚
â”‚   (Load         â”‚â”€â”€â”€â–¶â”‚   (Optional)    â”‚â”€â”€â”€â–¶â”‚   Application   â”‚
â”‚   Generator)    â”‚    â”‚                 â”‚    â”‚                 â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
         â”‚                       â”‚                       â”‚
         â–¼                       â–¼                       â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚   Results       â”‚    â”‚   Monitoring    â”‚    â”‚   Database      â”‚
â”‚   Collection    â”‚    â”‚   Tools         â”‚    â”‚   (H2/MySQL)    â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```


**Objetivo:** Simular usuarios explorando productos sin realizar compras.

**Flujo de Usuario:**
1. Acceder a la pÃ¡gina principal
2. Navegar por categorÃ­as (FISH, DOGS, CATS, REPTILES, BIRDS)
3. Ver detalles de productos especÃ­ficos
4. Explorar diferentes pÃ¡ginas del catÃ¡logo

**MÃ©tricas Clave:**
- Tiempo de respuesta de pÃ¡ginas del catÃ¡logo
- Throughput de navegaciÃ³n
- Tasa de errores en navegaciÃ³n

**ConfiguraciÃ³n:**
- Usuarios concurrentes: 10-50
- DuraciÃ³n: 5-15 minutos
- Think time: 2-5 segundos entre requests

**Objetivo:** Simular el proceso completo de compra desde selecciÃ³n hasta checkout.

**Flujo de Usuario:**
1. Acceder a la pÃ¡gina principal
2. Buscar y seleccionar un producto
3. Agregar al carrito de compras
4. Proceder al checkout
5. Completar informaciÃ³n de envÃ­o
6. Confirmar la orden

**MÃ©tricas Clave:**
- Tiempo de respuesta del proceso de compra
- Tasa de conversiÃ³n (Ã³rdenes completadas)
- Errores en el proceso de checkout

**ConfiguraciÃ³n:**
- Usuarios concurrentes: 5-25
- DuraciÃ³n: 10-30 minutos
- Think time: 3-8 segundos entre acciones

**Objetivo:** Evaluar el rendimiento de la funcionalidad de bÃºsqueda.

**Flujo de Usuario:**
1. Acceder a la pÃ¡gina principal
2. Realizar bÃºsquedas con diferentes tÃ©rminos
3. Filtrar resultados por categorÃ­a
4. Navegar por pÃ¡ginas de resultados

**MÃ©tricas Clave:**
- Tiempo de respuesta de bÃºsquedas
- PrecisiÃ³n de resultados
- Rendimiento con bÃºsquedas complejas

**ConfiguraciÃ³n:**
- Usuarios concurrentes: 15-40
- DuraciÃ³n: 8-20 minutos
- Think time: 1-3 segundos entre bÃºsquedas

**Objetivo:** Evaluar el comportamiento del sistema con incremento gradual de carga.

**Estrategia de Carga:**
- Ramp-up: Incremento gradual de usuarios
- Sustained load: Carga constante
- Ramp-down: ReducciÃ³n gradual

**ConfiguraciÃ³n:**
- Usuarios mÃ¡ximos: 100
- Ramp-up time: 10 minutos
- Sustained duration: 20 minutos
- Ramp-down time: 5 minutos



- **Usuarios:** 5-10 concurrentes
- **DuraciÃ³n:** 5-10 minutos
- **Objetivo:** Validar funcionalidad bÃ¡sica
- **Umbrales:**
  - Response time < 1s
  - Error rate < 1%

- **Usuarios:** 20-50 concurrentes
- **DuraciÃ³n:** 15-30 minutos
- **Objetivo:** Evaluar rendimiento normal
- **Umbrales:**
  - Response time < 2s
  - Error rate < 2%

- **Usuarios:** 50-100 concurrentes
- **DuraciÃ³n:** 30-60 minutos
- **Objetivo:** Identificar lÃ­mites del sistema
- **Umbrales:**
  - Response time < 5s
  - Error rate < 5%

- **Usuarios:** 100+ concurrentes
- **DuraciÃ³n:** 60+ minutos
- **Objetivo:** Encontrar punto de falla
- **Umbrales:**
  - Identificar punto de degradaciÃ³n
  - Medir tiempo de recuperaciÃ³n


- **Response Time (Tiempo de Respuesta)**
  - Promedio, mediana, percentiles (P90, P95, P99)
  - Tiempo de conexiÃ³n y latencia
  - Tiempo de procesamiento del servidor

- **Throughput (Rendimiento)**
  - Transacciones por segundo (TPS)
  - Requests por segundo (RPS)
  - Bytes por segundo

- **Error Rate (Tasa de Errores)**
  - Porcentaje de requests fallidos
  - Tipos de errores (4xx, 5xx)
  - Timeouts y conexiones rechazadas

- **CPU Usage** - UtilizaciÃ³n del procesador
- **Memory Usage** - Uso de memoria RAM
- **Disk I/O** - Operaciones de disco
- **Network I/O** - TrÃ¡fico de red

- **Concurrent Users** - Usuarios simultÃ¡neos
- **Active Sessions** - Sesiones activas
- **User Journey Completion** - Completitud de flujos


```xml
<ThreadGroup>
  <elementProp name="ThreadGroup.main_controller" elementType="LoopController">
    <boolProp name="LoopController.continue_forever">false</boolProp>
    <stringProp name="LoopController.loops">-1</stringProp>
  </elementProp>
  <stringProp name="ThreadGroup.num_threads">${__P(users,10)}</stringProp>
  <stringProp name="ThreadGroup.ramp_time">${__P(rampup,60)}</stringProp>
  <stringProp name="ThreadGroup.duration">${__P(duration,300)}</stringProp>
</ThreadGroup>
```

```xml
<ConfigTestElement>
  <stringProp name="HTTPSampler.domain">${__P(target_url,https://petstore.octoperf.com)}</stringProp>
  <stringProp name="HTTPSampler.port"></stringProp>
  <stringProp name="HTTPSampler.protocol">https</stringProp>
  <stringProp name="HTTPSampler.contentEncoding">UTF-8</stringProp>
  <stringProp name="HTTPSampler.path"></stringProp>
</ConfigTestElement>
```

- **View Results Tree** - Para debugging
- **Summary Report** - Resumen de mÃ©tricas
- **Response Time Graph** - GrÃ¡fico de tiempos
- **Aggregate Report** - Reporte consolidado



- **< 1s** âœ… Excelente
- **1-2s** âœ… Bueno
- **2-5s** âš ï¸ Aceptable
- **> 5s** âŒ Requiere optimizaciÃ³n

- **< 1%** âœ… Excelente
- **1-2%** âœ… Bueno
- **2-5%** âš ï¸ Aceptable
- **> 5%** âŒ CrÃ­tico

- **Alto TPS** âœ… Sistema eficiente
- **TPS variable** âš ï¸ Posible inestabilidad
- **TPS bajo** âŒ Cuello de botella


1. **Base de Datos** - Queries lentas, conexiones insuficientes
2. **Servidor Web** - CPU alta, memoria insuficiente
3. **Red** - Ancho de banda limitado, latencia alta
4. **AplicaciÃ³n** - CÃ³digo ineficiente, algoritmos lentos

- **Response time creciente** con carga estable
- **Error rate alto** en picos de carga
- **Throughput plano** con mÃ¡s usuarios
- **Timeouts frecuentes** en requests


1. **Validar entorno** de pruebas
2. **Configurar monitoreo** del sistema
3. **Preparar datos** de prueba
4. **Establecer lÃ­neas base** de rendimiento

1. **Ejecutar pruebas** en horarios de bajo trÃ¡fico
2. **Monitorear recursos** durante las pruebas
3. **Documentar condiciones** del entorno
4. **Capturar mÃ©tricas** detalladas

1. **Comparar con lÃ­neas base** anteriores
2. **Identificar patrones** en los datos
3. **Priorizar optimizaciones** necesarias
4. **Documentar hallazgos** y recomendaciones


- [ ] **Pruebas de API REST** - Evaluar endpoints individuales
- [ ] **Pruebas de carga distribuida** - MÃºltiples mÃ¡quinas JMeter
- [ ] **Pruebas de base de datos** - Evaluar queries especÃ­ficas
- [ ] **Pruebas de seguridad** - Evaluar rendimiento con autenticaciÃ³n
- [ ] **Pruebas de recuperaciÃ³n** - Evaluar tiempo de recuperaciÃ³n tras fallos

- [ ] **Grafana** - Dashboards en tiempo real
- [ ] **Prometheus** - MÃ©tricas de sistema
- [ ] **ELK Stack** - AnÃ¡lisis de logs
- [ ] **APM Tools** - Monitoreo de aplicaciÃ³n
