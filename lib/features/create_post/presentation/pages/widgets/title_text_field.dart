part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _TitleTextField extends StatelessWidget {
  const _TitleTextField({
    required this.notifier,
  });

  final CreatePostViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFE4E8),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        decoration: const InputDecoration(
          hintText: '제목을 입력하세요.',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Icon(
            Icons.edit_note_rounded,
            color: Color(0xFFFF7B8E),
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
    );
  }
}
