import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/region_view_model.dart';

class RegionSelector extends ConsumerWidget {
  const RegionSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedRegion = ref.watch(selectedRegionProvider);
    var selectedSubRegion = ref.watch(selectedSubRegionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRegionDisplay(
              context, ref, selectedRegion, selectedSubRegion, isDark),
          _buildRegionSettingButton(context, ref, isDark),
        ],
      ),
    );
  }

  Widget _buildRegionDisplay(BuildContext context, WidgetRef ref,
      Region selectedRegion, String selectedSubRegion, bool isDark) {
    return InkWell(
      onTap: () => _showRegionSelectionDialog(context, ref),
      child: Row(
        children: [
          Icon(Icons.location_on,
              size: 16,
              color:
                  isDark ? const Color(0xFFFF9CAA) : const Color(0xFFFF7B8E)),
          const SizedBox(width: 4),
          Text(
            '${selectedRegion.name} $selectedSubRegion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down,
              color: isDark ? Colors.grey[400] : Colors.black54),
        ],
      ),
    );
  }

  Widget _buildRegionSettingButton(
      BuildContext context, WidgetRef ref, bool isDark) {
    return InkWell(
      onTap: () {
        _showRegionSelectionDialog(context, ref);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Color(0xFFFFD5DE)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.tune,
                size: 14, color: isDark ? Colors.grey[400] : Colors.black54),
            const SizedBox(width: 2),
            Text('지역 설정',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                )),
          ],
        ),
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
  ConsumerState<RegionSelectionDialog> createState() =>
      _RegionSelectionDialogState();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        '지역 선택',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      content: _buildDialogContent(isDark),
      actions: [
        _buildConfirmButton(isDark),
      ],
    );
  }

  Widget _buildDialogContent(bool isDark) {
    return SizedBox(
      width: double.maxFinite,
      height: 500,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRegionList(isDark),
          VerticalDivider(
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          _buildSubRegionList(isDark),
        ],
      ),
    );
  }

  Widget _buildRegionList(bool isDark) {
    return Expanded(
      flex: 2,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.regions.length,
        itemBuilder: (context, index) {
          var region = widget.regions[index];
          return _buildRegionListItem(region, isDark);
        },
      ),
    );
  }

  Widget _buildRegionListItem(Region region, bool isDark) {
    return ListTile(
      dense: true,
      title: Text(
        region.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      selected: _selectedRegion.id == region.id,
      selectedColor: isDark ? const Color(0xFFFF9CAA) : const Color(0xFFFF7B8E),
      onTap: () {
        setState(() {
          _selectedRegion = region;
          _selectedSubRegion = region.subRegions.first;
        });
      },
    );
  }

  Widget _buildSubRegionList(bool isDark) {
    return Expanded(
      flex: 3,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _selectedRegion.subRegions.length,
        itemBuilder: (context, index) {
          var subRegion = _selectedRegion.subRegions[index];
          return _buildSubRegionListItem(subRegion, isDark);
        },
      ),
    );
  }

  Widget _buildSubRegionListItem(String subRegion, bool isDark) {
    return ListTile(
      dense: true,
      title: Text(
        subRegion,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      selected: _selectedSubRegion == subRegion,
      selectedColor: isDark ? const Color(0xFFFF9CAA) : const Color(0xFFFF7B8E),
      onTap: () {
        setState(() {
          _selectedSubRegion = subRegion;
        });
      },
    );
  }

  Widget _buildConfirmButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDark ? const Color(0xFFE0677A) : const Color(0xFFFF7B8E),
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
    );
  }
}
