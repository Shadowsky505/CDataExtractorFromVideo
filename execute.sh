#!/bin/bash
apt update
apt install docker.io docker-compose -y
# Solicitar la API Key
read -p "Ingresa tu API Key: " API_KEY

# Crear y ejecutar el contenedor con la variable de entorno
docker build -t vosk-api .
docker run -d -p 8000:8000 --name vosk-api-container -e OPEN_API_KEY="$API_KEY" vosk-api

echo "El contenedor se está ejecutando en el puerto 8000."
