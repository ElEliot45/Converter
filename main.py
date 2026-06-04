from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import FileResponse
from pdf2docx import Converter
import os
import shutil

app = FastAPI()

# Carpetas temporales para procesar los archivos
UPLOAD_DIR = "temporal_files"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.post("/convertir")
async def convertir_pdf(file: UploadFile = File(...)):
    # Validar que sea un PDF
    if not file.filename.endswith('.pdf'):
        raise HTTPException(status_code=400, detail="El archivo debe ser un PDF")

    # 1. Guardar el PDF recibido temporalmente en el servidor
    ruta_pdf = os.path.join(UPLOAD_DIR, file.filename)
    with open(ruta_pdf, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # 2. Definir la ruta del Word de salida
    nombre_word = os.path.splitext(file.filename)[0] + ".docx"
    ruta_word = os.path.join(UPLOAD_DIR, nombre_word)

    try:
        # 3. Tu lógica de conversión
        cv = Converter(ruta_pdf)
        cv.convert(ruta_word, start=0, end=None)
        cv.close()

        # 4. Responder enviando el archivo Word de vuelta a Flutter
        return FileResponse(
            path=ruta_word, 
            filename=nombre_word, 
            media_type='application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al convertir: {str(e)}")
        
    finally:
        # Limpieza opcional: borrar el PDF original para no saturar el servidor
        if os.path.exists(ruta_pdf):
            os.remove(ruta_pdf)