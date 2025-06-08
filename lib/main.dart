import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/auth/presentation/pages/login/login_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/agreement_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/location_policy_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/privacy_policy_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/terms_page.dart';
import 'package:sodong_app/features/auth/presentation/pages/profile_edit/profile_edit.dart';
import 'package:sodong_app/features/auth/presentation/pages/splash/splash_page.dart';
import 'package:sodong_app/features/post/presentation/pages/create_post/create_post_page.dart';
import 'package:sodong_app/features/post/presentation/pages/post_list/post_list_page.dart';
import 'package:sodong_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/agreement': (context) => const AgreementPage(),
        '/terms': (context) => const TermsPage(),
        '/privacy_policy': (context) => const PrivacyPolicyPage(),
        '/location_policy': (context) => const LocationPolicyPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const ProfileEdit(),
        '/home': (context) => const PostListPage(),
        '/create_post': (context) => const CreatePostPage(),
      },
    );
  }
}
