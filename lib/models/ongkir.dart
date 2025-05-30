import 'package:json_annotation/json_annotation.dart';

part 'ongkir.g.dart';

@JsonSerializable()
class OngkirResponse {
  final Rajaongkir rajaongkir;

  OngkirResponse({required this.rajaongkir});

  factory OngkirResponse.fromJson(Map<String, dynamic> json) =>
      _$OngkirResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OngkirResponseToJson(this);
}

@JsonSerializable()
class Rajaongkir {
  final Query query;
  final Status status;
  final List<Result> results;

  Rajaongkir({
    required this.query,
    required this.status,
    required this.results,
  });

  factory Rajaongkir.fromJson(Map<String, dynamic> json) =>
      _$RajaongkirFromJson(json);
  Map<String, dynamic> toJson() => _$RajaongkirToJson(this);
}

@JsonSerializable()
class Query {
  final String origin;
  final String destination;
  final int weight;
  final String courier;

  Query({
    required this.origin,
    required this.destination,
    required this.weight,
    required this.courier,
  });

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
  Map<String, dynamic> toJson() => _$QueryToJson(this);
}

@JsonSerializable()
class Status {
  final int code;
  final String description;

  Status({required this.code, required this.description});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

@JsonSerializable()
class Result {
  final String code;
  final String name;
  final List<Cost> costs;

  Result({
    required this.code,
    required this.name,
    required this.costs,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Cost {
  final String service;
  final String description;
  final List<CostDetail> cost;

  Cost({
    required this.service,
    required this.description,
    required this.cost,
  });

  factory Cost.fromJson(Map<String, dynamic> json) => _$CostFromJson(json);
  Map<String, dynamic> toJson() => _$CostToJson(this);
}

@JsonSerializable()
class CostDetail {
  final int value;
  final String etd;
  final String note;

  CostDetail({
    required this.value,
    required this.etd,
    required this.note,
  });

  factory CostDetail.fromJson(Map<String, dynamic> json) =>
      _$CostDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CostDetailToJson(this);
}
