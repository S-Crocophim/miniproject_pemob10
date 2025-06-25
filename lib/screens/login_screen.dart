// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Ganti nama controller agar lebih sesuai dengan input email
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    // Validasi input sebelum mengirim ke Firebase
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Panggil fungsi login yang baru, yang mengembalikan String? (pesan error)
    final errorMessage = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // FIX: Periksa apakah errorMessage TIDAK null, bukan menegasi boolean
    if (errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
    // Jika errorMessage adalah null, berarti login berhasil, dan StreamBuilder di main.dart akan otomatis mengarahkan ke Dashboard.
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final errorMessage = await authProvider.register(
      _emailController.text.trim(),
      _passwordController.text.trim()
    );

    if (errorMessage == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.'), backgroundColor: Colors.green),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage!), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form( // Bungkus dengan widget Form untuk validasi
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.ac_unit, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                const Text('Cold Room Monitoring', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                TextFormField( // Ganti TextField menjadi TextFormField
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email', // Ganti label menjadi Email
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) { // Tambahkan validasi sederhana
                    if (value == null || value.trim().isEmpty || !value.contains('@')) {
                      return 'Masukkan email yang valid.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField( // Ganti TextField menjadi TextFormField
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                   validator: (value) {
                    if (value == null || value.trim().isEmpty || value.length < 6) {
                      return 'Password minimal harus 6 karakter.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (authProvider.isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                       SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: const Text('Login'),
                        ),
                      ),
                      TextButton(
                        onPressed: _register,
                        child: const Text('Buat Akun Baru'),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}