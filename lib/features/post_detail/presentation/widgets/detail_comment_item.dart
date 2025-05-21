import 'package:flutter/material.dart';

class DetailCommentItem extends StatelessWidget {
  final String text;
  final String time;

  const DetailCommentItem({super.key, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.pink.shade200,
            child: Icon(Icons.person, size: 16, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("익명",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(text, style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
