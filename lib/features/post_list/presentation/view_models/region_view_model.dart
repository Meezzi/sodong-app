import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/domain/entities/region.dart';

// 선택된 지역 프로바이더
final selectedRegionProvider = StateProvider<Region>((ref) => regionList.first);

// 선택된 하위 지역 프로바이더
final selectedSubRegionProvider = StateProvider<String>((ref) {
  var selectedRegion = ref.watch(selectedRegionProvider);
  return selectedRegion.subRegions.first;
});

// 지역 목록 프로바이더
final regionsProvider = Provider<List<Region>>((ref) => regionList);

// 현재 선택된 지역의 하위 지역 목록 프로바이더
final subRegionsProvider = Provider<List<String>>((ref) {
  var selectedRegion = ref.watch(selectedRegionProvider);
  return selectedRegion.subRegions;
});

// 사용자의 지역 설정 프로바이더
final userRegionProvider =
    Provider<Future<void> Function(String regionText)>((ref) {
  return (String regionText) async {
    // 지역 문자열을 파싱 (예: "서울특별시 강남구" -> 지역:"서울특별시", 하위지역:"강남구")
    final parts = regionText.split(' ');
    if (parts.length < 2) return;

    final regionName = parts[0]; // 예: "서울특별시"
    final subRegion = parts[1]; // 예: "강남구"

    // regionList에서 해당 지역 찾기
    Region? matchedRegion;
    for (var region in regionList) {
      if (region.name == regionName) {
        matchedRegion = region;
        break;
      }
    }

    if (matchedRegion != null && matchedRegion.subRegions.contains(subRegion)) {
      // 지역과 하위지역 모두 매칭되면 설정
      ref.read(selectedRegionProvider.notifier).state = matchedRegion;
      ref.read(selectedSubRegionProvider.notifier).state = subRegion;
    }
  };
});

// 로그인 사용자의 위치 정보 로드 프로바이더
final loadUserRegionProvider = FutureProvider<void>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (userDoc.exists && userDoc.data()!.containsKey('region')) {
      final region = userDoc.data()!['region'] as String;
      await ref.read(userRegionProvider)(region);
    }
  } catch (e) {
    print('사용자 지역 정보 로드 실패: $e');
  }
});
