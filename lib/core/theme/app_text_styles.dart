import 'package:flutter/material.dart';
import 'package:sodong_app/core/theme/app_colors.dart';

/// 앱 전체에서 사용되는 텍스트 스타일 정의
class AppTextStyles {
  // 헤드라인 스타일
  static TextStyle headline1({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 24,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }

  static TextStyle headline2({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }

  static TextStyle headline3({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
    );
  }

  // 본문 텍스트 스타일
  static TextStyle body1({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }

  static TextStyle body2({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }

  // 작은 텍스트 스타일
  static TextStyle caption({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? AppColors.grey600,
    );
  }

  // 버튼 텍스트 스타일
  static TextStyle button({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.white,
    );
  }

  // 레이블 텍스트 스타일
  static TextStyle label({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.grey700,
    );
  }
}
