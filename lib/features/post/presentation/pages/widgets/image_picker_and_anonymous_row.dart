part of 'package:sodong_app/features/post/presentation/pages/create_post_page.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _ImagePickerButton(onPickImages: onPickImages),
          const Spacer(),
          _AnonymousCheckBox(
              isAnonymous: isAnonymous, toggleAnonymous: toggleAnonymous)
        ],
      ),
    );
  }
}

class _ImagePickerButton extends StatelessWidget {
  const _ImagePickerButton({
    required this.onPickImages,
  });

  final VoidCallback onPickImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: onPickImages,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: const [
              Icon(
                Icons.camera_alt_rounded,
                color: Color(0xFFFF7B8E),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '사진 추가',
                style: TextStyle(
                  color: Color(0xFFFF7B8E),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnonymousCheckBox extends StatelessWidget {
  const _AnonymousCheckBox({
    required this.isAnonymous,
    required this.toggleAnonymous,
  });

  final bool isAnonymous;
  final Function(bool?) toggleAnonymous;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFD5DE)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isAnonymous,
            onChanged: toggleAnonymous,
            checkColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFFFF7B8E),
              width: 2,
            ),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFFFF7B8E);
              }
              return Colors.white;
            }),
          ),
          const Text(
            '익명',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
