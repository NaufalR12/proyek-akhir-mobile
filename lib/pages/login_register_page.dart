import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../database/db.dart';
import 'home_page.dart';

class LoginRegisterPage extends StatefulWidget {
  final String initialTab; // 'login' or 'register'
  const LoginRegisterPage({super.key, this.initialTab = 'login'});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String tab = 'login';
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  final TextEditingController _loginUsername = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();
  final TextEditingController _regEmail = TextEditingController();
  final TextEditingController _regUsername = TextEditingController();
  final TextEditingController _regPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    tab = widget.initialTab;
  }

  void _showSnackbar(String msg, {Color color = Colors.red}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Future<void> _login() async {
    if (_formKeyLogin.currentState!.validate()) {
      String username = _loginUsername.text.trim();
      String password = _loginPassword.text;
      String hash = sha256.convert(utf8.encode(password)).toString();
      final user = await DB.instance.getUser(username);
      if (user != null && user['password'] == hash) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _showSnackbar('Username atau Password tidak sesuai');
      }
    }
  }

  Future<void> _register() async {
    if (_formKeyRegister.currentState!.validate()) {
      String email = _regEmail.text.trim();
      String username = _regUsername.text.trim();
      String password = _regPassword.text;
      String hash = sha256.convert(utf8.encode(password)).toString();
      final exist = await DB.instance.getUser(username);
      if (exist != null) {
        _showSnackbar('Username sudah terdaftar');
        return;
      }
      await DB.instance.insertUser(email, username, hash);
      _showSnackbar('Registrasi Berhasil!', color: Colors.green);
      setState(() {
        tab = 'login';
      });
    }
  }

  Widget _tabButton(String label, String value, bool isLeft) {
    bool selected = tab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tab = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? Colors.white : const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.only(
              topLeft: isLeft ? const Radius.circular(30) : const Radius.circular(0),
              bottomLeft: isLeft ? const Radius.circular(30) : const Radius.circular(0),
              topRight: !isLeft ? const Radius.circular(30) : const Radius.circular(0),
              bottomRight: !isLeft ? const Radius.circular(30) : const Radius.circular(0),
            ),
            boxShadow: selected
                ? [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.black : Colors.black38,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB6E5F8), Color(0xFFFDFCFB)],
                stops: [0.0, 0.7],
              ),
            ),
          ),
          // Wave putih di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(300, 40),
                  topRight: Radius.elliptical(300, 40),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 36),
                    Image.asset('assets/login-register.png', height: 140),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        _tabButton('Masuk', 'login', true),
                        _tabButton('Daftar', 'register', false),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (tab == 'login')
                      Form(
                        key: _formKeyLogin,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _loginUsername,
                              decoration: InputDecoration(
                                hintText: 'Masukan username anda',
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Username wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _loginPassword,
                              decoration: InputDecoration(
                                hintText: 'Masukan password anda',
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                              obscureText: true,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Password wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Form(
                        key: _formKeyRegister,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _regEmail,
                              decoration: InputDecoration(
                                hintText: 'Masukan email anda',
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Email wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _regUsername,
                              decoration: InputDecoration(
                                hintText: 'Masukan username anda',
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Username wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _regPassword,
                              decoration: InputDecoration(
                                hintText: 'Masukan password anda',
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                              obscureText: true,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Password wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
