import 'package:flutter/material.dart';

class UploadCard extends StatelessWidget {
  final bool isLoading;
  final bool isDragging;
  final String statusMessage;
  final VoidCallback onTap;

  const UploadCard({
    super.key,
    required this.isLoading,
    required this.isDragging,
    required this.statusMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colores dinámicos según el estado para el diseño moderno
    final backgroundColor = isLoading 
        ? Colors.grey.shade50 
        : (isDragging ? Colors.blue.shade50 : Colors.white);
        
    final borderColor = isDragging ? Colors.blue.shade600 : Colors.grey.shade300;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24), // Bordes bien redondeados modernos
          border: Border.all(
            color: borderColor,
            width: 2,
            style: BorderStyle.solid, // Nota: Si usas desktop_drop puedes cambiar a dashed
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono o Indicador de carga animado
              if (isLoading)
                const CircularProgressIndicator(strokeWidth: 3)
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDragging ? Colors.blue.shade100 : Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDragging ? Icons.file_download : Icons.picture_as_pdf,
                    size: 40,
                    color: isDragging ? Colors.blue.shade700 : Colors.red.shade600,
                  ),
                ),
              const SizedBox(height: 24),
              
              // Mensaje de estado principal
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtexto de ayuda
              if (!isLoading)
                Text(
                  isDragging ? "¡Suéltalo ya!" : "Haz clic para buscar en tus carpetas",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}