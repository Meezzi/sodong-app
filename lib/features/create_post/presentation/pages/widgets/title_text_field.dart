part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _TitleTextField extends StatelessWidget {
  const _TitleTextField({
    required this.notifier,
  });

  final CreatePostViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: '제목을 입력하세요.',
        border: InputBorder.none,
      ),
      onChanged: notifier.setTitle,
    );
  }
}

