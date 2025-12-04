import 'package:nexxus/src/models/user_model.dart';

class LoginResponse {
  final UserModel user;
  final String accessToken;

  LoginResponse({
    required this.user,
    required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json["user"]),
      accessToken: json["access_token"],
    );
  }
}
