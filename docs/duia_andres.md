# Declaración de Uso de Inteligencia Artificial (DUIA)

**Estudiante:** Andrés Fabre  
**Proyecto / Trabajo Práctico:** TP N.º 8 — Food Store (Capa de datos y entorno móvil)  
**Asignación individual:** Entregables 1.a (datos que viajan), 3.a (mapa de la capa de datos), 3.b (plan de mantenimiento) y revisión cruzada de consignas 1 y 2 (A4).

---

## 1. Herramientas de IA Utilizadas

| Herramienta / Modelo | Versión / Plataforma | Propósito principal |
|---|---|---|
| **Gemini** | Gemini 3 Flash / Web (Free Tier) | Asistencia en estructuración de Markdown, redacción de documentos técnicos (1.a, 3.a, 3.b), diagnóstico de errores CLI en Windows 11 e interpretación de hashes de verificación. |

---

## 2. Declaración de Prompts e Interacciones Clave

### Interacción 1: Redacción de entregables documentales (1.a, 3.a, 3.b)
* **Objetivo:** Generar borradores claros y concisos en formato Markdown para los entregables asignados en `docs/partes/`.
* **Prompt representativo:** 
  > *"Ayúdame a redactar los documentos 1.a (qué datos de producto viajan a la tablet y fuente de verdad), 3.a (mapa de la capa de datos integrando PostgreSQL, MongoDB y SQLite) y 3.b (plan de mantenimiento extendido de la U6)."*
* **Resultado / Aceptación:** Se aceptaron las tablas y justificaciones conceptuales previa verificación contra la arquitectura del proyecto y las restricciones del enunciado.

### Interacción 2: Diagnóstico de error en SQLite (`schema_sqlite.sql`)
* **Objetivo:** Resolver error `Parse error: table producto_cache already exists` al intentar ejecutar los scripts de revisión cruzada en Windows 11.
* **Prompt representativo:**
  > *"Al ejecutar `sqlite3 movil/foodstore_movil.db .read movil/schema_sqlite.sql` me tira error de que las tablas ya existen."*
* **Resultado / Aceptación:** Se aceptó la sugerencia de la IA de eliminar el archivo local preexistente (`del movil\foodstore_movil.db`) antes de recrear el esquema, solucionando el problema inmediatamente.

### Interacción 3: Interpretación de resultados de verificación (`verificar_no_cambio.sql`)
* **Objetivo:** Confirmar el significado de los valores obtenidos durante la prueba de no modificación de PostgreSQL.
* **Prompt representativo:**
  > *"Al ejecutar `postgresql/verificar_no_cambio.sql` me dio 6 pedidos, 13 detalles, 454 stock total y el hash MD5 `89f8351d0162e23ef1473f32b05ce221`, ¿es normal?"*
* **Resultado / Aceptación:** Se aceptó la explicación de la IA que confirmó el cumplimiento de la prueba de integridad mediante la preservación del estado inicial.

---

## 3. Metodología de Verificación y Control Humano

1. **Lectura y revisión de código/texto:** Ninguna propuesta redactada por la IA se incorporó al repositorio sin una lectura y edición previa para garantizar consistencia con los requerimientos específicos de la materia.
2. **Prueba directa en motor de base de datos:** Las consultas de verificación y comandos CLI fueron ejecutados manualmente en la consola de Windows 11 sobre PostgreSQL 16 y SQLite 3.37+, asegurando que las salidas (`0 filas` en diferencias y hashes idénticos) comprobaran empíricamente el correcto funcionamiento del sistema.

---

## 4. Compromiso Ético y Firma

Declaro haber utilizado la Inteligencia Artificial de forma transparente y colaborativa como apoyo pedagógico y técnico, asumiendo la responsabilidad total sobre los contenidos, validaciones y conclusiones presentadas en mis entregables individuales del TP 8.

**Firma:** Andrés Fabre  
**Fecha:** 04 de Noviembre de 2026

---

## Nota de revisión del equipo (Mariano Chirino, 04/11/2026)

Esta nota la agrega Mariano al integrar el PR #1. La declaración anterior es de Andrés y no se modificó.

- Las aceptaciones de la Interacción 1 se refieren a los borradores originales de 1.a, 3.a y 3.b. Esos documentos tenían errores contra el esquema
  real (columnas inexistentes, la cola ubicada en PostgreSQL, MongoDB descripto como metadatos de productos y SQLite con «autoridad local») y
  fueron corregidos por Mariano en `docs/partes/`. La verificación que se declara en la sección 3 no detectó esos errores.
- La carpeta `sqlite/` y los archivos `tp8_database.db` no son parte de la entrega: eran un esquema de ejemplo distinto del esquema del TP.
- Las interacciones 2 y 3 (error de `already exists` e interpretación de la huella) se corresponden con la revisión cruzada A4, cuyos resultados
  coinciden con los de Mariano.
