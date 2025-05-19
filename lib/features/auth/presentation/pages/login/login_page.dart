import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/location/location_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
    // 첫 진입 시 위치 정보 자동 가져오기
    Future.microtask(() {
      ref.read(locationProvider.notifier).getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/login.png'),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/auth/light/google_login_button_light.svg',
                  height: 60,
                ),
              ],
            ),
            const SizedBox(height: 40),
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
            )
          ],
        ),
      ),
    );
  }
}
