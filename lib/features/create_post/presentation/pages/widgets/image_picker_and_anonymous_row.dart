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
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          _buildImagePickerButton(),
          const Spacer(),
          _buildAnonymousCheckbox(),
        ],
      ),
    );
  }

  Widget _buildImagePickerButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7B8E).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
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
      ),
    );
  }

  Widget _buildAnonymousCheckbox() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFFD5DE),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFFFF7B8E);
                  }
                  return Colors.grey;
                }),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            child: Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: isAnonymous,
                onChanged: toggleAnonymous,
              ),
            ),
          ),
          const Text(
            '익명으로 작성',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
