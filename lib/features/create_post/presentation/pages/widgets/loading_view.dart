part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7B8E)),
      ),
    );
  }
}
