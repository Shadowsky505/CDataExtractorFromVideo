import os
from transformers import BlipProcessor, BlipForConditionalGeneration
from PIL import Image


def cargar_modelo_blip():
    """Carga el modelo BLIP y su procesador una sola vez para reutilización."""
    print("Cargando modelo BLIP...")
    processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
    model = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base")
    print("Modelo BLIP cargado correctamente.")
    return processor, model


def procesar_imagen_y_generar_descripcion(ruta_imagen, processor, model):
    """Genera una descripción para una imagen específica usando BLIP."""
    try:
        with Image.open(ruta_imagen).convert('RGB') as image:
            inputs = processor(image, return_tensors="pt")
            output = model.generate(**inputs)
            descripcion = processor.decode(output[0], skip_special_tokens=True)
        os.remove(ruta_imagen)  # Elimina la imagen después de procesarla
        print(f"Imagen {ruta_imagen} procesada y eliminada.")
        return descripcion
    except Exception as e:
        print(f"Error procesando {ruta_imagen}: {str(e)}")
        return f"Error procesando {ruta_imagen}"


def procesar_imagenes_en_directorio(ruta_frames, extensiones_imagenes={'.jpg'}, batch_size=40):
    """
    Procesa imágenes en el directorio dado y genera descripciones para cada una.
    Las descripciones se guardan en un archivo de texto en el mismo directorio.
    
    Parameters:
    - ruta_frames: Ruta al directorio de fotogramas.
    - extensiones_imagenes: Conjunto de extensiones de imágenes a procesar.
    - batch_size: Número de imágenes a procesar por lote.
    """
    processor, model = cargar_modelo_blip()
    archivos_imagen = [
        os.path.join(ruta_frames, archivo)
        for archivo in os.listdir(ruta_frames)
        if os.path.splitext(archivo)[1].lower() in extensiones_imagenes
    ]

    print(f"Procesando {len(archivos_imagen)} imágenes en {ruta_frames}...")
    descripciones = []

    # Procesar imágenes de manera secuencial
    for i in range(0, len(archivos_imagen), batch_size):
        batch = archivos_imagen[i:i + batch_size]
        for ruta in batch:
            descripcion = procesar_imagen_y_generar_descripcion(ruta, processor, model)
            descripciones.append(descripcion)

    # Guardar descripciones en un archivo de texto
    ruta_txt = os.path.join(ruta_frames, "descripciones.txt")
    with open(ruta_txt, 'w', encoding='utf-8') as f:
        f.write("\n".join(descripciones))
    print(f"Descripciones guardadas en {ruta_txt}")
    print("Proceso completado.")


# Ejemplo de uso
if __name__ == "__main__":
    ruta_frames = "Videos/frames"
    procesar_imagenes_en_directorio(ruta_frames)
