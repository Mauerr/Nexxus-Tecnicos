class CarModel {
  final int id;
  final String model;
  final String matricula;

  CarModel({
    required this.id,
    required this.model,
    required this.matricula,
  });

  String get label => '$matricula - $model';

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      model: json['model'],
      matricula: json['matricula'],
    );
  }
}
