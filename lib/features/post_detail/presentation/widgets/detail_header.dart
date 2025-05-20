import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.pink.shade200,
          child: Icon(Icons.person, color: Colors.white),
        ),
        SizedBox(width: 10),
        Text("익명", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
