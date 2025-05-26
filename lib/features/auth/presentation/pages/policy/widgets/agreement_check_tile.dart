import 'package:flutter/material.dart';

class AgreementCheckTile extends StatelessWidget {
  const AgreementCheckTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.showTrailingIcon = true,
    this.onTapTrailing,
  });

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool showTrailingIcon;
  final VoidCallback? onTapTrailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              _buildCircleCheckbox(value),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (showTrailingIcon)
                InkWell(
                  onTap: onTapTrailing,
                  child: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleCheckbox(bool value) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: value ? Color(0xFFFF7B8E) : Colors.grey,
          width: 2,
        ),
        color: value ? Color(0xFFFF7B8E) : Colors.transparent,
      ),
      child: value
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}
