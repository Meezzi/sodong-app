import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/theme/app_theme.dart';
import 'package:sodong_app/core/theme/theme_provider.dart';
import 'package:sodong_app/core/theme/theme_settings_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/login/login_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/agreement_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/location_policy_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/privacy_policy_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/terms_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/profile_edit/profile_edit.dart';
import 'package:sodong_app/features/auth/presentation/pages/splash/splash_page.dart';
import 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';
import 'package:sodong_app/features/post_list/presentation/pages/post_list_page.dart';
import 'package:sodong_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 테마 모드 상태 감시
    final themeMode = ref.watch(themeProvider);

    // 시스템 설정인 경우 현재 시스템 밝기 가져오기
    final brightness = ref.watch(brightnessProvider(context));

    // 현재 다크 모드인지 확인
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

    // 상태바 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(
      isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: const Color(0xFF303030),
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '소소한동네',

      // 테마 설정
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      initialRoute: '/',
      routes: {
        '/': (context) => const PostListPage(),
        '/agreement': (context) => const AgreementPage(),
        '/terms': (context) => const TermsPage(),
        '/privacy_policy': (context) => const PrivacyPolicyPage(),
        '/location_policy': (context) => const LocationPolicyPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const ProfileEdit(),
        '/home': (context) => const PostListPage(),
        '/create_post': (context) => const CreatePostPage(),
        '/theme_settings': (context) => const ThemeSettingsPage(),
      },
    );
  }
}
