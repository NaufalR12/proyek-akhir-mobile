import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/feedback.dart';
import '../services/feedback_service.dart';
import '../services/auth_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackService = FeedbackService();
  final _authService = AuthService();
  final _messageController = TextEditingController();

  List<UserFeedback> _feedbacks = [];
  bool _isLoading = true;
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
  }

  Future<void> _loadFeedbacks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final feedbacks = await _feedbackService.getFeedbacks();
      setState(() {
        _feedbacks = feedbacks;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat feedback')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userId = await _authService.getCurrentUserId();
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anda harus login terlebih dahulu')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
        
        final feedback = UserFeedback(
          id: const Uuid().v4(),
          userId: userId,
          message: _messageController.text,
          rating: _rating,
          createdAt: DateTime.now(),
        );

        await _feedbackService.addFeedback(feedback);
        _messageController.clear();
        setState(() {
          _rating = 0;
        });
        await _loadFeedbacks();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback berhasil dikirim')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim feedback')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    } else if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih rating terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saran & Kesan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Feedback
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Berikan Saran & Kesan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Message
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Pesan',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pesan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _submitFeedback,
                        child: const Text('Kirim Feedback'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Daftar Feedback
            const Text(
              'Feedback Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_feedbacks.isEmpty)
              const Center(
                child: Text('Belum ada feedback'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _feedbacks.length,
                itemBuilder: (context, index) {
                  final feedback = _feedbacks[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${feedback.rating}'),
                      ),
                      title: Text(feedback.message),
                      subtitle: Text(
                        'Dikirim pada ${feedback.createdAt.toString().split('.')[0]}',
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
