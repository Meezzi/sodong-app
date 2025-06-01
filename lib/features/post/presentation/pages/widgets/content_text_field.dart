part of 'package:sodong_app/features/post/presentation/pages/create_post_page.dart';

class _ContentTextField extends StatelessWidget {
  const _ContentTextField({
    required this.content,
    required this.contentError,
    required this.onChanged,
  });

  final String content;
  final String? contentError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasError = contentError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            onChanged: onChanged,
            minLines: 5,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: '이야기를 들려주세요.',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              contentError!,
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

