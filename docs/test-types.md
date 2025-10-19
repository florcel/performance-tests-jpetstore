
Este documento describe los diferentes tipos de pruebas de rendimiento implementadas en este proyecto.


Evaluar el rendimiento del sistema bajo carga normal esperada.

- **Usuarios concurrentes:** 10-50
- **DuraciÃ³n:** 5-30 minutos
- **Ramp-up:** Gradual (1-5 minutos)
- **Escenarios:** Flujos de usuario tÃ­picos

- Response time < 2 segundos
- Error rate < 1%
- Throughput estable
- CPU < 70%

- `jpetstore_jmeter_testplan.jmx` - Plan principal
- `scripts/run_test.sh` - Script de ejecuciÃ³n

---


Encontrar el punto de falla del sistema y evaluar su comportamiento bajo carga extrema.

- **Usuarios concurrentes:** 100-500+
- **DuraciÃ³n:** 30-120 minutos
- **Ramp-up:** Gradual (10-30 minutos)
- **Escenarios:** Flujos completos + picos de carga

- Identificar punto de degradaciÃ³n
- Medir tiempo de recuperaciÃ³n
- Evaluar estabilidad del sistema
- Documentar lÃ­mites de capacidad

- `test-plans/stress-tests.jmx` - Plan de estrÃ©s
- `scripts/run_stress_tests.sh` - Script de ejecuciÃ³n

---


Evaluar el rendimiento de endpoints individuales de la API.

- **Usuarios concurrentes:** 20-100
- **DuraciÃ³n:** 5-15 minutos
- **Ramp-up:** RÃ¡pido (1-2 minutos)
- **Escenarios:** Llamadas directas a API

- `GET /api/v2/store/inventory` - Inventario
- `GET /api/v2/pet/findByStatus` - BÃºsqueda de mascotas
- `GET /api/v2/pet/{petId}` - Detalles de mascota

- Response time < 500ms
- Error rate < 0.5%
- Throughput > 100 req/s
- Disponibilidad > 99.9%

- `test-plans/api-performance-tests.jmx` - Plan de APIs
- `scripts/run_api_tests.sh` - Script de ejecuciÃ³n

---


Evaluar el rendimiento en dispositivos mÃ³viles con diferentes caracterÃ­sticas.

- **Usuarios concurrentes:** 25-55 (iPhone + Android)
- **DuraciÃ³n:** 5-15 minutos
- **Ramp-up:** Gradual (1-2 minutos)
- **User Agents:** iPhone y Android especÃ­ficos

- **iPhone:** iOS 15, Safari Mobile
- **Android:** Android 11, Chrome Mobile

- Response time < 3 segundos (mÃ³vil)
- Error rate < 2%
- Throughput adaptado a mÃ³vil
- Experiencia de usuario fluida

- `test-plans/mobile-performance-tests.jmx` - Plan mÃ³vil
- `scripts/run_mobile_tests.sh` - Script de ejecuciÃ³n

---


Evaluar el rendimiento de consultas a base de datos bajo diferentes cargas.

- **Usuarios concurrentes:** 20-70
- **DuraciÃ³n:** 5-15 minutos
- **Ramp-up:** Gradual (1-2 minutos)
- **Escenarios:** Consultas simples y complejas

- **Simples:** Lista de categorÃ­as, productos por categorÃ­a
- **Complejas:** BÃºsqueda de productos, informaciÃ³n detallada

- Query time < 1 segundo
- Error rate < 1%
- Throughput de consultas estable
- Uso eficiente de recursos DB

- `test-plans/database-performance-tests.jmx` - Plan de DB
- `scripts/run_database_tests.sh` - Script de ejecuciÃ³n

---


Evaluar el comportamiento del sistema ante picos sÃºbitos de trÃ¡fico.

- **Usuarios concurrentes:** 50-200
- **DuraciÃ³n:** 1-5 minutos
- **Ramp-up:** Muy rÃ¡pido (10-30 segundos)
- **Escenarios:** Carga sÃºbita y sostenida

