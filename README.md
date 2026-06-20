<==== Convertidor de PDF a Word (Docx) ====>

# I am not going to pay a shady fucking website to do this simple ass thing.

* **Arrastrar y Soltar (Drag & Drop):** Interfaz intuitiva que permite arrastrar archivos PDF directamente desde el explorador del sistema operativo.
* **Explorador Nativo:** Compatibilidad con selección de archivos tradicional mediante explorador del sistema.
* **Procesamiento Aislado:** Backend montado en Docker que ejecuta scripts de Python sin ensuciar la máquina local.
* **Descarga Web Inmediata:** Manejo eficiente de flujos de bytes (`Uint8List`) para disparar descargas nativas en el navegador sin almacenamiento persistente forzado en el servidor.
* **Limpieza Automatizada:** El servidor elimina automáticamente los archivos del disco inmediatamente después de completar la descarga para garantizar la privacidad y optimizar el almacenamiento.

* ### Frontend
* **Flutter Web** (Canal Estable)
* **Dio** (Cliente HTTP para transferencias binarias de alto rendimiento)
* **desktop_drop** (Detección de eventos de arrastre en entornos web y escritorio)
* **universal_html** (Abstracción de la API del navegador para descargas nativas multiplataforma)

### Backend
* **FastAPI** (Framework asíncrono de Python de alto rendimiento y baja latencia)
* **pdf2docx** (Librería de Python basada en PyMuPDF para conversión geométrica avanzada)
* **Uvicorn** (Servidor ASGI rápido para producción)
* **Docker & Docker Compose** (Containerización y orquestación integral del entorno)
