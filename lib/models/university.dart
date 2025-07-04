class University {
  final String name;
  final String? domain;
  final String? webPage;

  University({required this.name, this.domain, this.webPage});

  // Constructor de fábrica para crear un objeto University desde un JSON recibido de la API
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] as String,
      domain: json['domains'] != null && (json['domains'] as List).isNotEmpty
          ? (json['domains'] as List).first // Toma el primer dominio de la lista
          : null,
      webPage: json['web_pages'] != null && (json['web_pages'] as List).isNotEmpty
          ? (json['web_pages'] as List).first // Toma la primera URL de página web
          : null,
    );
  }
}