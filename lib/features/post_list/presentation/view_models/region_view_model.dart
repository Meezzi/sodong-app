import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';

// 선택된 지역 프로바이더
final selectedRegionProvider = StateProvider<Region>((ref) => regionList.first);

// 선택된 하위 지역 프로바이더
final selectedSubRegionProvider = StateProvider<String>((ref) {
  final selectedRegion = ref.watch(selectedRegionProvider);
  return selectedRegion.subRegions.first;
});

// 지역 목록 프로바이더
final regionsProvider = Provider<List<Region>>((ref) => regionList);

// 현재 선택된 지역의 하위 지역 목록 프로바이더
final subRegionsProvider = Provider<List<String>>((ref) {
  final selectedRegion = ref.watch(selectedRegionProvider);
  return selectedRegion.subRegions;
});
