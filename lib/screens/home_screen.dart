import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'cek_ongkir_screen.dart';
import 'konversi_uang_screen.dart';
import 'konversi_waktu_screen.dart';
import 'profile_screen.dart';
import 'feedback_screen.dart';
import 'accelerometer_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _authService = AuthService();

  final List<Widget> _screens = [
    const CekOngkirScreen(),
    const KonversiUangScreen(),
    const KonversiWaktuScreen(),
    const ProfileScreen(),
    const FeedbackScreen(),
    const AccelerometerScreen(),
    const NotificationScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 5) {
      // Logout
      _logout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Ongkir App'),
        automaticallyImplyLeading: false,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Cek Ongkir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Konversi Uang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Konversi Waktu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.screen_rotation),
            label: 'Sensor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
        ],
      ),
    );
  }
}
