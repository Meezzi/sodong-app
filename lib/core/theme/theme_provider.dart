import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 상태 관리 노티파이어
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  /// 앱 시작 시 저장된 테마 설정 불러오기
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);

      if (themeIndex != null &&
          themeIndex >= 0 &&
          themeIndex < ThemeMode.values.length) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (e) {
      debugPrint('테마 설정 로드 오류: $e');
    }
  }

  /// 테마 모드 변경
  Future<void> setTheme(ThemeMode mode) async {
    try {
      // 상태 업데이트
      state = mode;

      // 설정 저장 (ThemeMode의 인덱스를 저장)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
      debugPrint('테마 모드 저장됨: ${mode.toString()} (인덱스: ${mode.index})');
    } catch (e) {
      debugPrint('테마 설정 저장 오류: $e');
    }
  }

  /// 현재 시스템 설정에 따른 밝기 모드 반환
  Brightness getSystemBrightness(BuildContext context) {
    return MediaQuery.of(context).platformBrightness;
  }

  /// 현재 테마 모드가 어두운 테마인지 확인
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return getSystemBrightness(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}

/// 현재 테마 모드 프로바이더
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// 테마 모드에 따른 밝기 프로바이더
final brightnessProvider =
    Provider.family<Brightness, BuildContext>((ref, context) {
  final themeMode = ref.watch(themeProvider);
  final themeNotifier = ref.read(themeProvider.notifier);

  if (themeMode == ThemeMode.system) {
    return themeNotifier.getSystemBrightness(context);
  }

  return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
});
