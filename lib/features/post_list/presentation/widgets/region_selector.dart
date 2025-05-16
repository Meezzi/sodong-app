import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/region_view_model.dart';

class RegionSelector extends ConsumerWidget {
  const RegionSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regions = ref.watch(regionsProvider);
    final selectedRegion = ref.watch(selectedRegionProvider);
    final selectedSubRegion = ref.watch(selectedSubRegionProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _showRegionSelectionDialog(context, ref),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: Color(0xFFFF7B8E)),
                const SizedBox(width: 4),
                Text(
                  '${selectedRegion.name} ${selectedSubRegion}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              _showRegionSelectionDialog(context, ref);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune, size: 14, color: Colors.grey),
                  SizedBox(width: 2),
                  Text('지역 설정', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 지역 선택 다이얼로그 표시
  void _showRegionSelectionDialog(BuildContext context, WidgetRef ref) {
    final regions = ref.read(regionsProvider);
    final selectedRegion = ref.read(selectedRegionProvider);

    showDialog(
      context: context,
      builder: (context) {
        return RegionSelectionDialog(
          regions: regions,
          initialRegion: selectedRegion,
        );
      },
    );
  }
  
  void RegionSelectionDialog({required List<Region> regions, required Region initialRegion}) {}
}
