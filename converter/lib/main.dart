import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'features/pdf_converter/screens/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Converter',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // O la fuente de tu preferencia
      ),
      home: const HomeScreen(), 
    );
  }
}

