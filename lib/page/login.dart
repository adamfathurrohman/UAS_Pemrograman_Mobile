// login.dart
import 'package:flutter/material.dart';
import 'package:news_app/page/AdminPage.dart';
import 'package:news_app/page/UserPage.dart';
import 'package:news_app/page/register.dart';
import 'package:news_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    final success = await loginProvider.login(email, password);
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    final name = prefs.getString('name') ?? '';

    if (success) {
  if (role == 'admin') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminHomePage(
          name: name,
        ),
      ),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserHomePage(
          name: name,
        ),
      ),
    );
  }
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(loginProvider.errorMessage)),
  );
}

}

  @override
Widget build(BuildContext context) {
  final loginProvider = Provider.of<LoginProvider>(context);

  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Kembali ke halaman sebelumnya (WelcomePage)
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0, // Transparan agar menyatu dengan background
    ),
    extendBodyBehindAppBar: true, // AppBar menyatu dengan gambar background
    body: Stack(
      children: [
        // Background Image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login.jpg'), // Gambar latar
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Content
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                _header(),
                const SizedBox(height: 40),
                _inputFields(loginProvider),
                const SizedBox(height: 20),
                _forgotPassword(),
                const SizedBox(height: 40),
                _signup(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _header() {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Enter your credentials to login",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _inputFields(LoginProvider loginProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Username Input Field
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white.withOpacity(0.7),
            filled: true,
            prefixIcon: const Icon(Icons.person, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 16),
        // Password Input Field
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white.withOpacity(0.7),
            filled: true,
            prefixIcon: const Icon(Icons.lock, color: Colors.blue),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        // Login Button
        loginProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
      ],
    );
  }

  Widget _forgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Implementasi lupa password
        },
        child: const Text(
          "Forgot password?",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
