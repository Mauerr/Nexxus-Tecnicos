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
  /// ACTUALIZAR VEHÍCULO
  /// ----------------------------
  Future<bool> updateCar(int id, Map<String, dynamic> carData) async {
    try {
      final url = Uri.parse("$baseUrl/cars/update/$id");
      final headers = await authHeaders();

      print("🚀 Updating Car ID: $id");
      print("   Body: $carData");

      final res = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(carData),
      );

      print("✅ Response Status: ${res.statusCode}");
      print("📦 Response Body: ${res.body}");

      if (res.statusCode != 200 && res.statusCode != 201) {
        print("⚠️ ERROR UPDATE: Código ${res.statusCode} - ${res.body}");
      }

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print("❌ UPDATE CAR ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// ELIMINAR VEHÍCULO
  /// ----------------------------
  Future<bool> deleteCar(int id) async {
    try {
      final url = Uri.parse("$baseUrl/cars/delete_car/$id");
      final headers = await authHeaders();

      print("🚀 Deleting Car ID: $id");

      final res = await http.delete(url, headers: headers);

      print("✅ Response Status: ${res.statusCode}");
      
      if (res.statusCode != 200 && res.statusCode != 201 && res.statusCode != 204) {
        print("⚠️ ERROR DELETE: Código ${res.statusCode} - ${res.body}");
      }

      return res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204;
    } catch (e) {
      print("❌ DELETE CAR ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// SUBIR IMAGEN EVIDENCIA (POST)
  /// ----------------------------
  Future<bool> uploadEvidencePhoto({
    required int idEvidence,
    required String typeEvidence,
    required String typeImage,
    required String typeStatus,
    required File file,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/evidences-img/create");
      final request = http.MultipartRequest('POST', url);

      // Headers
      final headers = await authHeaders();
      headers.remove('Content-Type'); // Multipart se encarga del boundary
      request.headers.addAll(headers);

      // Fields
      request.fields['id_evidence'] = idEvidence.toString();
      request.fields['type_evidence'] = typeEvidence;
      request.fields['type_image'] = typeImage;
      request.fields['type_status'] = typeStatus;

      // File
      final multipartFile = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(multipartFile);

      print("🚀 Uploading Evidence ($typeImage)...");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("✅ Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ UPLOAD EVIDENCE PHOTO ERROR: $e");
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

      print("✅ Assignment Response Status: ${res.statusCode}");
      print("📦 Assignment Response Body: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        // 🔹 Guardar el ID de la evidencia creada para usarlo en las fotos
        try {
          final data = jsonDecode(res.body);
          int? extractedId;
          
          print("🔍 Analizando respuesta para ID. Keys: ${data is Map ? data.keys.toList() : 'No es Map'}");

          // Helper para parsear ID (maneja int y String)
          int? parseId(dynamic value) {
            if (value is int) return value;
            if (value is String) return int.tryParse(value);
            return null;
          }

          // Búsqueda robusta del ID
          if (data is Map) {
            // 1. Buscar en raíz
            extractedId = parseId(data['id']) ?? parseId(data['id_evidence']) ?? parseId(data['evidence_id']);
            
            // 2. Buscar en 'data' o 'evidence'
            if (extractedId == null && data['data'] is Map) extractedId = parseId(data['data']['id']) ?? parseId(data['data']['id_evidence']);
            if (extractedId == null && data['evidence'] is Map) extractedId = parseId(data['evidence']['id']) ?? parseId(data['evidence']['id_evidence']);
          }

          if (extractedId != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('current_evidence_id', extractedId);
            print("✅ Evidence ID guardado localmente: $extractedId");
          } else {
            print("⚠️ No se encontró el ID en la respuesta del servidor.");
          }
        } catch (e) {
          print("⚠️ No se pudo guardar el ID de la evidencia: $e");
        }
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
  /// CREAR MANTENIMIENTO
  /// ----------------------------
  Future<bool> createMaintenance({
    required int idCars,
    required String typeMaintenance,
    required int kilometros,
    required String mecanico,
    required String notes,
    required bool isMaintenance,
    String? imagePath,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/maintenance/create");
      final request = http.MultipartRequest('POST', url);

      // 1. Obtener headers y remover Content-Type para que Multipart funcione
      final headers = await authHeaders();
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      // 2. Agregar campos de texto
      request.fields['id_cars'] = idCars.toString();
      request.fields['type_maintenance'] = typeMaintenance;
      request.fields['kilometros'] = kilometros.toString();
      request.fields['mecanica'] = mecanico;
      request.fields['notes'] = notes;
      request.fields['is_maintenance'] = isMaintenance ? '1' : '0';

      // 3. Agregar imagen si existe
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = await http.MultipartFile.fromPath('file', imagePath);
        request.files.add(file);
      }

      print("🚀 Creating Maintenance (Multipart)...");
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("✅ Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ CREATE MAINTENANCE ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// OBTENER MANTENIMIENTOS POR CARRO (Endpoint 3)
  /// ----------------------------
  Future<List<dynamic>> getMaintenancesByCar(int carId) async {
    try {
      final url = Uri.parse("$baseUrl/maintenance/car/$carId");
      final headers = await authHeaders();
      
      print("🚀 Getting Maintenances for Car ID: $carId");

      final res = await http.get(url, headers: headers);
      
      print("✅ Response Status: ${res.statusCode}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body); // Retorna lista de mantenimientos
      }
      return [];
    } catch (e) {
      print("❌ GET MAINTENANCE ERROR: $e");
      return [];
    }
  }

  /// ----------------------------
  /// ACTUALIZAR DATOS (Endpoint 1: Notas y KM)
  /// ----------------------------
  Future<bool> updateMaintenanceData({
    required int id,
    required int idCars,
    required String typeMaintenance,
    required int kilometros,
    required String mecanica,
    required String notes,
    required bool isMaintenance,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/maintenance/update/$id");
      final headers = await authHeaders();

      final body = {
        "notes": notes,
        "kilometros": kilometros,
      };

      print("🚀 Updating Maintenance Data (PUT)...");
      print("   URL: $url");
      print("   Body: $body");

      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      
      print("✅ Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ UPDATE DATA ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// ACTUALIZAR IMAGEN Y NOTAS (Endpoint 2)
  /// ----------------------------
  Future<bool> updateMaintenanceImage({
    required int id,
    required String notes,
    required String imagePath,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/maintenance/update-image/$id"); // Ajusta ruta
      final request = http.MultipartRequest('PUT', url);

      final headers = await authHeaders();
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      request.fields['notes'] = notes; // El endpoint pide notas también
      
      final file = await http.MultipartFile.fromPath('file', imagePath);
      request.files.add(file);

      print("🚀 Updating Maintenance Image (Multipart PUT)...");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("✅ Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ UPDATE IMAGE ERROR: $e");
      return false;
    }
  }

  /// ----------------------------
  /// OBTENER ÚLTIMA EVIDENCIA POR CARRO
  /// ----------------------------
  Future<Map<String, dynamic>?> getLatestEvidenceByCar(int carId) async {
    try {
      // Asumimos endpoint estándar para obtener la última evidencia
      final url = Uri.parse("$baseUrl/evidences/car/$carId/latest");
      final headers = await authHeaders();
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (e) {
      print("❌ GET LATEST EVIDENCE ERROR: $e");
      return null;
    }
  }

  /// ----------------------------
  /// OBTENER IMÁGENES DE EVIDENCIA
  /// ----------------------------
  Future<List<dynamic>> getEvidenceImages(int evidenceId) async {
    try {
      final url = Uri.parse("$baseUrl/evidences-img/evidence/$evidenceId");
      final headers = await authHeaders();
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        return List<dynamic>.from(jsonDecode(res.body));
      }
      return [];
    } catch (e) {
      print("❌ GET EVIDENCE IMAGES ERROR: $e");
      return [];
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
