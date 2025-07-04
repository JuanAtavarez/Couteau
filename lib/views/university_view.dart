import 'package:flutter/material.dart';
import 'package:couteau_app/services/api_service.dart';
import 'package:couteau_app/models/university.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir enlaces web

class UniversityView extends StatefulWidget {
  const UniversityView({super.key});

  @override
  State<UniversityView> createState() => _UniversityViewState();
}

class _UniversityViewState extends State<UniversityView> {
  final TextEditingController _countryController = TextEditingController();
  List<University> _universities = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchUniversities() async {
    final country = _countryController.text.trim();
    if (country.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, introduce el nombre de un país.';
        _universities = [];
      });
      return;
    }

    setState(() {
      _isLoading = true; // Empieza a cargar
      _errorMessage = '';
    });

    try {
      // Llama a la API de universidades. Usamos fetchDataList porque devuelve una lista.
      final List<dynamic> data = await ApiService.fetchDataList(
          'http://universities.hipolabs.com/search?country=${Uri.encodeComponent(country)}'); // Codifica el nombre del país para la URL
      setState(() {
        _universities = data.map((json) => University.fromJson(json)).toList(); // Convierte los JSON a objetos University
      });
      if (_universities.isEmpty) {
        setState(() {
          _errorMessage = 'No se encontraron universidades para "$country".';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // Termina de cargar
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) { // Comprueba si se puede abrir la URL
      await launchUrl(uri); // Abre la URL
    } else {
      ScaffoldMessenger.of(context).showSnackBar( // Muestra un mensaje si no se puede abrir
        SnackBar(content: Text('No se pudo abrir el enlace: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades por País'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Introduce un país (ej: Dominican Republic)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchUniversities,
              child: const Text('Buscar Universidades'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator() // Muestra un indicador de carga
            else if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              )
            else if (_universities.isEmpty && _countryController.text.isNotEmpty)
              const Text(
                'No se encontraron universidades para este país.',
                style: TextStyle(fontSize: 16),
              )
            else
              Expanded( // La lista ocupa el espacio restante
                child: ListView.builder(
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final university = _universities[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              university.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (university.domain != null)
                              Text('Dominio: ${university.domain}'),
                            if (university.webPage != null)
                              InkWell( // Hace que el texto del enlace sea clicable
                                onTap: () => _launchURL(university.webPage!),
                                child: Text(
                                  'Web: ${university.webPage}',
                                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}