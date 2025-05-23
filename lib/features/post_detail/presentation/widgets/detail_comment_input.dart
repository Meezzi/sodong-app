import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/presentation/viewmodels/comment_view_model_provider.dart';
import 'package:tuple/tuple.dart';

class DetailCommentInput extends ConsumerStatefulWidget {
  const DetailCommentInput({
    super.key,
    required this.location,
    required this.category,
    required this.postId,
  });

  final String location;
  final String category;
  final String postId;

  @override
  ConsumerState<DetailCommentInput> createState() => _DetailCommentInputState();
}

class _DetailCommentInputState extends ConsumerState<DetailCommentInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendComment() async {
    if (_controller.text.trim().isEmpty) return;

    await ref
        .read(
          commentViewModelProvider(
            Tuple3(widget.location, widget.category, widget.postId),
          ).notifier,
        )
        .addComment(_controller.text.trim());

    _controller.clear();
  }

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
            onPressed: _sendComment,
          ),
        ],
      ),
    );
  }
}
