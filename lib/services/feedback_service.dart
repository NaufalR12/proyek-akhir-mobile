import 'dart:async';
import '../models/feedback.dart';

class FeedbackService {
  final List<UserFeedback> _feedbacks = [];

  Future<List<UserFeedback>> getFeedbacks() async {
    // Simulasi delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _feedbacks;
  }

  Future<void> addFeedback(UserFeedback feedback) async {
    // Simulasi delay
    await Future.delayed(const Duration(milliseconds: 500));
    _feedbacks.add(feedback);
  }

  Future<void> deleteFeedback(String id) async {
    // Simulasi delay
    await Future.delayed(const Duration(milliseconds: 500));
    _feedbacks.removeWhere((feedback) => feedback.id == id);
  }
}
