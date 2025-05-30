import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _notificationService = NotificationService();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DateTime? _scheduledDate;

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
  }

  Future<void> _showNotification() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan pesan tidak boleh kosong')),
      );
      return;
    }

    await _notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: _titleController.text,
      body: _bodyController.text,
    );

    _titleController.clear();
    _bodyController.clear();
  }

  Future<void> _scheduleNotification() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan pesan tidak boleh kosong')),
      );
      return;
    }

    if (_scheduledDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih waktu notifikasi')),
      );
      return;
    }

    await _notificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: _titleController.text,
      body: _bodyController.text,
      scheduledDate: _scheduledDate!,
    );

    _titleController.clear();
    _bodyController.clear();
    setState(() {
      _scheduledDate = null;
    });
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _scheduledDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Notifikasi
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kirim Notifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Judul
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pesan
                    TextField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Pesan',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Waktu Terjadwal
                    if (_scheduledDate != null) ...[
                      Text(
                        'Terjadwal pada: ${_scheduledDate.toString().split('.')[0]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Tombol Pilih Waktu
                    OutlinedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_scheduledDate == null
                          ? 'Pilih Waktu'
                          : 'Ubah Waktu'),
                    ),
                    const SizedBox(height: 16),

                    // Tombol Kirim
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showNotification,
                            child: const Text('Kirim Sekarang'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _scheduleNotification,
                            child: const Text('Jadwalkan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Informasi
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Notifikasi akan muncul di perangkat Anda\n'
                      '• Notifikasi terjadwal akan muncul pada waktu yang ditentukan\n'
                      '• Anda dapat mengirim notifikasi sekarang atau menjadwalkannya untuk waktu tertentu',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
