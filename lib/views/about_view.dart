import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir enlaces

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  // !!! REEMPLAZA ESTO CON TUS DATOS REALES !!!
  final String _yourName = 'Juan Alberto Tavarez Alcantara';
  final String _yourMatricula = '2023-0672';
  final String _yourEmail = 'juantavarezalc0@gmail.com';
  final String _yourLinkedInUrl = 'https://www.linkedin.com/in/JuanTavarezAlc'; 
  final String _yourGithubUrl = 'https://github.com/JuanAtavarez'; 
  final String _yourPhotoAsset = 'assets/my_profile_photo.jpg';

  // Función para abrir URLs (correos, LinkedIn, GitHub)

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el enlace: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de Mí'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80, // Tamaño foto
                
                
                backgroundImage: AssetImage(_yourPhotoAsset),
                onBackgroundImageError: (exception, stackTrace) {
                  debugPrint('Error al cargar la imagen de perfil: $exception');
                 
                },
                
              ),
              const SizedBox(height: 20),
              Text(
                _yourName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Matrícula: $_yourMatricula',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Datos de Contacto:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(_yourEmail),
                
                onTap: () => _launchURL(context, 'mailto:$_yourEmail'),
              ),
              if (_yourLinkedInUrl.isNotEmpty) 
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('LinkedIn'),
                  
                  onTap: () => _launchURL(context, _yourLinkedInUrl),
                ),
              if (_yourGithubUrl.isNotEmpty) 
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitHub'),
                  
                  onTap: () => _launchURL(context, _yourGithubUrl),
                ),
              const SizedBox(height: 30),
              const Text(
                '¡Abierto a nuevas oportunidades laborales!',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}