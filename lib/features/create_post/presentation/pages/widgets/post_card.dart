part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _PostCard extends ConsumerWidget {
  const _PostCard({
    required this.createPostState,
    required this.createPostViewModel,
    required this.imagePickerState,
    required this.imagePickerViewModel,
  });

  final CreatePostState createPostState;
  final CreatePostViewModel createPostViewModel;
  final ImagePickerState imagePickerState;
  final ImagePickerViewModel imagePickerViewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
          SizedBox(height: 20),
          _TitleTextField(notifier: createPostViewModel),
          SizedBox(height: 20),
          _ContentTextField(notifier: createPostViewModel),
          if (imagePickerState.imageFiles != null &&
              imagePickerState.imageFiles!.isNotEmpty)
            ImagePreview(imageFiles: imagePickerState.imageFiles!),
          _ImagePickerAndAnonymousRow(
            isAnonymous: createPostState.isAnonymous,
            toggleAnonymous: (_) => createPostViewModel.toggleAnonymous(),
            onPickImages: () => imagePickerViewModel,
          ),
        ],
      ),
    );
  }
}
