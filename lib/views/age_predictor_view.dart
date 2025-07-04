import 'package:flutter/material.dart';
import 'package:couteau_app/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Para cargar imágenes de red

class AgePredictorView extends StatefulWidget {
  const AgePredictorView({super.key});

  @override
  State<AgePredictorView> createState() => _AgePredictorViewState();
}

class _AgePredictorViewState extends State<AgePredictorView> {
  final TextEditingController _nameController = TextEditingController();
  String _ageMessage = '';
  int? _predictedAge;
  String? _imageUrl; // URL de la imagen a mostrar

  Future<void> _predictAge() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _ageMessage = 'Por favor, introduce un nombre.';
        _predictedAge = null;
        _imageUrl = null;
      });
      return;
    }

    try {
      // Llama a la API de agify.io para predecir la edad
      final data = await ApiService.fetchData('https://api.agify.io/?name=$name');
      final age = data['age'];

      setState(() {
        _predictedAge = age;
        if (age == null) {
          _ageMessage = 'No se pudo determinar la edad para "$name".';
          _imageUrl = null;
        } else if (age < 25) { // Rango para "joven"
          _ageMessage = '¡Eres joven!';
          _imageUrl = 'https://picsum.photos/id/1011/400/300'; // Imagen de persona joven (ejemplo)
        } else if (age >= 25 && age < 60) { // Rango para "adulto"
          _ageMessage = 'Eres un adulto.';
          _imageUrl = 'https://picsum.photos/id/1025/400/300'; // Imagen de persona adulta (ejemplo)
        } else { // Rango para "anciano"
          _ageMessage = 'Eres un anciano.';
          _imageUrl = 'https://picsum.photos/id/1062/400/300'; // Imagen de persona anciana (ejemplo)
        }
      });
    } catch (e) {
      setState(() {
        _ageMessage = 'Error: $e';
        _predictedAge = null;
        _imageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predecir Edad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Introduce un nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictAge,
              child: const Text('Predecir Edad'),
            ),
            const SizedBox(height: 20),
            if (_predictedAge != null) // Solo muestra la edad si se predijo
              Text(
                'Edad: $_predictedAge años',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            Text(
              _ageMessage,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_imageUrl != null) // Solo muestra la imagen si hay URL
              ClipRRect( // Para bordes redondeados en la imagen
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: _imageUrl!,
                  placeholder: (context, url) => const CircularProgressIndicator(), // Indicador de carga
                  errorWidget: (context, url, error) => const Icon(Icons.error), // Icono si la imagen falla
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}