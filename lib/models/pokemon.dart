class Pokemon {
  final String name;
  final String imageUrl;
  final int baseExperience;
  final List<String> abilities;
  final String? cryUrl; // URL del sonido del Pokémon (puede ser nula)

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.baseExperience,
    required this.abilities,
    this.cryUrl,
  });

  // Constructor de fábrica para crear un objeto Pokemon desde un JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> abilities = (json['abilities'] as List)
        .map((abilityJson) => abilityJson['ability']['name'].toString().capitalizeFirst())
        .toList();

    return Pokemon(
      name: json['name'].toString().capitalizeFirst(),
      imageUrl: json['sprites']['front_default'] ?? '', // Si no hay sprite, usa cadena vacía
      baseExperience: json['base_experience'] ?? 0, // Si no hay experiencia, usa 0
      abilities: abilities,
      cryUrl: json['cries']['latest']   // URL del sonido más reciente
    );
  }
}

// Extensión para capitalizar la primera letra de una cadena
extension StringCasingExtension on String {
  String capitalizeFirst() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}