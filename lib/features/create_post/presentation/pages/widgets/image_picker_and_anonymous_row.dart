part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _ImagePickerAndAnonymousRow extends StatelessWidget {
  const _ImagePickerAndAnonymousRow({
    required this.isAnonymous,
    required this.toggleAnonymous,
    required this.onPickImages,
  });

  final bool isAnonymous;
  final Function(bool?) toggleAnonymous;
  final VoidCallback onPickImages;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPickImages,
          icon: const Icon(Icons.camera_alt_outlined),
        ),
        const Spacer(),
        Row(
          children: [
            Checkbox(
              value: isAnonymous,
              onChanged: toggleAnonymous,
            ),
            const Text('익명'),
          ],
        )
      ],
    );
  }
}
