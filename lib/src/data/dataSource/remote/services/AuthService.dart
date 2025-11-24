import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexxus/src/data/api/ApiConfig.dart';
import 'package:nexxus/src/domain/models/AuthResponse.dart';

class Authservice {

  Future<AuthResponse?> login(String email, String password) async {
    // Lógica para autenticar al usuario
    try {
      Uri url = Uri.http(ApiConfig.API_PROYECT, '/auth/login');
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = json.encode({
        'email': email,
        'password': password
      });
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      // Parsear la respuesta y devolver un AuthResponse
      AuthResponse authResponse = AuthResponse.fromJson(data);
      print('Data Remote: ${authResponse.toJson()}');
      print('Token: ${authResponse.accessToken}');
      return authResponse;
} catch (e) {
      // Manejo de errores
      print('Error $e');
      return null;
    }
  }
}