import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class UserFeedback {
  final String id;
  final String userId;
  final String message;
  final int rating;
  final DateTime createdAt;

  UserFeedback({
    required this.id,
    required this.userId,
    required this.message,
    required this.rating,
    required this.createdAt,
  });

  factory UserFeedback.fromJson(Map<String, dynamic> json) =>
      _$UserFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$UserFeedbackToJson(this);
}
