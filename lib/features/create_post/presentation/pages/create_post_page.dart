import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/auth/domain/entities/user.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/create_post_view_model.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/image_picker_view_model.dart';
import 'package:sodong_app/features/locations/presentation/viewmodel/location_view_model.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';
part 'widgets/top_app_bar_title.dart';
part 'widgets/current_location.dart';
part 'widgets/post_card.dart';
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
    final imagePickerViewModel =
        ref.read(imagePickerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE4E8),
        elevation: 0,
        title: _TopAppBarTitle(),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: createPostState.isLoading
                ? null
                : () => _handleCreatePost(context, ref),
            child: Text(
              '완료',
              style: TextStyle(
                color: const Color(0xFFFF7B8E),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: createPostState.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFF7B8E)),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            _LocationInfo(),
                            _PostCard(
                              createPostViewModel: createPostViewModel,
                              imagePickerState: imagePickerState,
                              createPostState: createPostState,
                              imagePickerViewModel: imagePickerViewModel,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
    final createPostViewModel = ref.read(createPostViewModelProvider.notifier);

    // ViewModel의 isFormValid 메서드를 사용하여 유효성 검사
    if (!createPostViewModel.isFormValid()) {
      _showEmptyFieldDialog(context);
      return;
    }

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

    try {
      // 로딩 상태는 submit 메서드 내부에서 처리됨
      final user = ref.read(appUserProvider.notifier).state;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인 정보가 없습니다. 다시 로그인해주세요.'),
            backgroundColor: Color(0xFFFF7B8E),
          ),
        );

        return;
      }

      final newPost = await createPostViewModel.submit(
        region,
        user.uid,
        user.nickname,
      );
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

  void _showEmptyFieldDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '필드 비어있음 알림',
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
                      // 경고 아이콘 애니메이션
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
                                Icons.warning_amber_rounded,
                                color: Color(0xFFFF7B8E),
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '작성 내용을 확인해주세요',
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
                        '제목과 내용을 모두 입력해주세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '사진은 선택사항입니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
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
                            // 이미지 상태 초기화
                            ref
                                .read(imagePickerViewModelProvider.notifier)
                                .clearAllImages();
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
