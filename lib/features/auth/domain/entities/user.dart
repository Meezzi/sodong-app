import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.nickname,
    required this.region,
    required this.profileImageUrl,
  });

  final String uid;
  final String nickname;
  final String region;
  final String profileImageUrl;
}

final appUserProvider = StateProvider<AppUser?>((ref) => null);
