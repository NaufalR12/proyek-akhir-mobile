class CostResult {
  final String service;
  final String description;
  final int value;

  CostResult({
    required this.service,
    required this.description,
    required this.value,
  });

  factory CostResult.fromJson(Map<String, dynamic> json) {
    return CostResult(
      service: json['service'],
      description: json['description'],
      value: json['cost'][0]['value'],
    );
  }
}
