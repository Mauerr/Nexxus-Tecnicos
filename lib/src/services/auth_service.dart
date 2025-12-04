import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nexxus/src/presentation/pages/auth/login/login_response.dart';
import '../models/user_model.dart';

class AuthService {

  final String baseUrl = "http://10.15.14.20:3000/auth";

  /// ----------------------------
  /// LOGIN
  /// ----------------------------
  Future<LoginResponse?> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (res.statusCode != 200) {
        return null;
      }

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
  /// GUARDAR SESIÓN
  /// ----------------------------
  Future<void> _saveSession(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", response.accessToken);
    await prefs.setString("user", jsonEncode(response.user.toJson()));
  }

  /// ----------------------------
  /// LEER USUARIO LOGGEADO
  /// ----------------------------
  Future<UserModel?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("user");

    if (data == null) return null;

    return UserModel.fromJson(jsonDecode(data));
  }

/// ----------------------------
  /// LEER SESIÓN COMPLETA (token + user)
  /// Este método lo pide tu LoginGate, HomeScreen, etc.

    Future<Map<String, dynamic>?> getSession() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("token");
  final userStr = prefs.getString("user");

  if (token == null || userStr == null) return null;

  final userJson = jsonDecode(userStr);

  // Recuperar el primer rol
  final role = (userJson["roles"] as List).isNotEmpty
      ? userJson["roles"][0]["id"].toString().toLowerCase()
      : null;

  return {
    "token": token,
    "name": userJson["name"],
    "role": role,
  };
}


  /// ----------------------------
  /// LEER SESIÓN COMPLETA (token + user)
  /// Este método lo pide tu LoginGate, HomeScreen, etc.
  /// ----------------------------
  /*Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final user = prefs.getString("user");

    if (token == null || user == null) return null;

    return {
      "token": token,
      "user": jsonDecode(user),
    };
  }*/

  /// ----------------------------
  /// OBTENER SOLO TOKEN
  /// ----------------------------
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// ----------------------------
  /// CERRAR SESIÓN
  /// ----------------------------
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
