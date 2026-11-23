# VOLTÍMETRO DIGITAL BASADO EN ARQUITECTURA SAR

## Autores
* **Angye Valentina García Páramo** (`@gangyevalentina-jpg`)
* **Samuel Quesada** (`@samuel72-oss`)

---

## Descripción General

Proyecto final de la asignatura Electrónica Digital (ELDI) — Escuela Colombiana de Ingeniería Julio Garavito, ciclo académico 2026-2.

El proyecto consiste en el diseño, desarrollo e implementación en hardware de un voltímetro digital con un rango de medición de 0 V a 5 V, una resolución teórica aproximada de 4.88 mV ($\approx 4\text{ mV} - 5\text{ mV}$) y una frecuencia de muestreo de 1 kHz. El sistema utiliza una arquitectura de conversión analógica-digital SAR (*Successive Approximation Register*) controlada por una máquina de estados finitos (FSM de Moore) sobre una FPGA Digilent Basys 3, complementada por un arreglo resistivo R-2R de 10 bits, etapa de acondicionamiento analógico, comparación externa y visualización multiplexada/auto-rango en displays de 7 segmentos.

## REQUISITOS DEL SISTEMA ##
### HADWARE Y PLACA DE DESARROLLO
* **FPGA:** Digilent Basys 3 (Artix-7 `xc7a35tcpg236-1`).
* **Fuente de alimentación externa:** Fuente DC regulada de $+9\text{ V}$ (o batería) para polarizar la etapa analógica con tierra común (`GND`) compartida con la Basys 3.
* **Instrumentación de referencia:** Multímetro digital calibrado (para ajuste del potenciometro de ganancia y validación de lecturas) y protoboard con cables Dupont.
