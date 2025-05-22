import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/theme/app_colors.dart';
import 'package:sodong_app/core/theme/theme_provider.dart';

/// 테마 설정 스위치 위젯
class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = themeNotifier.isDarkMode(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 테마 모드 선택 라디오 버튼
        RadioListTile<ThemeMode>(
          title: const Text('시스템 설정 사용'),
          value: ThemeMode.system,
          groupValue: currentTheme,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              themeNotifier.setTheme(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('라이트 모드'),
          value: ThemeMode.light,
          groupValue: currentTheme,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              themeNotifier.setTheme(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('다크 모드'),
          value: ThemeMode.dark,
          groupValue: currentTheme,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              themeNotifier.setTheme(value);
            }
          },
        ),
      ],
    );
  }
}

/// 테마 모드 토글 버튼
class ThemeModeToggle extends ConsumerWidget {
  const ThemeModeToggle({Key? key, this.size = 24.0}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 테마 모드 상태 감시하여 UI 업데이트
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    // 시스템 설정을 따르는 경우 플랫폼 밝기도 감시
    final brightness = ref.watch(brightnessProvider(context));

    // 현재 다크 모드인지 확인
    final isDark = currentTheme == ThemeMode.dark ||
        (currentTheme == ThemeMode.system && brightness == Brightness.dark);

    return IconButton(
      icon: Icon(
        isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        size: size,
      ),
      onPressed: () {
        // 현재 테마 모드 기준으로 반대 모드로 변경
        themeNotifier.setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
      },
      tooltip: isDark ? '라이트 모드로 전환' : '다크 모드로 전환',
      color: isDark ? AppColors.primary : AppColors.primary,
    );
  }
}
