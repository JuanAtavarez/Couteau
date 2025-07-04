import 'dart:convert'; // Para convertir datos de/a JSON
import 'package:http/http.dart' as http; // La librería para hacer peticiones HTTP

class ApiService {
  // Función para obtener datos que vienen como un objeto (Map)
  static Future<Map<String, dynamic>> fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url)); // Realiza la petición GET
      if (response.statusCode == 200) { // Si la respuesta es exitosa (código 200)
        return json.decode(response.body); // Decodifica el cuerpo de la respuesta de JSON a un Map
      } else {
        // Si hay un error, lanza una excepción con el código de estado
        throw Exception('Falló la carga de datos: ${response.statusCode}');
      }
    } catch (e) {
      // Si hay un error de conexión o similar
      throw Exception('Error al obtener datos: $e');
    }
  }

  // Función para obtener datos que vienen como una lista de objetos (List)
  static Future<List<dynamic>> fetchDataList(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Decodifica de JSON a una List
      } else {
        throw Exception('Falló la carga de la lista: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener lista de datos: $e');
    }
  }
}