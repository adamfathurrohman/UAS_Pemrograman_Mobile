import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:news_app/page/login.dart';
import 'package:news_app/page/register.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/download1.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Icon
                const Icon(
                  Icons.newspaper,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 20),

                // App Title with Slide-in Animation
                SlideInWidget(
                  delay: 300,
                  child: const Text(
                    "Welcome to NewsApp",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),

                // Tagline
                const Text(
                  "Your daily dose of trusted news",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 80),

                // Buttons aligned horizontally
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login Button
                    _ModernButton(
                      text: "Login",
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      icon: Icons.login,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                    const SizedBox(width: 20),

                    // Register Button
                    _ModernButton(
                      text: "Register",
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      icon: Icons.app_registration,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Footer text
                const Text(
                  "Powered by Flutter",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Modern Button
class _ModernButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final VoidCallback onPressed;

  const _ModernButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Slide-in Animation Widget
class SlideInWidget extends StatelessWidget {
  final Widget child;
  final int delay;

  const SlideInWidget({
    required this.child,
    required this.delay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, Offset offset, _) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
    );
  }
}
