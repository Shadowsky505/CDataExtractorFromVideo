import os
import subprocess
from concurrent.futures import ThreadPoolExecutor
from scenedetect import open_video, SceneManager
from scenedetect.detectors import ContentDetector

def save_frame(video_path, start_time, output_path):
    """Guarda un fotograma de un video en un momento específico."""
    subprocess.run([
        "ffmpeg", "-ss", f"{start_time.get_seconds()}", "-i", video_path,
        "-vframes", "1", "-q:v", "2", output_path
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(f"Fotograma guardado en: {output_path}")

def split_video_into_scenes(video_path, base_dir="Videos/Frames", threshold=27.0):
    output_dir = os.path.join(base_dir)
    os.makedirs(output_dir, exist_ok=True)
    
    # Detección de escenas
    video = open_video(video_path)
    scene_manager = SceneManager()
    scene_manager.add_detector(ContentDetector(threshold=threshold))
    scene_manager.detect_scenes(video, show_progress=True)
    scene_list = scene_manager.get_scene_list()
    
    # Procesamiento paralelo
    frame_paths = []
    with ThreadPoolExecutor() as executor:
        futures = []
        for idx, (start_time, end_time) in enumerate(scene_list):
            frame_output_path = os.path.join(output_dir, f"frame_scene_{idx+1}.jpg")
            futures.append(
                executor.submit(save_frame, video_path, start_time, frame_output_path)
            )
            frame_paths.append(frame_output_path)
        
        for future in futures:
            future.result()  # Asegurarse de que todos los procesos se completen
    
    print(f"Todos los fotogramas se encuentran en: {output_dir}")
    return frame_paths
