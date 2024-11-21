# Etapa 1: Crear una imagen base ligera
FROM python:3.12.0 AS base

# Establecer directorio de trabajo en el contenedor
WORKDIR /app

# Instalar dependencias del sistema necesarias para el proyecto
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip libgl1 libglib2.0-0 ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar los archivos del proyecto al contenedor
COPY . /app

# Crear e instalar dependencias en un entorno virtual aislado
RUN python -m venv /app/venv && \
    /app/venv/bin/pip install --no-cache-dir -r Requirements.txt

# Descargar y descomprimir el modelo Vosk
RUN wget https://alphacephei.com/vosk/models/vosk-model-small-es-0.42.zip -O vosk.zip && \
    unzip vosk.zip && mv vosk-model-small-es-0.42 vosk && \
    rm vosk.zip

# Exponer el puerto para la API
EXPOSE 8000

# Establecer el comando de inicio
CMD ["/app/venv/bin/python", "mainAPI.py"]
