part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _TitleTextField extends ConsumerWidget {
  const _TitleTextField({
    required this.notifier,
  });

  final CreatePostViewModel notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPostState = ref.watch(createPostViewModelProvider);
    final hasError = createPostState.titleError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError ? Colors.red : const Color(0xFFFFE4E8),
              width: hasError ? 1.5 : 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: '제목을 입력하세요.',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              prefixIcon: Icon(
                Icons.edit_note_rounded,
                color: hasError ? Colors.red : const Color(0xFFFF7B8E),
                size: 24,
              ),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            onChanged: notifier.setTitle,
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              createPostState.titleError!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
