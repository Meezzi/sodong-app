import 'package:flutter/material.dart';
import 'package:sodong_app/core/theme/app_colors.dart';

/// BuildContext에 테마 관련 확장 기능 추가
extension ThemeExtension on BuildContext {
  /// 현재 테마가 다크 모드인지 확인
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// 현재 테마의 색상 스키마
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// 테마에 따른 텍스트 기본 색상
  Color get textColor =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  /// 테마에 따른 텍스트 보조 색상
  Color get textSecondaryColor =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  /// 테마에 따른 배경 색상
  Color get backgroundColor =>
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

  /// 테마에 따른 카드 색상
  Color get cardColor =>
      isDarkMode ? AppColors.darkCardColor : AppColors.lightCardColor;

  /// 테마에 따른 구분선 색상
  Color get dividerColor => isDarkMode ? AppColors.grey700 : AppColors.grey300;

  /// 테마에 따른 아이콘 색상
  Color get iconColor => isDarkMode ? AppColors.grey200 : AppColors.grey700;
}
