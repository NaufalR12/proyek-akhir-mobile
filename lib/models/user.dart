import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String username;
  final String password;
  final String? profileImage;
  final String? email;
  final DateTime createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    this.profileImage,
    this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
} 