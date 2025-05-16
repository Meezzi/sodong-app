import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE6E9),
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
