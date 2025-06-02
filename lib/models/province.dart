class Province {
  final String provinceId;
  final String province;

  Province({required this.provinceId, required this.province});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      provinceId: json['province_id'],
      province: json['province'],
    );
  }
}
