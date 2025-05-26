part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _TitleTextField extends StatelessWidget {
  const _TitleTextField({
    required this.title,
    required this.titleError,
    required this.onChanged,
  });

  final String title;
  final String? titleError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasError = titleError != null;

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
            onChanged: onChanged,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: '제목을 입력하세요.',
              border: InputBorder.none,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              titleError!,
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
