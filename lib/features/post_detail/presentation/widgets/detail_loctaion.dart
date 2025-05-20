import 'package:flutter/material.dart';

class DetailLocation extends StatelessWidget {
  final String location;

  const DetailLocation({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.grey, size: 18),
        SizedBox(width: 4),
        Text(
          location,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
      ],
    );
  }
}
