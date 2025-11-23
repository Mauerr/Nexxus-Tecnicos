class AuthService {
  Future<Map<String, dynamic>?> login(String user, String pass) async {
    await Future.delayed(const Duration(seconds: 1));

    if (user == "admin" && pass == "1234") {
      return {"role": "admin"};
    }

    if (user == "tecnico" && pass == "1234") {
      return {"role": "tecnico"};
    }

    return null;
  }
}
