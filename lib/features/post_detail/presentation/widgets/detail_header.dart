import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
    required this.isAnonymous,
    this.nickname,
    this.profileImageUrl,
  });
  final bool isAnonymous;
  final String? nickname;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isAnonymous
            ? CircleAvatar(
                radius: 20,
                backgroundColor: Colors.pink.shade200,
                child: const Icon(Icons.person, size: 16, color: Colors.white),
              )
            : CircleAvatar(
                radius: 20,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(Icons.person, size: 16, color: Colors.grey)
                    : null,
              ),
        const SizedBox(width: 12),
        Text(
          isAnonymous ? '익명' : (nickname ?? '알 수 없음'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
