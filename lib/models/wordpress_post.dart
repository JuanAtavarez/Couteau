class WordpressPost {
  final String title;
  final String excerpt;
  final String link;

  WordpressPost({required this.title, required this.excerpt, required this.link});

  // Constructor de fábrica para crear un objeto WordpressPost desde un JSON
  factory WordpressPost.fromJson(Map<String, dynamic> json) {
    return WordpressPost(
      title: json['title']['rendered'] as String, // Título de la noticia
      excerpt: json['excerpt']['rendered'] as String, // Resumen de la noticia
      link: json['link'] as String, // Enlace a la noticia original
    );
  }
}