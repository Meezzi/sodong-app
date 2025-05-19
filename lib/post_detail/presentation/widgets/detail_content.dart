import 'package:flutter/material.dart';

class DetailContent extends StatelessWidget {
  final String content;

  const DetailContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
