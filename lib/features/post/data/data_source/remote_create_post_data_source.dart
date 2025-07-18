import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:sodong_app/features/post/data/data_source/create_post_data_source.dart';
import 'package:sodong_app/features/post/data/dto/post_dto.dart';
import 'package:sodong_app/features/post/domain/entities/category.dart';

class RemoteCreatePostDataSource implements CreatePostDataSource {
  RemoteCreatePostDataSource(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<PostDto> createPostWithImages(
    String location,
    TownLifeCategory category,
    List<String> imagePaths,
    PostDto post,
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
      String postId, List<String> imagePaths) async {
    final uploadFutures = imagePaths.map((path) async {
      final file = File(path);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.hashCode}.jpg';
      final ref = _storage.ref().child('posts/$postId/$fileName');
      final compressed =
          await RemoteCreatePostDataSource._compressImageFile(file);
      final uploadTarget = compressed ?? file; // 압축 실패 시 원본 사용
      await ref.putFile(uploadTarget);
      return await ref.getDownloadURL();
    }).toList();

    return await Future.wait(uploadFutures);
  }

  static Future<File?> _compressImageFile(File file,
      {int minWidth = 1024, int quality = 80}) async {
    try {
      final fileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}_${file.hashCode}.jpg';
      final compressedFilePath = '${file.parent.path}/$fileName';
      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        compressedFilePath,
        minWidth: minWidth,
        quality: quality,
      );
      if (compressedXFile == null) {
        return null;
      }
      return File(compressedXFile.path);
    } catch (e) {
      return null;
    }
  }
}
