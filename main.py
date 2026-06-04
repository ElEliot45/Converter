from fastapi import FastAPI, UploadFile, File, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from pdf2docx import Converter
import os
import shutil

app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Carpetas temporales para procesar los archivos
UPLOAD_DIR = "temporal_files"
os.makedirs(UPLOAD_DIR, exist_ok=True)

def limpiar_archivos_temporales(ruta_pdf: str, ruta_word: str):
    try:
        if os.path.exists(ruta_pdf):
            os.remove(ruta_pdf)
        if os.path.exists(ruta_word):
            os.remove(ruta_word)
        print("📁 Limpieza de archivos temporales completada con éxito.")
    except Exception as e:
        print(f"⚠️ No se pudieron borrar los archivos temporales: {e}")

@app.post("/convertir")
async def convertir_pdf(background_tasks: BackgroundTasks, file: UploadFile = File(...)):
    if not file.filename.endswith('.pdf'):
        raise HTTPException(status_code=400, detail="El archivo debe ser un PDF") #raise es el equilavalente a throw

    #Guardar el PDF recibido temporalmente en el servidor
    ruta_pdf = os.path.join(UPLOAD_DIR, file.filename)
    with open(ruta_pdf, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Definir la ruta del Word de salida
    nombre_word = os.path.splitext(file.filename)[0] + ".docx"
    ruta_word = os.path.join(UPLOAD_DIR, nombre_word)

    try:
        cv = Converter(ruta_pdf)
        cv.convert(ruta_word, start=0, end=None)
        cv.close()

        background_tasks.add_task(limpiar_archivos_temporales, ruta_pdf, ruta_word)

        return FileResponse(
            path=ruta_word, 
            filename=nombre_word, 
            media_type='application/vnd.openxmlformats-officedocument.wordprocessingml.document' #Esto es el MIME Type. Es una etiqueta estándar en internet para que los dispositivos sepan qué tipo de archivo están recibiendo antes de abrirlo.
        )

    except Exception as e:
        limpiar_archivos_temporales(ruta_pdf, ruta_word)
        raise HTTPException(status_code=500, detail=f"Error al convertir: {str(e)}")
        
    finally:
        if os.path.exists(ruta_pdf):
            os.remove(ruta_pdf)