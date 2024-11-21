# Etapa 1: Crear una imagen base ligera
FROM python:3.12.0 AS base

# Crear directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos del proyecto al contenedor
COPY . /app

# Crear un entorno virtual en el directorio del contenedor
RUN python -m venv /app/venv

# Volumen para las librerías instaladas
VOLUME /app/venv/lib/python3.12/site-packages

# Verificar si las librerías ya están instaladas
RUN if [ ! -d "/app/venv/lib/python3.12/site-packages" ] || [ -z "$(ls -A /app/venv/lib/python3.12/site-packages)" ]; then \
      /app/venv/bin/pip install --no-cache-dir -r Requirements.txt; \
    fi

# Instalar dependencias necesarias para descargar el modelo Vosk
RUN apt-get update && apt-get install -y wget unzip libgl1 libglib2.0-0 ffmpeg

# Verificar si el modelo ya está presente, si no lo está, descargarlo
RUN if [ ! -d "/app/vosk" ]; then \
      wget https://alphacephei.com/vosk/models/vosk-model-small-es-0.42.zip -O vosk.zip && \
      unzip vosk.zip && mv vosk-model-small-es-0.42 vosk && \
      rm vosk.zip; \
    fi

# Limpiar dependencias no necesarias
RUN apt-get remove -y wget unzip && apt-get autoremove -y && apt-get clean

# Ejecutar el script de verificación en el entorno virtual
RUN /app/venv/bin/python verificar_modelo.py

# Establecer el puerto para la API
EXPOSE 8000

# Ejecutar el servicio principal con el entorno virtual
CMD ["/app/venv/bin/python", "mainAPI.py"]
