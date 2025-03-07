# Repositorio para Detección y Ejecución de Código en Contenedores

Este repositorio contiene un programa en shell de Linux que detecta automáticamente el lenguaje de programación de un archivo de código fuente según su extensión, lo ejecuta dentro de un contenedor Docker específico y muestra tanto la salida del programa como el tiempo total de ejecución.

## Miembros del Grupo
- Samuel Matiz Garcia [@MatizS27](https://github.com/MatizS27)
- Juan Felipe Santos Rodriguez [PipeJF9](https://github.com/PipeJF9)

## Enlace al Repositorio
[Repositorio de Códigos](https://github.com/PipeJF9/Codelanguage-Detect.git)

## Instructivo para Ejecución

### Requisitos
- Docker instalado.

### Pasos para Ejecutar

1. Clona este repositorio:
   ```bash
   git clone https://github.com/PipeJF9/Codelanguage-Detect.git
   cd Codelanguage-Detect

2. Ejecuta el script docker-execute.sh con la ruta del archivo de código fuente que deseas ejecutar:
   ```bash
   ./docker-execute.sh ruta/del/archivo.extension

### Ejemplos de Uso:
   ```bash
   ./docker-execute.sh sample/sample.cpp
   ./docker-execute.sh sample/sample.java
   ./docker-execute.sh sample/sample.js
   ./docker-execute.sh sample/sample.py
   ./docker-execute.sh sample/sample.rb
