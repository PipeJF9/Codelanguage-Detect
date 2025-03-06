#!/bin/bash

# Dictionary to store settings for different file extensions (using bash associative arrays)
declare -A IMAGES_SETTINGS

# Python settings
IMAGES_SETTINGS[".py.base_image"]="python:3.10-slim"
IMAGES_SETTINGS[".py.run_cmd"]='["python3", "/app/{file_basename}"]'

# C++ settings
IMAGES_SETTINGS[".cpp.base_image"]="gcc:latest"
IMAGES_SETTINGS[".cpp.run_cmd"]='["bash", "-c", "g++ -std=c++17 /app/{file_basename} -o /app/program.out && /app/program.out"]'

# Java settings - Corregido para manejar paquetes Java correctamente
IMAGES_SETTINGS[".java.base_image"]="openjdk:17-slim"
IMAGES_SETTINGS[".java.run_cmd"]='["bash", "-c", "mkdir -p /app/sample && cp /app/{file_basename} /app/sample/ && cd /app && javac sample/{file_basename} && java sample.{name_without_ext}"]'

# JavaScript settings
IMAGES_SETTINGS[".js.base_image"]="node:18-slim"
IMAGES_SETTINGS[".js.run_cmd"]='["node", "/app/{file_basename}"]'

# Ruby settings
IMAGES_SETTINGS[".rb.base_image"]="ruby:latest"
IMAGES_SETTINGS[".rb.run_cmd"]='["ruby", "/app/{file_basename}"]'

# Function to detect the language based on the file extension
detect_language() {
    local filename="$1"
    
    for ext in ".py" ".cpp" ".java" ".js" ".rb"; do
        if [[ "$filename" == *"$ext" ]]; then
            echo "$ext"
            return 0
        fi
    done
    
    echo "none"
    return 1
}

# Function to create a Dockerfile based on the file and its configuration
create_dockerfile() {
    local filename="$1"
    local extension="$2"
    local base_image="${IMAGES_SETTINGS["$extension.base_image"]}"
    local run_cmd="${IMAGES_SETTINGS["$extension.run_cmd"]}"
    
    # Get filename without path for Dockerfile
    local file_basename=$(basename "$filename")
    
    # Get name without extension for Java files
    local name_without_ext=""
    if [[ "$extension" == ".java" ]]; then
        name_without_ext=$(basename "$file_basename" "$extension")
    fi
    
    # Replace placeholders in the run command
    run_cmd="${run_cmd//\{file_basename\}/$file_basename}"
    run_cmd="${run_cmd//\{name_without_ext\}/$name_without_ext}"
    
    # Create Dockerfile
    cat > Dockerfile << EOF
FROM $base_image
WORKDIR /app
COPY $filename /app/
CMD $run_cmd
EOF
}

# Function to execute the file inside a Docker container
execute_with_docker() {
    local filename="$1"
    local extension="$2"
    local image="execution-${extension//./}"
    
    # Build the Docker image
    docker build -t "$image" . || { echo "Error building Docker image"; exit 1; }
    
    # Run the Docker container and capture the output
    docker run --rm "$image"
    
    # Remove the Dockerfile after execution
    rm -f Dockerfile
}

# Main function to handle command-line arguments and execute the appropriate functions
main() {
    if [ $# -lt 1 ]; then
        echo "Uso: ./$(basename "$0") sample/archivo_fuente"
        exit 1
    fi
    
    local file="$1"
    if [ "$file" = "-h" ] || [ "$file" = "--help" ]; then
        echo "Uso: ./$(basename "$0") sample/archivo_fuente"
        exit 0
    fi
    
    # Corrección en la verificación de la ruta
    if [[ "$file" != sample/* ]]; then
        echo "El archivo debe estar en la carpeta sample/"
        exit 1
    fi
    
    if [ "$file" = "sample/" ]; then
        echo "No se ha especificado un archivo."
        exit 1
    fi
    
    local extension=$(detect_language "$file")
    if [ "$extension" != "none" ]; then
        if [ ! -f "$file" ]; then
            echo "El archivo no existe."
            exit 1
        else
            create_dockerfile "$file" "$extension"
            execute_with_docker "$file" "$extension"
        fi
    else
        echo "No se reconoce la extensión del archivo."
        echo "Las extensiones soportadas son: .py, .cpp, .java, .js, .rb"
        exit 1
    fi
}

# Call the main function with all arguments
main "$@"