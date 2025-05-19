import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_comment_input.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_comment_item.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_content.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_header.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_image_view.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_loctaion.dart';
import 'package:sodong_app/post_detail/presentation/widgets/detail_title.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  Future<DocumentSnapshot> fetchPost() async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFE4E8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '게시글 상세',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('게시글을 찾을 수 없습니다.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    DetailImageView(imageUrl: data['imageUrl'] ?? ''),
                    SizedBox(height: 16),
                    DetailHeader(),
                    SizedBox(height: 16),
                    DetailTitle(title: data['title'] ?? '제목 없음'),
                    SizedBox(height: 16),
                    DetailContent(content: data['content'] ?? '내용 없음'),
                    SizedBox(height: 16),
                    DetailLocation(location: data['location'] ?? '위치 없음'),
                    SizedBox(height: 24),
                    Text("댓글",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    CommentItem(text: '카페 추천해요!', time: '20분 전'),
                    CommentItem(text: '진짜 맛있어요~', time: '1시간 전'),
                  ],
                ),
              ),
              CommentInput(),
            ],
          );
        },
      ),
    );
  }
}
