class RoleModel {
  final String id;
  final String name;
  final String route;

  RoleModel({
    required this.id,
    required this.name,
    required this.route,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json["id"],
      name: json["name"],
      route: json["route"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "route": route,
    };
  }
}
