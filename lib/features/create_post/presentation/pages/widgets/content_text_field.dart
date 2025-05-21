part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _ContentTextField extends StatelessWidget {
  const _ContentTextField({
    required this.notifier,
  });
  
  final CreatePostViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: const InputDecoration(
          hintText: '이야기를 들려주세요.',
          border: InputBorder.none,
        ),
        maxLines: null,
        expands: true,
        onChanged: notifier.setContent,
      ),
    );
  }
}