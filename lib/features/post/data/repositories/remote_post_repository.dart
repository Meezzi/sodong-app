import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sodong_app/core/result/create_post_exception.dart';
import 'package:sodong_app/core/result/result.dart';
import 'package:sodong_app/features/post/data/data_source/post_data_source.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_repository.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

class RemotePostRepository implements PostRepository {
  RemotePostRepository(this._postDataSource);

  final PostDataSource _postDataSource;

  /// Post 저장
  /// DataSource 내부에서 이미지 업로드 처리
  @override
  Future<Result<Post>> createPostWithImages(
    String location,
    TownLifeCategory category,
    List<String> imagePaths,
    Post post,
  ) async {
    try {
      final createdPost = await _postDataSource.createPostWithImages(
          location, category, imagePaths, post);

      return Result.ok(createdPost);
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
}
