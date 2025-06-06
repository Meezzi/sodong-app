import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/auth/domain/entities/user.dart';
import 'package:sodong_app/features/post/presentation/pages/create_post/create_post_page.dart';
import 'package:sodong_app/features/post/providers/report_providers.dart';
import 'package:sodong_app/features/post/providers/selected_menu_provider.dart';

class PostDetailActions extends ConsumerWidget {
  const PostDetailActions({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      tooltip: '더보기',
      onSelected: (value) {
        ref.read(selectedOptionProvider.notifier).state = value;
        switch (value) {
          case 'report':
            showDialog(
              context: context,
              builder: (context) => CustomDialog(
                icon: Icons.report_outlined,
                title: '신고하기',
                message: '이 게시글을 신고하시겠습니까?',
                buttonText: '신고',
                onPressed: () async {
                  final uid = ref.read(appUserProvider)!.uid;
                  try {
                    await ref
                        .read(reportViewModelProvider)
                        .reportPost(uid, postId);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('신고가 접수되었습니다.')),
                    );

                    Navigator.pop(context); // 다이얼로그 닫기
                    Navigator.pop(context); // 상세 페이지 닫기
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
              ),
            );
            break;
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.report_outlined, size: 20),
              SizedBox(width: 12),
              Text('신고하기'),
            ],
          ),
        ),
      ],
    );
  }
}
