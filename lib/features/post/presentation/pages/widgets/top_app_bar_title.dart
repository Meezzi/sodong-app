part of 'package:sodong_app/features/post/presentation/pages/create_post_page.dart';

class _TopAppBarTitle extends StatelessWidget {
  const _TopAppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/login.png',
          height: 40,
          width: 40,
        ),
        const Text(
          '소소한 이야기 작성',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        Image.asset(
          'assets/login.png',
          height: 40,
          width: 40,
        ),
      ],
    );
  }
}
