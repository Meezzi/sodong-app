import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/region_view_model.dart';

class RegionSelector extends ConsumerWidget {
  const RegionSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var regions = ref.watch(regionsProvider);
    var selectedRegion = ref.watch(selectedRegionProvider);
    var selectedSubRegion = ref.watch(selectedSubRegionProvider);

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
    var regions = ref.read(regionsProvider);
    var selectedRegion = ref.read(selectedRegionProvider);

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
}

class RegionSelectionDialog extends ConsumerStatefulWidget {
  const RegionSelectionDialog({
    super.key,
    required this.regions,
    required this.initialRegion,
  });

  final List<Region> regions;
  final Region initialRegion;

  @override
  _RegionSelectionDialogState createState() => _RegionSelectionDialogState();
}

class _RegionSelectionDialogState extends ConsumerState<RegionSelectionDialog> {
  late Region _selectedRegion;
  late String _selectedSubRegion;

  @override
  void initState() {
    super.initState();
    _selectedRegion = widget.initialRegion;
    _selectedSubRegion = ref.read(selectedSubRegionProvider);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('지역 선택'),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 지역 목록
            Expanded(
              flex: 2,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.regions.length,
                itemBuilder: (context, index) {
                  var region = widget.regions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      region.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: _selectedRegion.id == region.id,
                    selectedColor: const Color(0xFFFF7B8E),
                    onTap: () {
                      setState(() {
                        _selectedRegion = region;
                        _selectedSubRegion = region.subRegions.first;
                      });
                    },
                  );
                },
              ),
            ),
            // 구분선
            const VerticalDivider(),
            // 하위 지역 목록
            Expanded(
              flex: 3,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedRegion.subRegions.length,
                itemBuilder: (context, index) {
                  var subRegion = _selectedRegion.subRegions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      subRegion,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: _selectedSubRegion == subRegion,
                    selectedColor: const Color(0xFFFF7B8E),
                    onTap: () {
                      setState(() {
                        _selectedSubRegion = subRegion;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.pop(context),
        //   child: const Text('취소'),
        // ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7B8E),
            ),
            onPressed: () {
              ref.read(selectedRegionProvider.notifier).state = _selectedRegion;
              ref.read(selectedSubRegionProvider.notifier).state =
                  _selectedSubRegion;
              Navigator.pop(context);
            },
            child: const Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