- Tiempo de respuesta bajo picos
- Capacidad de recuperaciÃ³n
- Estabilidad del sistema
- Manejo de sobrecarga

- Incluido en `test-plans/stress-tests.jmx`
- ConfiguraciÃ³n especÃ­fica en el plan

---


Evaluar el rendimiento del sistema durante perÃ­odos prolongados.

- **Usuarios concurrentes:** 20-50
- **DuraciÃ³n:** 2-8 horas
- **Ramp-up:** Gradual (5-15 minutos)
- **Escenarios:** Carga constante y sostenida

- Estabilidad a largo plazo
- DetecciÃ³n de memory leaks
- DegradaciÃ³n gradual
- RecuperaciÃ³n de recursos

- ConfiguraciÃ³n especial en planes existentes
- Monitoreo extendido requerido

---


Evaluar el rendimiento del sistema con autenticaciÃ³n y autorizaciÃ³n.

- **Usuarios concurrentes:** 10-30
- **DuraciÃ³n:** 5-15 minutos
- **Ramp-up:** Gradual (1-3 minutos)
- **Escenarios:** Login, sesiones, permisos

- Tiempo de autenticaciÃ³n < 2 segundos
- Manejo eficiente de sesiones
- Seguridad mantenida bajo carga
- Error rate < 1%

- Plan especÃ­fico en desarrollo
- IntegraciÃ³n con sistemas de autenticaciÃ³n

---


Evaluar el rendimiento con grandes volÃºmenes de datos.

- **Usuarios concurrentes:** 15-40
- **DuraciÃ³n:** 10-30 minutos
- **Ramp-up:** Gradual (2-5 minutos)
- **Escenarios:** BÃºsquedas en grandes datasets

- Tiempo de respuesta con datos grandes
- Eficiencia de consultas complejas
- Uso de memoria optimizado
- Escalabilidad de Ã­ndices

- ConfiguraciÃ³n especial en planes de DB
- Datasets de prueba especÃ­ficos

---


- âœ… Pruebas de carga bÃ¡sicas
- âœ… Pruebas de API REST
- âœ… Pruebas de dispositivos mÃ³viles

- âœ… Pruebas de carga completas
- âœ… Pruebas de estrÃ©s moderadas
- âœ… Pruebas de base de datos

- âœ… Pruebas de estrÃ©s completas
- âœ… Pruebas de resistencia
- âœ… Pruebas de picos
- âœ… Pruebas de seguridad

- âœ… Pruebas de volumen de datos
- âœ… Pruebas de base de datos avanzadas
- âœ… Pruebas de dispositivos especÃ­ficos

---


| Tipo de Prueba | Response Time | Error Rate | Throughput | CPU Usage |
|----------------|---------------|------------|------------|-----------|
| **Carga** | < 2s | < 1% | Estable | < 70% |
| **EstrÃ©s** | Variable | < 5% | Variable | < 90% |
| **API** | < 500ms | < 0.5% | > 100 req/s | < 60% |
| **MÃ³vil** | < 3s | < 2% | Adaptado | < 70% |
| **DB** | < 1s | < 1% | Estable | < 80% |
| **Picos** | < 5s | < 10% | Variable | < 95% |
| **Resistencia** | < 3s | < 2% | Estable | < 75% |

---


- [ ] Pruebas de microservicios
- [ ] Pruebas de CDN y cachÃ©
- [ ] Pruebas de integraciÃ³n con terceros
- [ ] Pruebas de accesibilidad con carga
- [ ] Pruebas de internacionalizaciÃ³n

- [ ] IntegraciÃ³n con Grafana
- [ ] Monitoreo en tiempo real
- [ ] Alertas automÃ¡ticas
- [ ] ComparaciÃ³n de versiones
- [ ] AnÃ¡lisis predictivo

---

**Ãšltima actualizaciÃ³n:** $(date +'%Y-%m-%d')  
**Responsable:** Performance Testing Team
