import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/theme/app_colors.dart';
import 'package:sodong_app/core/theme/theme_provider.dart';
import 'package:sodong_app/core/theme/theme_widgets.dart';

/// 테마 관련 헬퍼 기능
class ThemeHelper {
  /// 앱바에 테마 전환 버튼 추가
  static List<Widget> getThemeActionsForAppBar(
      BuildContext context, WidgetRef ref) {
    return [
      // 테마 전환 버튼
      const ThemeModeToggle(),

      // 테마 설정 페이지로 이동하는 버튼
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, '/theme_settings');
        },
        tooltip: '테마 설정',
      ),
    ];
  }

  /// 테마에 따른 Scaffold 배경 장식 (optional)
  static BoxDecoration? getScaffoldDecoration(
      BuildContext context, WidgetRef ref) {
    // 현재 테마 모드 상태 감시
    final currentTheme = ref.watch(themeProvider);

    // 시스템 설정을 따르는 경우 플랫폼 밝기도 감시
    final brightness = ref.watch(brightnessProvider(context));

    // 현재 다크 모드인지 확인
    final isDark = currentTheme == ThemeMode.dark ||
        (currentTheme == ThemeMode.system && brightness == Brightness.dark);

    if (isDark) {
      // 다크 모드 배경 (옵션: 그라데이션 등 커스텀 효과 적용 가능)
      return const BoxDecoration(
        color: AppColors.darkBackground,
      );
    } else {
      // 라이트 모드 배경
      return const BoxDecoration(
        color: AppColors.lightBackground,
      );
    }
  }
}
