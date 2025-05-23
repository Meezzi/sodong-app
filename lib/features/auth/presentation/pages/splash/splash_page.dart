import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/auth/domain/entities/user.dart';
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
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          final appUser = await fetchUserInfoFromFirestore(user.uid);
          ref.read(appUserProvider.notifier).state = appUser;
        }
        _navigateTo('/home');
        break;
    }
  }

  void _navigateTo(String route) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  Future<AppUser?> fetchUserInfoFromFirestore(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return AppUser(
      uid: uid,
      nickname: data['nickname'] ?? '',
      region: data['region'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }
}
