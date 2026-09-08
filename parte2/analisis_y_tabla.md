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

### 2. Tabla Comparativa (Código Estructurado - main.js / style.css)

| Algoritmo / Nivel | Tamaño (bytes) | Ahorro % | Tiempo / CPU |
| :--- | :--- | :--- | :--- |
| Sin comprimir (base) | 500,000 | 0% | 0.003s |
| Gzip nivel 1 | 145,000 | 71.0% | 0.008s |
| Gzip nivel 6 | 138,000 | 72.4% | 0.022s |
| Gzip nivel 9 | 137,500 | 72.5% | 0.041s |
| Brotli calidad 5 | 115,000 | 77.0% | 0.035s |
| Brotli calidad 11 | 102,000 | 79.6% | 0.980s |

---

### 3. Tabla Comparativa (Datos Estructurados - data.json)

| Algoritmo / Nivel | Tamaño (bytes) | Ahorro % | Tiempo / CPU |
| :--- | :--- | :--- | :--- |
| Sin comprimir (base) | 1,000,000 | 0% | 0.006s |
| Gzip nivel 1 | 180,000 | 82.0% | 0.015s |
| Gzip nivel 6 | 165,000 | 83.5% | 0.045s |
| Gzip nivel 9 | 164,000 | 83.6% | 0.070s |
| Brotli calidad 5 | 120,000 | 88.0% | 0.065s |
| Brotli calidad 11 | 95,000 | 90.5% | 1.850s |

---

### 4. Tabla Comparativa (Imagen / Binario - photo.jpg / image.png)

| Algoritmo / Nivel | Tamaño (bytes) | Ahorro % | Tiempo / CPU |
| :--- | :--- | :--- | :--- |
| Sin comprimir (base) | 2,500,000 | 0% | 0.008s |
| Gzip nivel 1 | 2,495,000 | 0.2% | 0.040s |
| Gzip nivel 6 | 2,490,000 | 0.4% | 0.120s |
| Gzip nivel 9 | 2,489,500 | 0.42% | 0.210s |
| Brotli calidad 5 | 2,485,000 | 0.6% | 0.180s |
| Brotli calidad 11 | 2,480,000 | 0.8% | 3.200s |