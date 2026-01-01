import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nexxus/src/presentation/pages/auth/login/login_response.dart';
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = "http://10.15.14.20:3000";

  /// ----------------------------
  /// LOGIN
  /// ----------------------------
  Future<LoginResponse?> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/auth/login");

      final res = await http.post(
        url,
        headers: const {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      final loginResponse = LoginResponse.fromJson(data);

      await _saveSession(loginResponse);
      return loginResponse;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null;
    }
  }

  /// ----------------------------
  /// REGISTRO
  /// ----------------------------
  Future<bool> register({
    required String name,
    required String lastname,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/auth/registro");

      final res = await http.post(
        url,
        headers: const {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "lastname": lastname,
          "phone": phone,
          "email": email,
          "password": password,
        }),
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// REGISTRO DE VEHÍCULO
  /// ----------------------------
  Future<bool> registerCar(Map<String, dynamic> carData) async {
    try {
      final url = Uri.parse("$baseUrl/cars/register");
      // Obtenemos los headers con el Token (Authorization)
      final headers = await authHeaders();

      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(carData),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      print("❌ ERROR REGISTRO CARRO (${res.statusCode}): ${res.body}");
      return false;
    } catch (e) {
      print("REGISTER CAR ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// ACTUALIZAR EVIDENCIA KILOMETRAJE
  /// ----------------------------
  Future<bool> updateEvidenceKm({
    required String userId,
    required int km,
    required double lat,
    required double lng,
    File? image,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/evidences/update/$userId");
      
      // Ajuste: Enviar como JSON Raw (application/json) para coincidir con Postman
      final headers = await authHeaders();

      final body = {
        "km_inicial": km,
        "start_lat": lat,
        "start_lng": lng,
      };

      print("🚀 Sending evidence update (JSON) to: $url");
      print("   Body: $body");

      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print("✅ Response Status Code: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode >= 400) {
        print("🛑 ERROR EN PETICIÓN: Código ${response.statusCode}");
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ UPDATE EVIDENCE ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// ASIGNAR VEHÍCULO (Assignment)
  /// ----------------------------
  Future<bool> createAssignment({required int userId, required int carId}) async {
    try {
      final url = Uri.parse("$baseUrl/assignment/create-assignment-evidence");
      final headers = await authHeaders();

      final body = {
        "user_id": userId,
        "car_id": carId,
      };

      print("🚀 Creating Assignment...");
      print("   URL: $url");
      print("   Body: $body");

      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      print("❌ ERROR ASIGNACIÓN (${res.statusCode}): ${res.body}");
      return false;
    } catch (e) {
      print("ASSIGNMENT ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// GUARDAR SESIÓN
  /// ----------------------------
  Future<void> _saveSession(LoginResponse response) async {
  final prefs = await SharedPreferences.getInstance();

  // Normalizar token (quitar "Bearer " si viene incluido)
  String token = response.accessToken.trim();
  if (token.startsWith("Bearer ")) {
    token = token.replaceFirst("Bearer ", "");
  }

  await prefs.setString("token", token);
  await prefs.setString("user", jsonEncode(response.user.toJson()));
}

  /// ----------------------------
  /// HEADERS AUTENTICADOS (CLAVE)
  /// ----------------------------
  Future<Map<String, String>> authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      throw Exception("Token no disponible");
    }

    // Asegurar que el token no tenga espacios extra ni el prefijo Bearer duplicado
    token = token.trim();
    if (token.startsWith("Bearer ")) {
      token = token.replaceFirst("Bearer ", "");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  /// ----------------------------
  /// USUARIO LOGGEADO
  /// ----------------------------
  Future<UserModel?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("user");

    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  /// ----------------------------
  /// TOKEN SOLAMENTE
  /// ----------------------------
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// ----------------------------
  /// LOGOUT
  /// ----------------------------
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// ----------------------------
  /// LISTADO DE CARROS
  /// ----------------------------
  Future<List<CarModel>> getAllCars() async {
    final url = Uri.parse("$baseUrl/cars/all");
    final headers = await authHeaders();

    final res = await http.get(url, headers: headers);

    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode}: ${res.body}");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => CarModel.fromJson(e)).toList();
  }
}
