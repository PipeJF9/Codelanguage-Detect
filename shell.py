import sys
import os
import subprocess

# Dictionary to store settings for different file extensions
IMAGES_SETTINGS = {
    ".py": {
        "base_image": "python:3.10-slim",  # Docker image to use for Python files
        "run_cmd": '["python3", "/app/{file}"]'  # Command to run the Python file inside the container
    },
    ".cpp": {
        "base_image": "gcc:latest",  # Docker image to use for C++ files
        "run_cmd": "g++ -std=c++17 /app/{file} -o /app/program.out && /app/program.out",  # Command to compile and run the C++ file inside the container
    },
    ".java": {
        "base_image": "openjdk:17-slim",  # Docker image to use for Java files
        "run_cmd": "javac /app/{file} && java -cp /app {name_without_ext}"  # Command to compile and run the Java file inside the container
    },
    ".js": {
        "base_image": "node:18-slim",  # Docker image to use for JavaScript files
        "run_cmd": '["node", "/app/{file}"]'  # Command to run the JavaScript file inside the container
    },
    ".rb": {
        "base_image": "ruby:latest",  # Docker image to use for Ruby files
        "run_cmd": "ruby /app/{file}"  # Command to run the Ruby file inside the container
    }
}

# Function to detect the language based on the file extension
def detect_language(filename):
    for ext, config in IMAGES_SETTINGS.items():
        if filename.endswith(ext):
            return ext, config
    return None, None

# Function to create a Dockerfile based on the file and its configuration
def create_dockerfile(filename, config):
    dockerfile_content = f"""
    FROM {config["base_image"]}
    WORKDIR /app/sample
    COPY {filename} .
    CMD {config["run_cmd"].format(file=filename, name_without_ext=os.path.splitext(filename)[0])}
    """
    with open("Dockerfile", "w") as f:
        f.write(dockerfile_content.strip())

# Function to execute the file inside a Docker container
def execute_with_docker(filename, extension):
    image = f"execution-{extension.replace('.', '')}"
    
    # Build the Docker image
    subprocess.run(f"docker build -t {image} .", shell=True, check=True)
    
    # Run the Docker container and capture the output
    result = subprocess.run(f"docker run --rm {image}", shell=True, capture_output=True, text=True)
    print(result.stdout)  # Print the standard output
    print(result.stderr)  # Print the standard error
    
    # Remove the Dockerfile after execution
    os.remove("Dockerfile")

# Main function to handle command-line arguments and execute the appropriate functions
if __name__ == "__main__":
        if len(sys.argv) < 2:
            print("Uso: python shell.py sample/archivo_fuente")
            sys.exit(1)
        
        file = sys.argv[1]
        if file == "-h" or file == "--help":
            print("Uso: python shell.py sample/archivo_fuente")
            sys.exit(0)
        if file[0:7] != "sample/":
            print("El archivo debe estar en la carpeta sample/")
            sys.exit(1)
        if file == "sample/":
            print("No se ha especificado un archivo.")
            sys.exit(1)

        extension, config = detect_language(file)
        if config:
            if not os.path.exists(file):
                print("El archivo no existe.")
                sys.exit(1)
            else:
                create_dockerfile(file, config)
                execute_with_docker(file, extension)
        else:
            print("No se reconoce la extensión del archivo.")
            print("Las extensiones soportadas son:", ", ".join(IMAGES_SETTINGS.keys()))
            sys.exit(1)
