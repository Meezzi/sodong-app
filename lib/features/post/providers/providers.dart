import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/data/data_source/post_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/remote_post_data_source.dart';

final _postDatasourceProvider = Provider<PostDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  return RemotePostDataSource(firestore, storage);
});
