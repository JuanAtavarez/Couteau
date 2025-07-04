import 'package:flutter/material.dart';
import 'package:couteau_app/services/api_service.dart';
import 'package:couteau_app/models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart'; // Para reproducir audio

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final TextEditingController _pokemonNameController = TextEditingController();
  Pokemon? _pokemon; // El Pokémon encontrado
  bool _isLoading = false;
  String _errorMessage = '';
  final AudioPlayer _audioPlayer = AudioPlayer(); // Reproductor de audio

  Future<void> _fetchPokemon() async {
    final name = _pokemonNameController.text.trim().toLowerCase(); // Convierte a minúsculas
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, introduce el nombre de un Pokémon.';
        _pokemon = null;
      });
      return;
    }

    setState(() {
      _isLoading = true; // Empieza a cargar
      _errorMessage = '';
      _pokemon = null;
    });

    try {
      // Llama a la API de PokeAPI
      final data = await ApiService.fetchData('https://pokeapi.co/api/v2/pokemon/$name');
      setState(() {
        _pokemon = Pokemon.fromJson(data); // Convierte el JSON a un objeto Pokemon
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al buscar Pokémon: $e. Asegúrate de que el nombre sea correcto.';
      });
    } finally {
      setState(() {
        _isLoading = false; // Termina de cargar
      });
    }
  }

  Future<void> _playPokemonCry(String? url) async {
    if (url != null && url.isNotEmpty) {
      try {
        await _audioPlayer.setUrl(url); // Carga el sonido desde la URL
        _audioPlayer.play(); // Reproduce el sonido
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al reproducir el sonido: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay sonido disponible para este Pokémon.')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libera los recursos del reproductor de audio al salir de la vista
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pokemonNameController,
              decoration: const InputDecoration(
                labelText: 'Introduce el nombre de un Pokémon (ej: pikachu)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchPokemon,
              child: const Text('Buscar Pokémon'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              )
            else if (_pokemon != null) // Si se encontró un Pokémon, lo muestra
              Expanded(
                child: SingleChildScrollView( // Permite hacer scroll si el contenido es grande
                  child: Column(
                    children: [
                      Text(
                        _pokemon!.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CachedNetworkImage(
                        imageUrl: _pokemon!.imageUrl,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error, size: 100),
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Experiencia Base: ${_pokemon!.baseExperience}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Habilidades: ${_pokemon!.abilities.join(', ')}', // Une las habilidades con comas
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _playPokemonCry(_pokemon!.cryUrl),
                        icon: const Icon(Icons.volume_up),
                        label: const Text('Reproducir Sonido'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}