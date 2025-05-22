import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/create_post_view_model.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/image_picker_view_model.dart';
import 'package:sodong_app/features/location/location_viewmodel.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';
part 'widgets/category_dropdown.dart';
part 'widgets/image_preview.dart';
part 'widgets/title_text_field.dart';
part 'widgets/content_text_field.dart';
part 'widgets/image_picker_and_anonymous_row.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostViewModelProvider);
    final createPostViewModel = ref.read(createPostViewModelProvider.notifier);
    final imagePickerState = ref.watch(imagePickerViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE4E8),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/login.png',
              height: 40,
              width: 40,
            ),
            const Text(
              '소소한 이야기 작성',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            Image.asset(
              'assets/login.png',
              height: 40,
              width: 40,
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: createPostState.isLoading
                  ? null
                  : () => _handleCreatePost(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7B8E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: createPostState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7B8E)),
              ))
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x20000000),
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            _buildLocationInfo(),
                            _buildPostCard(
                              createPostViewModel,
                              imagePickerState,
                              createPostState,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    final locationState = ref.watch(locationProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on,
              size: 16,
              color: Color(0xFFFF7B8E),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '현재 위치',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  locationState.region ?? '위치 정보 가져오는 중...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(
    CreatePostViewModel createPostViewModel,
    ImagePickerState imagePickerState,
    CreatePostState createPostState,
  ) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: const Color(0xFFFFD5DE),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '카테고리 선택',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF7B8E),
              ),
            ),
            const SizedBox(height: 8),
            _CategoryDropdown(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                color: Color(0xFFFFD5DE),
                thickness: 1,
              ),
            ),
            _TitleTextField(notifier: createPostViewModel),
            const Divider(
              height: 24,
              color: Color(0xFFFFE4E8),
            ),
            _ContentTextField(notifier: createPostViewModel),
            if (imagePickerState.imageFiles != null &&
                imagePickerState.imageFiles!.isNotEmpty)
              ImagePreview(imageFiles: imagePickerState.imageFiles!),
            _ImagePickerAndAnonymousRow(
              isAnonymous: createPostState.isAnonymous,
              toggleAnonymous: (_) => createPostViewModel.toggleAnonymous(),
              onPickImages: () =>
                  ref.read(imagePickerViewModelProvider.notifier).pickImages(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(locationProvider.notifier).getLocation();
      },
    );
  }

  Future<void> _handleCreatePost(BuildContext context, WidgetRef ref) async {
    final region = ref.read(locationProvider).region;

    if (region == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 정보를 불러오고 있습니다. 잠시만 기다려주세요.'),
          backgroundColor: Color(0xFFFF7B8E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
      return;
    }

    final createPostViewModel = ref.read(createPostViewModelProvider.notifier);

    try {
      // 로딩 상태는 submit 메서드 내부에서 처리됨
      final newPost = await createPostViewModel.submit(region);
      if (!context.mounted) return;

      // 데이터 새로고침을 위해 townLifeViewModel 접근
      final townLifeViewModel = ref.read(townLifeStateProvider.notifier);
      await townLifeViewModel.refreshAllCategoryData();

      // 성공 다이얼로그 표시
      _showSuccessDialog(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('작성 실패: ${e.toString()}'),
          backgroundColor: const Color(0xFFFF7B8E),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '성공 다이얼로그',
      pageBuilder: (_, __, ___) => Container(), // 사용하지 않음
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutBack,
        );

        return ScaleTransition(
          scale: curvedAnimation,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE4E8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // 성공 아이콘 애니메이션
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(
                                        255, 123, 142, 0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_circle_outline_rounded,
                                color: Color(0xFFFF7B8E),
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '게시물 작성 성공!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7B8E),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        '작성하신 게시물이 성공적으로 등록되었습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                            Navigator.of(context).pop(); // 작성 페이지에서 나가기
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7B8E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
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
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
