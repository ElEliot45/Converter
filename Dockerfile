# Usar una imagen oficial de Python ligera
FROM python:3.11-slim

# Instalar dependencias del sistema necesarias para procesamiento de PDFs/gráficos
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Definir el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo de requerimientos e instalar librerías de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código del backend
COPY . .

# Exponer el puerto 8000
EXPOSE 8000

# Comando para arrancar FastAPI con Uvicorn (usando 0.0.0.0 para permitir conexiones externas)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]