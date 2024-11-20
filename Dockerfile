# Etapa 1: Crear una imagen base ligera
FROM python:3.9-slim AS base

# Crear directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos del proyecto al contenedor
COPY . /app

# Instalar dependencias del proyecto
RUN pip install --no-cache-dir -r Requirements.txt

# Descargar y descomprimir el modelo Vosk
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://alphacephei.com/vosk/models/vosk-model-fr-0.6-linto-2.2.0.zip -O vosk.zip && \
    unzip vosk.zip && mv vosk-model-fr-0.6-linto-2.2.0 vosk && \
    rm vosk.zip && \
    apt-get remove -y wget unzip && apt-get autoremove -y && apt-get clean

# Establecer el puerto para la API
EXPOSE 8000

# Ejecutar el servicio principal
CMD ["python", "mainAPI.py"]
