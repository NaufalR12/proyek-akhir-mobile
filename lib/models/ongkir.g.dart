// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ongkir.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OngkirResponse _$OngkirResponseFromJson(Map<String, dynamic> json) =>
    OngkirResponse(
      rajaongkir:
          Rajaongkir.fromJson(json['rajaongkir'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OngkirResponseToJson(OngkirResponse instance) =>
    <String, dynamic>{
      'rajaongkir': instance.rajaongkir,
    };

Rajaongkir _$RajaongkirFromJson(Map<String, dynamic> json) => Rajaongkir(
      query: Query.fromJson(json['query'] as Map<String, dynamic>),
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RajaongkirToJson(Rajaongkir instance) =>
    <String, dynamic>{
      'query': instance.query,
      'status': instance.status,
      'results': instance.results,
    };

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      weight: (json['weight'] as num).toInt(),
      courier: json['courier'] as String,
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'weight': instance.weight,
      'courier': instance.courier,
    };

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      code: (json['code'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      code: json['code'] as String,
      name: json['name'] as String,
      costs: (json['costs'] as List<dynamic>)
          .map((e) => Cost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'costs': instance.costs,
    };

Cost _$CostFromJson(Map<String, dynamic> json) => Cost(
      service: json['service'] as String,
      description: json['description'] as String,
      cost: (json['cost'] as List<dynamic>)
          .map((e) => CostDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
      'service': instance.service,
      'description': instance.description,
      'cost': instance.cost,
    };

CostDetail _$CostDetailFromJson(Map<String, dynamic> json) => CostDetail(
      value: (json['value'] as num).toInt(),
      etd: json['etd'] as String,
      note: json['note'] as String,
    );

Map<String, dynamic> _$CostDetailToJson(CostDetail instance) =>
    <String, dynamic>{
      'value': instance.value,
      'etd': instance.etd,
      'note': instance.note,
    };
