import os
from transformers import BlipForConditionalGeneration, BlipProcessor

def cargar_o_descargar_modelo(nombre_modelo="Salesforce/blip-image-captioning-base"):
    """
    Verifica si el modelo existe en la ruta de caché de Hugging Face.
    Si no existe, descarga el modelo y crea la estructura necesaria.

    Parameters:
    - nombre_modelo: Nombre del modelo en Hugging Face.
    """
    # Ruta personalizada al caché de Hugging Face en Windows
    base_cache_dir = os.path.expanduser("/root/.cache")  # Ruta base en Windows
    huggingface_dir = os.path.join(base_cache_dir, "huggingface", "hub", f"models--{nombre_modelo.replace('/', '--')}")
    
    # Verificar si existe la carpeta del modelo
    if os.path.exists(huggingface_dir):
        print(f"El modelo '{nombre_modelo}' ya está descargado en {huggingface_dir}. No es necesario descargarlo.")
    else:
        print(f"El modelo '{nombre_modelo}' no existe en {huggingface_dir}. Creando carpeta y descargando modelo...")

        # Descargar el modelo y el procesador
        processor = BlipProcessor.from_pretrained(nombre_modelo)
        model = BlipForConditionalGeneration.from_pretrained(nombre_modelo)
        print(f"Modelo descargado y almacenado en: {huggingface_dir}")

if _name_ == "_main_":
    cargar_o_descargar_modelo()