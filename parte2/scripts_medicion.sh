#!/bin/bash
# Script de medicion para la Parte 2: Evaluacion de mod_deflate y mod_brotli
# Ejecutar este script desde una terminal para automatizar la recoleccion de datos de curl

URL="http://parcial.empresa.local/lorem.txt"

echo "=== MEDIDAS PARA LOREM.TXT ==="

echo "1. Linea base (Sin comprimir - identity):"
curl -s -H 'Accept-Encoding: identity' -o /dev/null -w 'tamano=%{size_download}B tiempo=%{time_total}s\n' $URL

echo "2. Gzip (mod_deflate) - Nivel 1:"
curl -s -H 'Accept-Encoding: gzip' -o /dev/null -w 'tamano=%{size_download}B tiempo=%{time_total}s\n' $URL

echo "3. Gzip (mod_deflate) - Nivel 6:"
curl -s -H 'Accept-Encoding: gzip' -o /dev/null -w 'tamano=%{size_download}B tiempo=%{time_total}s\n' $URL

echo "4. Gzip (mod_deflate) - Nivel 9:"
curl -s -H 'Accept-Encoding: gzip' -o /dev/null -w 'tamano=%{size_download}B tiempo=%{time_total}s\n' $URL

echo "5. Brotli (mod_brotli) - Calidad 5:"
curl -s -H 'Accept-Encoding: br' -o /dev/null -w 'tamano=%{size_download}B tiempo=%{time_total}s\n' $URL

echo "6. Brotli (mod_brotli) - Calidad 11:"
curl -s -H 'Accept-Encoding: br' -o /dev/null -w 'tamano=%{size_download}B tiempo=%{time_total}s\n' $URL

echo "7. Verificacion de cabecera Content-Encoding:"
curl -s -H 'Accept-Encoding: br, gzip' -I $URL | grep -i content-encoding