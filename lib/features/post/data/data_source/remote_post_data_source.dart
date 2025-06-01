import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sodong_app/features/post/data/data_source/create_post_data_source.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

class RemotePostDataSource implements CreatePostDataSource {
  RemotePostDataSource(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<Post> createPostWithImages(
    String location,
    TownLifeCategory category,
    List<String> imagePaths,
    Post post,
  ) async {
    final colRef =
        _firestore.collection('posts').doc(location).collection(category.id);

    final docRef = colRef.doc();
    final postId = docRef.id;
    final uploadedUrls = await _uploadImages(postId, imagePaths);

    final newPost = post.copyWith(
      postId: postId,
      imageUrl: uploadedUrls,
    );

    await docRef.set(newPost.toFirestore());

    return newPost;
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

      final ref = _storage.ref().child('posts/$postId/$fileName');
      await ref.putFile(file);

      final url = await ref.getDownloadURL();
      uploadedUrls.add(url);
    }

    return uploadedUrls;
  }
}
