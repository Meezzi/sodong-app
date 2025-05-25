import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  final bool isAnonymous;
  final String? nickname;
  final String? profileImageUrl;

  const DetailHeader({
    super.key,
    required this.isAnonymous,
    this.nickname,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            isAnonymous
                ? 'https://example.com/default_profile.png'
                : (profileImageUrl ??
                    'https://example.com/default_profile.png'),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          isAnonymous ? '익명' : (nickname ?? '알 수 없음'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }
}
