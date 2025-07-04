import 'package:flutter/material.dart';
import 'package:couteau_app/views/gender_predictor_view.dart';
import 'package:couteau_app/views/age_predictor_view.dart';
import 'package:couteau_app/views/university_view.dart';
import 'package:couteau_app/views/weather_view.dart';
import 'package:couteau_app/views/pokemon_view.dart';
import 'package:couteau_app/views/wordpress_news_view.dart';
import 'package:couteau_app/views/about_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Couteau App: Tu Caja de Herramientas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Permite hacer scroll si el contenido es muy largo
        child: Column(
          children: [
            // Imagen de la caja de herramientas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/toolbox.png', // Tu imagen de la caja de herramientas
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const Text(
              '¡Bienvenido a tu aplicación multiusos!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Cuadrícula de opciones para navegar
            GridView.count(
              shrinkWrap: true, // El GridView ocupa solo el espacio que necesita
              physics: const NeverScrollableScrollPhysics(), // Deshabilita el scroll interno del GridView
              crossAxisCount: 2, // Muestra 2 columnas de botones
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0, // Espacio vertical entre los botones
              crossAxisSpacing: 16.0, // Espacio horizontal entre los botones
              children: [
                _buildFeatureCard(context, 'Predecir Género', Icons.person, const GenderPredictorView()),
                _buildFeatureCard(context, 'Predecir Edad', Icons.cake, const AgePredictorView()),
                _buildFeatureCard(context, 'Buscar Universidades', Icons.school, const UniversityView()),
                _buildFeatureCard(context, 'Clima en RD', Icons.cloud, const WeatherView()),
                _buildFeatureCard(context, 'Info. Pokémon', Icons.catching_pokemon, const PokemonView()),
                _buildFeatureCard(context, 'Noticias WordPress', Icons.rss_feed, const WordpressNewsView()),
                _buildFeatureCard(context, 'Acerca de', Icons.info, const AboutView()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear una tarjeta de característica (un botón en el Grid)
  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Widget view) {
    return Card(
      elevation: 5, // Sombra de la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Bordes redondeados
      child: InkWell( // Hace que la tarjeta sea clicable
        onTap: () {
          Navigator.push( // Navega a la nueva vista
            context,
            MaterialPageRoute(builder: (context) => view),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).primaryColor), // Icono de la característica
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}