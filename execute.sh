#!/bin/bash

# Actualización e instalación de Docker y Docker Compose
apt update
apt install docker.io docker-compose -y

# Solicitar al usuario la API Key
read -p "Ingresa tu API Key: " API_KEY

# Crear el archivo .env en el host
echo "OPENAI_API_KEY=$API_KEY" > .env

# Construir y ejecutar el contenedor usando docker-compose
docker-compose up --build -d

# Mensaje de confirmación
echo "El contenedor 'vosk-api-container' está corriendo en el puerto 8000."
