import 'package:flutter/material.dart';

class DetailImageView extends StatelessWidget {
  const DetailImageView({super.key, required this.imageUrls});
  final List<String>? imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls == null || imageUrls!.isEmpty) return const SizedBox();

    return Column(
      children: imageUrls!.map((url) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
