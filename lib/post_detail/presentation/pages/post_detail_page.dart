import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/post_detail/data/providers/chat_detail_providers.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_comment_input.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_comment_item.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_content.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_header.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_image_view.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_loctaion.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_title.dart';

class PostDetailPage extends ConsumerWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postStreamProvider(postId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFE4E8),
        elevation: 0,
        centerTitle: true,
        title: Text('게시글 상세',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: postAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('에러: ${e.toString()}')),
        data: (post) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    DetailImageView(imageUrl: post.imageUrl),
                    SizedBox(height: 16),
                    DetailHeader(),
                    SizedBox(height: 16),
                    DetailTitle(title: post.title),
                    SizedBox(height: 16),
                    DetailContent(content: post.content),
                    SizedBox(height: 16),
                    DetailLocation(location: post.location),
                    SizedBox(height: 24),
                    Text("댓글",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    DetailCommentItem(text: '카페 추천해요!', time: '20분 전'),
                    DetailCommentItem(text: '진짜 맛있어요~', time: '1시간 전'),
                  ],
                ),
              ),
              DetailCommentInput(),
            ],
          );
        },
      ),
    );
  }
}
