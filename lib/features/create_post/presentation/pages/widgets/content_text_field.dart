part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _ContentTextField extends StatelessWidget {
  const _ContentTextField({
    required this.notifier,
  });

  final CreatePostViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFE4E8),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: const InputDecoration(
          hintText: '이야기를 들려주세요.',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
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
    );
  }
}
