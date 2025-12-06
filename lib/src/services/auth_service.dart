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
      final url = Uri.parse("$baseUrl/registro");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "lastname": lastname,
          "phone": phone,
          "email": email,
          "password": password,
        }),
      );

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      // 201 o 200 → éxito según tu backend
      return res.statusCode == 200 || res.statusCode == 201;

    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
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
  /// SESIÓN COMPLETA
  /// ----------------------------
  Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final userStr = prefs.getString("user");

    if (token == null || userStr == null) return null;

    final userJson = jsonDecode(userStr);

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
}
