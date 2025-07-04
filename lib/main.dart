import 'package:flutter/material.dart';
import 'package:couteau_app/views/home_view.dart'; // Importa la vista de inicio

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Couteau App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeView(), // Establece HomeView como la pantalla de inicio
      debugShowCheckedModeBanner: false, // Opcional: para quitar la etiqueta de "DEBUG"
    );
  }
}