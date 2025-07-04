import 'package:flutter/material.dart';
import 'package:couteau_app/services/api_service.dart';

class GenderPredictorView extends StatefulWidget {
  const GenderPredictorView({super.key});

  @override
  State<GenderPredictorView> createState() => _GenderPredictorViewState();
}

class _GenderPredictorViewState extends State<GenderPredictorView> {
  final TextEditingController _nameController = TextEditingController();
  String _genderResult = '';
  Color _displayColor = Colors.grey; // Color inicial gris

  Future<void> _predictGender() async {
    final name = _nameController.text.trim(); // Obtiene el nombre sin espacios extra
    if (name.isEmpty) {
      setState(() {
        _genderResult = 'Por favor, introduce un nombre.';
        _displayColor = Colors.grey;
      });
      return;
    }

    try {
      // Llama a la API de genderize.io para predecir el género
      final data = await ApiService.fetchData('https://api.genderize.io/?name=$name');
      final gender = data['gender'];
      final probability = data['probability'] * 100; // Convierte la probabilidad a porcentaje

      if (gender == 'male') {
        setState(() {
          _genderResult = 'Es ${gender == 'male' ? 'masculino' : 'femenino'} con ${probability.toStringAsFixed(2)}% de probabilidad.';
          _displayColor = Colors.blue; // Muestra azul para masculino
        });
      } else if (gender == 'female') {
        setState(() {
          _genderResult = 'Es ${gender == 'male' ? 'masculino' : 'femenino'} con ${probability.toStringAsFixed(2)}% de probabilidad.';
          _displayColor = Colors.pink; // Muestra rosa para femenino
        });
      } else {
        setState(() {
          _genderResult = 'No se pudo determinar el género para "$name".';
          _displayColor = Colors.grey; // Gris si no se determina
        });
      }
    } catch (e) {
      setState(() {
        _genderResult = 'Error: $e'; // Mensaje de error
        _displayColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predecir Género'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Introduce un nombre',
                border: OutlineInputBorder(), // Borde del campo de texto
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictGender,
              child: const Text('Predecir Género'),
            ),
            const SizedBox(height: 20),
            // Contenedor para mostrar el resultado con el color
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _displayColor.withOpacity(0.3), // Fondo semitransparente
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _displayColor),
              ),
              child: Text(
                _genderResult,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _displayColor == Colors.grey ? Colors.black : _displayColor.darken(0.2), // Color del texto ajustado
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pequeña extensión para oscurecer un color, para que el texto sea visible
extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}