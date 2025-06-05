import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/location/location_viewmodel.dart';
import 'package:sodong_app/features/post/domain/entities/region.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/region_view_model.dart';

class RegionSelector extends ConsumerWidget {
  const RegionSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedRegion = ref.watch(selectedRegionProvider);
    var selectedSubRegion = ref.watch(selectedSubRegionProvider);

    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRegionDisplay(context, ref, selectedRegion, selectedSubRegion),
          Row(
            children: [
              _buildCurrentLocationButton(context, ref),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegionDisplay(BuildContext context, WidgetRef ref,
      Region selectedRegion, String selectedSubRegion) {
    return InkWell(
      onTap: () => _showRegionSelectionDialog(context, ref),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 16, color: Color(0xFFFF7B8E)),
          const SizedBox(width: 4),
          Text(
            '${selectedRegion.name} $selectedSubRegion',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationButton(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        // 로딩 다이얼로그 표시
        _showLocationLoadingDialog(context);

        // 위치 정보 가져오기
        final locationViewModel = ref.read(locationProvider.notifier);
        final success = await locationViewModel.getLocation();

        // 다이얼로그 닫기 (로딩 다이얼로그가 아직 표시되어 있다면)
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        // 위치 정보 적용
        if (success) {
          final location = ref.read(locationProvider);
          // userRegionProvider 함수 호출 - Future를 반환하므로 await 필요
          final setRegion = ref.read(userRegionProvider);
          await setRegion(location.region!);

          if (context.mounted) {
            _showLocationSuccessDialog(context, location.region!);
          }
        } else {
          if (context.mounted) {
            _showLocationErrorDialog(context);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Icon(Icons.my_location, size: 14, color: Color(0xFFFF7B8E)),
            SizedBox(width: 2),
            Text('현재 위치', style: TextStyle(fontSize: 12)),
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

  // 위치 로딩 다이얼로그 표시
  void _showLocationLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 로딩 애니메이션
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 90 * value,
                              height: 90 * value,
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFF7B8E)),
                                strokeWidth: 6,
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.location_searching,
                              size: 40 * value,
                              color: const Color(0xFFFF7B8E),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  '현재 위치 확인 중',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7B8E),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '위치 정보를 불러오고 있습니다.\n잠시만 기다려주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 위치 정보 가져오기 성공 다이얼로그
  void _showLocationSuccessDialog(BuildContext context, String region) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 성공 애니메이션
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 123, 142, 0.1 * value),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 70 * value,
                          color: const Color(0xFFFF7B8E),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  '위치 설정 완료',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7B8E),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '현재 위치가 "$region"(으)로\n설정되었습니다.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7B8E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 위치 정보 가져오기 실패 다이얼로그
  void _showLocationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 실패 애니메이션
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 123, 142, 0.1 * value),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.location_off,
                          size: 70 * value,
                          color: const Color(0xFFFF7B8E),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  '위치 정보 오류',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7B8E),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '현재 위치를 가져올 수 없습니다.\n위치 권한을 확인하거나 네트워크 연결 상태를 확인해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7B8E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    return AlertDialog(
      title: const Text('지역 선택'),
      content: _buildDialogContent(),
      actions: [
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildDialogContent() {
    return SizedBox(
      width: double.maxFinite,
      height: 500,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRegionList(),
          const VerticalDivider(),
          _buildSubRegionList(),
        ],
      ),
    );
  }

  Widget _buildRegionList() {
    return Expanded(
      flex: 2,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.regions.length,
        itemBuilder: (context, index) {
          var region = widget.regions[index];
          return _buildRegionListItem(region);
        },
      ),
    );
  }

  Widget _buildRegionListItem(Region region) {
    return ListTile(
      dense: true,
      title: Text(
        region.name,
        style: const TextStyle(
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
  }

  Widget _buildSubRegionList() {
    return Expanded(
      flex: 3,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _selectedRegion.subRegions.length,
        itemBuilder: (context, index) {
          var subRegion = _selectedRegion.subRegions[index];
          return _buildSubRegionListItem(subRegion);
        },
      ),
    );
  }

  Widget _buildSubRegionListItem(String subRegion) {
    return ListTile(
      dense: true,
      title: Text(
        subRegion,
        style: const TextStyle(
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
  }

  Widget _buildConfirmButton() {
    return SizedBox(
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
    );
  }
}
