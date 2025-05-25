import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/auth/domain/entities/user.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/create_post_view_model.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/image_picker_view_model.dart';
import 'package:sodong_app/features/locations/presentation/viewmodel/location_view_model.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
part 'widgets/top_app_bar_title.dart';
part 'widgets/current_location.dart';
part 'widgets/post_card.dart';
part 'widgets/category_dropdown.dart';
part 'widgets/image_preview.dart';
part 'widgets/title_text_field.dart';
part 'widgets/content_text_field.dart';
part 'widgets/image_picker_and_anonymous_row.dart';
part 'widgets/custom_dialog.dart';
part 'widgets/loading_view.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  static const Color _primaryColor = Color(0xFFFF7B8E);
  static const Duration _animationDuration = Duration(milliseconds: 400);

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
                : () => _handleCreatePost(context),
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
              ? LoadingView()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Expanded(
                    child: ListView(
                      children: [
                        _LocationInfo(),
                        _PostCard(
                          createPostState: createPostState,
                          createPostViewModel: createPostViewModel,
                          imagePickerState: imagePickerState,
                          imagePickerViewModel: imagePickerViewModel,
                        ),
                      ],
                    ),
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
      (_) {
        ref.read(locationProvider.notifier).getLocation();
      },
    );
  }

  Future<void> _handleCreatePost(BuildContext context) async {
    try {
      final region = ref.read(locationProvider).region;
      final createPostViewModel =
          ref.read(createPostViewModelProvider.notifier);

      // 폼 유효성 검사
      if (!createPostViewModel.isFormValid()) {
        _showValidationDialog();
        return;
      }

      if (region == null) {
        _showSnackBar('위치 정보를 불러오고 있습니다. 잠시만 기다려주세요.');
        return;
      }

      // 사용자 정보 확인
      final user = ref.read(appUserProvider.notifier).state;
      if (user == null) {
        _showSnackBar('로그인 정보가 없습니다. 다시 로그인해주세요.');
        return;
      }

      // 게시물 생성
      await createPostViewModel.submit(region, user.uid, user.nickname);

      if (!context.mounted) return;

      // 성공 다이얼로그 표시
      _showSuccessDialog();
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar('작성 실패: $e');
    }
  }

  void _showValidationDialog() {
    _showCustomDialog(
      icon: Icons.warning_amber_rounded,
      title: '작성 내용을 확인해주세요',
      message: '제목과 내용을 모두 입력해주세요!',
      subtitle: '사진은 선택사항입니다.',
      buttonText: '확인',
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  void _showSuccessDialog() {
    _showCustomDialog(
      icon: Icons.check_circle_outline_rounded,
      title: '게시물 작성 성공!',
      message: '작성하신 게시물이 성공적으로 등록되었습니다.',
      buttonText: '확인',
      onPressed: () {
        ref.read(imagePickerViewModelProvider.notifier).clearAllImages();
        Navigator.of(context).pop(); // 다이얼로그 닫기
        Navigator.of(context).pop(); // 작성 페이지에서 나가기
      },
    );
  }

  void _showCustomDialog({
    required IconData icon,
    required String title,
    required String message,
    String? subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      transitionDuration: _animationDuration,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: _CustomDialog(
            icon: icon,
            title: title,
            message: message,
            subtitle: subtitle,
            buttonText: buttonText,
            onPressed: onPressed,
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

