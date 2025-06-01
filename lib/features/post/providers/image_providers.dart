import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/post/data/data_source/image_picker_data_source.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final _imagePickerDataSourceProvider = Provider<ImagePickerDataSource>((ref) {
  final imagePicker = ref.read(imagePickerProvider);
  return ImagePickerDataSource(imagePicker);
});
