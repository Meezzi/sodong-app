import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/theme/app_colors.dart';
import 'package:sodong_app/core/theme/theme_provider.dart';
import 'package:sodong_app/core/theme/theme_widgets.dart';

/// 테마 설정 화면
class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 테마 모드 상태 감시
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    // 시스템 설정을 따르는 경우 플랫폼 밝기도 감시
    final brightness = ref.watch(brightnessProvider(context));

    // 현재 다크 모드인지 확인
    final isDark = currentTheme == ThemeMode.dark ||
        (currentTheme == ThemeMode.system && brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 설정'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 테마 설정 헤더
              const Text(
                '앱 테마 모드 설정',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '앱에서 사용할 테마 모드를 선택해주세요. 시스템 설정을 사용하면 기기의 테마 설정을 따릅니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.grey400 : AppColors.grey600,
                ),
              ),
              const SizedBox(height: 24),

              // 테마 선택 옵션
              const Card(
                margin: EdgeInsets.zero,
                child: ThemeSwitch(),
              ),

              const SizedBox(height: 24),

              // 테마 미리보기
              const Text(
                '테마 미리보기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 라이트/다크 테마 미리보기
              Row(
                children: [
                  Expanded(
                    child: _buildThemePreview(
                      context,
                      title: '라이트 모드',
                      isDarkPreview: false,
                      isDarkTheme: isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildThemePreview(
                      context,
                      title: '다크 모드',
                      isDarkPreview: true,
                      isDarkTheme: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 테마 미리보기 위젯
  Widget _buildThemePreview(
    BuildContext context, {
    required String title,
    required bool isDarkPreview,
    required bool isDarkTheme,
  }) {
    // 미리보기에 사용할 색상
    final backgroundColor =
        isDarkPreview ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor =
        isDarkPreview ? AppColors.darkCardColor : AppColors.lightCardColor;
    final textColor =
        isDarkPreview ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryTextColor = isDarkPreview
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkTheme ? AppColors.grey700 : AppColors.grey300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          // 미리보기 카드
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '게시물 제목',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '게시물 내용 미리보기',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 12, color: secondaryTextColor),
                    Icon(Icons.favorite_border,
                        size: 12, color: secondaryTextColor),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 버튼 미리보기
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              '버튼',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
