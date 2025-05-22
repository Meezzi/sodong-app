import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goToLogin();
  }

  void _goToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await Navigator.pushReplacementNamed(context, '/login');
  }
}

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
