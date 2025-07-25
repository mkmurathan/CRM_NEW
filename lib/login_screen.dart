import 'package:flutter/material.dart';
import 'canias_service.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı adı ve şifre girin!'),
          backgroundColor: Color(0xFF1976D2),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    final ok = await CaniasService.loginWithParams(username, password);
    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    if (ok) {
      // 👇 Giriş yapan kullanıcıyı sakla
      CaniasService.currentUserName = username;

      // ✅ HomeScreen'e geçiş yap
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: username),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Giriş başarısız!'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0055A5),
        title: const Text("Giriş Yap"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/Urtim-Logo-300-DPI-Big.png',
                  height: 120,
                ),
                const SizedBox(height: 40),

                // Kullanıcı Adı
                TextField(
                  controller: _usernameController,
                  cursorColor: const Color(0xFF1976D2),
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    labelStyle: const TextStyle(color: Color(0xFF0055A5)),
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFF1976D2)),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFF1976D2), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Şifre
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  cursorColor: const Color(0xFF1976D2),
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    labelStyle: const TextStyle(color: Color(0xFF0055A5)),
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFF1976D2)),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFF1976D2), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Giriş Butonu
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0055A5)))
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0055A5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: const Color(0xFF1976D2),
                            elevation: 3,
                          ),
                          child: const Text(
                            "Giriş Yap",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
