import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/location/location_viewmodel.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(locationProvider.notifier).getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 여기에 회원가입 관련 입력 필드들 추가 가능
            const TextField(decoration: InputDecoration(labelText: '이메일')),
            const TextField(decoration: InputDecoration(labelText: '비밀번호')),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ref.read(locationProvider.notifier).getLocation();
              },
              child: const Text('위치 다시 불러오기'),
            ),
            const SizedBox(height: 20),
            Text(
              '위도: ${location.y}\n경도: ${location.x}\n지역: ${location.region ?? "불러오는 중..."}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
