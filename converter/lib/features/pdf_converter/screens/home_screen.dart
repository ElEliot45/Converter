import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// Importamos el widget que acabamos de crear arriba:
import 'package:converter/features/pdf_converter/widgets/upload_card.dart';
import 'package:dio/dio.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _isDragging = false; // Cambiar a true si integras la librería 'desktop_drop'
  String _statusMessage = "Arrastra tu PDF aquí para convertirlo a Word";

  final String _backendUrl = "http://localhost:8000/convertir";

  Future<void> _ejecutarConversion(Uint8List fileBytes, String pdfName) async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Preparando archivo...";
    });

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(fileBytes, filename: pdfName),  
      });

      setState(() {
        _statusMessage = "Subiendo y convirtiendo PDF en Docker...";
      });

      Response response = await dio.post(
        _backendUrl,
        data: formData,
        options: Options(
          responseType: ResponseType.bytes, 
        ),
      );

      setState(() {
        _statusMessage = "Descargando archivo Word generado...";
      });

      
      final wordBytes = response.data as List<int>;
      final blob = html.Blob([wordBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final nombreWord = pdfName.replaceAll('.pdf', '.docx');

      html.AnchorElement(href: url)
        ..download = nombreWord
        ..click();

    } on DioException catch (dioError) {
      String errorMensaje = "Error de conexión con el servidor";
      if (dioError.response != null) {
        errorMensaje = "Error del servidor: ${dioError.response?.statusMessage}";
      }
      setState(() {
        _statusMessage = errorMensaje;
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Ocurrió un error inesperado";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Esta función solo abre el explorador de carpetas y le pasa el archivo a la función de arriba
  Future<void> _procesarConversionDesdePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Importante para obtener los bytes del archivo
    );

    if (result == null || result.files.single.path == null) return;

    final archivo = result.files.single;

    // Al conseguir el archivo, llamamos al método que conecta a Docker
    _ejecutarConversion(archivo.bytes!, result.files.single.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Convertidor",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              Text(
                "Transforma tus archivos PDF a Word en segundos.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              
              // 2. Envolvemos el UploadCard dentro de DropTarget para detectar el arrastre
              DropTarget(
                onDragEntered: (details) => setState(() => _isDragging = true),
                onDragExited: (details) => setState(() => _isDragging = false),
                onDragDone: (details) async {
                  setState(() => _isDragging = false);
                  
                  // Validamos si soltaron un archivo y si es PDF
                  if (details.files.isNotEmpty) {
                    final archivoSuelto = details.files.first;
                    
                    if (archivoSuelto.name.toLowerCase().endsWith('.pdf')) {
                      // Enviamos el archivo arrastrado directamente a la conversión
                      final bytes = await archivoSuelto.readAsBytes();
                      _ejecutarConversion(bytes, archivoSuelto.name);
                    } else {
                      setState(() {
                        _statusMessage = "Por favor, arrastra únicamente archivos PDF.";
                      });
                    }
                  }
                },
                child: UploadCard(
                  isLoading: _isLoading,
                  isDragging: _isDragging, // Ahora sí cambia dinámicamente
                  statusMessage: _statusMessage,
                  onTap: _procesarConversionDesdePicker, // Clic normal
                ),
              ),
              
              const Spacer(),
              Center(
                child: Text(
                  "Powered by FastAPI & Docker",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}