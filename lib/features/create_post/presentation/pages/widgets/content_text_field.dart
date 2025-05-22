part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _ContentTextField extends ConsumerWidget {
  const _ContentTextField({
    required this.notifier,
  });

  final CreatePostViewModel notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPostState = ref.watch(createPostViewModelProvider);
    final hasError = createPostState.contentError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasError ? Colors.red : const Color(0xFFFFE4E8),
              width: hasError ? 1.5 : 1.0,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: '이야기를 들려주세요.',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              enabledBorder: hasError
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.transparent),
                    )
                  : null,
              focusedBorder: hasError
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.transparent),
                    )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            onChanged: notifier.setContent,
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              createPostState.contentError!,
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
