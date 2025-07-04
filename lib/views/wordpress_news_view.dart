import 'package:flutter/material.dart';
import 'package:couteau_app/services/api_service.dart';
import 'package:couteau_app/models/wordpress_post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';

class WordpressNewsView extends StatefulWidget {
  const WordpressNewsView({super.key});

  @override
  State<WordpressNewsView> createState() => _WordpressNewsViewState();
}

class _WordpressNewsViewState extends State<WordpressNewsView> {
  List<WordpressPost> _posts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final String _wordpressApiUrl =
      'https://deultimominuto.net/wp-json/wp/v2/posts?per_page=3';

  @override
  void initState() {
    super.initState();
    _fetchWordpressPosts();
  }

  Future<void> _fetchWordpressPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final List<dynamic> data =
          await ApiService.fetchDataList(_wordpressApiUrl);
      setState(() {
        _posts = data.map((json) => WordpressPost.fromJson(json)).toList();
        if (_posts.isEmpty) {
          _errorMessage =
              'No se encontraron noticias. Verifica la URL de la API o si el blog tiene publicaciones recientes.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Error al cargar las noticias de WordPress: $e. Verifica tu conexión a internet.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace: $url')),
      );
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias de WordPress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo local desde assets
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                'assets/wordpress_logo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              )
            else if (_posts.isEmpty)
              const Text(
                'No se encontraron noticias.',
                style: TextStyle(fontSize: 16),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _parseHtmlString(post.excerpt),
                              style: const TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () => _launchURL(post.link),
                                child: const Text('Visitar noticia original'),
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
