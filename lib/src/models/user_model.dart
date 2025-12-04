import 'role_model.dart';

class UserModel {
  final int id;
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      lastname: json["lastname"],
      email: json["email"],
      phone: json["phone"] ?? "",
      roles: (json["roles"] as List)
          .map((r) => RoleModel.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "lastname": lastname,
      "email": email,
      "phone": phone,
      "roles": roles.map((r) => r.toJson()).toList(),
    };
  }
}
