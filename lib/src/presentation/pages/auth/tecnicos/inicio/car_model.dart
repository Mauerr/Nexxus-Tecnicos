class CarModel {
  final int? id;
  final String label;
  final String? marca;
  final String? model;
  final int? year;
  final String? color;
  final String? matricula;

  CarModel({
    this.id,
    required this.label,
    this.marca,
    this.model,
    this.year,
    this.color,
    this.matricula,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      // Si el backend no envía 'label', lo construimos con marca y modelo
      label: json['label'] ?? "${json['marca'] ?? ''} ${json['model'] ?? ''}".trim(),
      marca: json['marca'],
      model: json['model'],
      // Manejo seguro por si el año viene como String o Int
      year: json['year'] is String ? int.tryParse(json['year']) : json['year'],
      color: json['color'],
      matricula: json['matricula'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "marca": marca,
        "model": model,
        "year": year,
        "color": color,
        "matricula": matricula,
      };
}
