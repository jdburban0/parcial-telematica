# Entrega Parte 2: Optimización de Tráfico Web (mod_deflate vs mod_brotli)

## 1. Tabla Comparativa (Texto Plano - lorem.txt)
| Algoritmo / Nivel | Tamaño (bytes) | Ahorro % | Tiempo / CPU |
| :--- | :--- | :--- | :--- |
| Sin comprimir (base) | 938,895 | 0% | 0.005s |
| Gzip nivel 1 | 324,633 | 65.4% | 0.013s |
| Gzip nivel 6 | 322,234 | 65.7% | 0.037s |
| Gzip nivel 9 | 322,271 | 65.7% | 0.060s |
| Brotli calidad 5 | 55,665 | 94.0% | 0.057s |
| Brotli calidad 11 | 151,528 | 83.8% | 1.518s |

## 2. Análisis Crítico
1. **Brotli vs Gzip:** Brotli supera significativamente a gzip sobre contenido de texto puro, reduciendo el tamaño de forma drástica (como se ve en la calidad 5).
2. **Niveles de compresión:** Se observa un claro punto de rendimientos decrecientes. Pasar de gzip nivel 1 a 9 apenas reduce un par de bytes adicionales pero multiplica el costo de CPU. En Brotli, la calidad 11 incrementa severamente el tiempo de procesamiento (1.5s) en comparación con la calidad 5, por lo que calidades moderadas son óptimas para producción.
3. **Tipos de archivo:** Los binarios (como imágenes JPEG o archivos ZIP) se excluyeron mediante `SetEnvIfNoCase` porque ya poseen compresión interna o entropía alta, por lo que comprimirlos web-side genera un resultado nulo o negativo (aumentan de tamaño).
4. **Impacto en CPU:** Niveles extremos incrementan la carga del servidor bajo alta concurrencia, balanceando mal el ahorro de ancho de banda frente al tiempo de respuesta del hilo de Apache.
5. **Estático vs Dinámico:** Conviene precomprimir activos estáticos en disco (como librerías pesadas) para servir niveles altos de Brotli sin penalizar el CPU al vuelo.