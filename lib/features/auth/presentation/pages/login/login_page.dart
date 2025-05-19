import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // 중앙 정렬 보장
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/login.png'),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // 테두리 추가
                borderRadius: BorderRadius.circular(8), // 둥근 모서리
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // 내용 크기만큼만 차지
                children: [
                  Image.asset('assets/google.png', height: 30),
                  const SizedBox(width: 16),
                  const Text(
                    '구글 계정으로 시작하기',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
