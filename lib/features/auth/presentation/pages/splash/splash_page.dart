import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/auth/domain/usecase/check_user_status_usecase.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE6E9),
      body: Center(
        child: Image(
          image: AssetImage('assets/splash.png'),
          width: 250,
          height: 250,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkUserStatus());
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final useCase = ref.read(checkUserStatusUsecaseProvider);
    final status = await useCase.execute();

    switch (status) {
      case UserStatus.notLoggedIn:
        _navigateTo('/login');
        break;
      case UserStatus.agreementNotComplete:
        _navigateTo('/agreement');
        break;
      case UserStatus.agreementComplete:
        _navigateTo('/home');
        break;
    }
  }

  void _navigateTo(String route) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }
}
