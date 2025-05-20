import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/dtos/comment_dto.dart';
import 'package:sodong_app/features/post_detail/presentation/viewmodels/comment_view_model.dart';

class DetailCommentInput extends ConsumerStatefulWidget {
  final String postId;
  final String userId;

  const DetailCommentInput(
      {super.key, required this.postId, required this.userId});

  @override
  ConsumerState<DetailCommentInput> createState() => _DetailCommentInputState();
}

class _DetailCommentInputState extends ConsumerState<DetailCommentInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요',
                hintStyle: const TextStyle(fontSize: 14),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.pink),
            onPressed: () async {
              if (_controller.text.trim().isEmpty) return;

              final comment = Comment(
                id: '',
                postId: widget.postId,
                userId: widget.userId,
                content: _controller.text.trim(),
                createdAt: DateTime.now(),
              );

              await ref
                  .read(commentViewModelProvider(widget.postId).notifier)
                  .addComment(comment);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
