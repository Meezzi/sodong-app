import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/login.png'),
        SizedBox(
          height: 40,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // 구글 로고 (이미지 사용 권장)
          Image.asset('assets/google.png', height: 30),
          const SizedBox(width: 16),
          Text(
            '구글 계정으로 시작하기',
            style: const TextStyle(fontSize: 20),
          )
        ])
      ]),
    );
  }
}
