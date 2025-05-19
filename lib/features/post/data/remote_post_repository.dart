import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/result/create_post_exception.dart';
import 'package:sodong_app/core/result/result.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_repository.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

class RemotePostRepository implements PostRepository {
  RemotePostRepository({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<Result<Post>> savePost(
    String location,
    TownLifeCategory category,
    Post post,
  ) async {
    try {
      final colRef =
          firestore.collection('posts').doc(location).collection(category.id);

      final docRef = colRef.doc();
      final newId = docRef.id;

      final newPost = post.copyWith(
        postId: newId,
      );

      await docRef.set(newPost.toFirestore());

      return Result.ok(newPost);
    } catch (e) {
      return Result.error(UnknownFailure(e.toString()));
    }
  }
}
