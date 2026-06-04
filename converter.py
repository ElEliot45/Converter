import os
from pdf2docx import Converter

def convertir_pdf_a_word():
    print("=== CONVERTIDOR DE PDF A WORD ===")
    
    ruta_pdf = input("Introduce la ruta o el nombre del archivo PDF: ").strip()
    
    # Validar que el archivo realmente exista
    if not os.path.exists(ruta_pdf):
        print(f"Error: El archivo '{ruta_pdf}' no existe. Verifica la ruta.")
        return

    if not ruta_pdf.lower().endswith('.pdf'):
        print("Error: El archivo debe tener la extensión .pdf")
        return

    ruta_word = os.path.splitext(ruta_pdf)[0] + ".docx"
    
    print("\n[+] Analizando y convirtiendo el documento... Esto puede tomar unos segundos.")
    
    try:
        cv = Converter(ruta_pdf)
        
        cv.convert(ruta_word, start=0, end=None)
        
        cv.close()
        
        print("\n=========================================")
        print(f"¡Éxito! Archivo convertido y guardado en:")
        print(f"-> {os.path.abspath(ruta_word)}")
        print("=========================================")
        
    except Exception as e:
        print(f"\n[X] Ocurrió un error durante la conversión: {e}")

if __name__ == "__main__":
    convertir_pdf_a_word()