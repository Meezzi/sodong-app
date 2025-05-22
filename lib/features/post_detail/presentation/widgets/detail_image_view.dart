import 'package:flutter/material.dart';

class DetailImageView extends StatelessWidget {
  const DetailImageView({super.key, required this.imageUrl});
  final String? imageUrl;

  Widget get errorWidget => Container(
        height: 200,
        color: Colors.grey[300],
        child: Icon(Icons.broken_image, size: 50),
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl == null
          ? errorWidget
          : Image.network(imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => errorWidget),
    );
  }
}
