# Etapa 1: Crear una imagen base ligera
FROM python:3.12.0 AS base

# Crear directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos del proyecto al contenedor
COPY . /app

# Crear un entorno virtual en el directorio del contenedor
RUN python -m venv /app/venv

# Activar el entorno virtual y luego instalar dependencias del proyecto
RUN /app/venv/bin/pip install --no-cache-dir -r Requirements.txt

# Descargar y descomprimir el modelo Vosk
RUN apt-get update && apt-get install -y wget unzip libgl1 libglib2.0-0 ffmpeg && \
    wget https://alphacephei.com/vosk/models/vosk-model-small-es-0.42.zip -O vosk.zip && \
    unzip vosk.zip && mv vosk-model-small-es-0.42 vosk && \
    rm vosk.zip && \
    apt-get remove -y wget unzip && apt-get autoremove -y && apt-get clean

    # Establecer el puerto para la API
# RUN python verificar_modelo.py

EXPOSE 8000

# Ejecutar el servicio principal con el entorno virtual
CMD ["/app/venv/bin/python", "mainAPI.py"]