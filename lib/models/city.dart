class City {
  final String cityId;
  final String cityName;
  final String type;

  City({required this.cityId, required this.cityName, required this.type});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['city_id'],
      cityName: json['city_name'],
      type: json['type'],
    );
  }

  String get fullName => "$type $cityName"; // misal "Kabupaten Sleman"
}
