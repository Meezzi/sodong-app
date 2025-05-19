import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/result/create_post_exception.dart';
import 'package:sodong_app/core/result/result.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_repository.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

class RemotePostRepository implements PostRepository {
  RemotePostRepository({required this.firestore, required this.storage});

  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  @override
  Future<Result<Post>> createPostWithImages(
    String location,
    TownLifeCategory category,
    List<String> imagePaths,
    Post post,
  ) async {
    try {
      final colRef =
          firestore.collection('posts').doc(location).collection(category.id);

      final docRef = colRef.doc();
      final postId = docRef.id;
      final uploadedUrls = await _uploadImages(postId, imagePaths);

      final newPost = post.copyWith(
        postId: postId,
        imageUrl: uploadedUrls,
      );

      await docRef.set(newPost.toFirestore());

      return Result.ok(newPost);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return Result.error(const PermissionFailure());
      } else if (e.code == 'unavailable') {
        return Result.error(const NetworkFailure());
      } else {
        return Result.error(UnknownFailure(e.message ?? '알 수 없는 Firebase 오류'));
      }
    } catch (e) {
      return Result.error(UnknownFailure(e.toString()));
    }
  }

  Future<List<String>> _uploadImages(
    String postId,
    List<String> imagePaths,
  ) async {
    final uploadedUrls = <String>[];

    for (final path in imagePaths) {
      final file = File(path);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.hashCode}.jpg';

      final ref = storage.ref().child('posts/$postId/$fileName');
      await ref.putFile(file);

      final url = await ref.getDownloadURL();
      uploadedUrls.add(url);
    }

    return uploadedUrls;
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  return RemotePostRepository(firestore: firestore, storage: storage);
});
