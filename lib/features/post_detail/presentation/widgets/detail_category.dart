import 'package:flutter/material.dart';

class DetailCategory extends StatelessWidget {
  const DetailCategory({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.category, color: Colors.grey, size: 18),
        const SizedBox(width: 4),
        Text(
          category,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
      ],
    );
  }
}
