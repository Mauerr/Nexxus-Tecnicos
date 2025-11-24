import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  /// Login "quemado"
  Future<Map<String, dynamic>?> login(String user, String pass) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // EJEMPLO: credenciales de ejemplo.. cambiarlas a como se necesite
    if (user == 'admin' && pass == '1234') {
      return {
        'username': user,
        'role': 'admin',
      };
    }

    if (user == 'tecnico' && pass == '1234') {
      return {
        'username': user,
        'role': 'tecnico',
      };
    }

    return null;
  }

  /// ─────────────────────────────────────
  ///  MÉTODOS DE SESIÓN LOCAL
  /// ─────────────────────────────────────

  static const _keyLoggedIn = 'logged_in';
  static const _keyUsername = 'username';
  static const _keyRole = 'role';

  /// Guarda sesión después de un login exitoso
  Future<void> saveSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUsername, userData['username'] ?? '');
    await prefs.setString(_keyRole, userData['role'] ?? '');
  }

  /// Borra la sesión (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyRole);
  }

  /// ¿Hay alguien logueado?
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  /// Obtiene el rol actual (o null si no hay sesión)
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  /// Devuelve un map con los datos de sesión (o null)
  Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool(_keyLoggedIn) ?? false;
    if (!logged) return null;

    return {
      'username': prefs.getString(_keyUsername),
      'role': prefs.getString(_keyRole),
    };
  }
}
