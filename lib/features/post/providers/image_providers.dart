import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/post/data/data_source/image_picker_data_source.dart';
import 'package:sodong_app/features/post/domain/use_case/pick_image_usecase.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final _imagePickerDataSourceProvider = Provider<ImagePickerDataSource>((ref) {
  final imagePicker = ref.read(imagePickerProvider);
  return ImagePickerDataSource(imagePicker);
});

final _imagePickerUsecaseProvider = Provider((ref) {
  final repository = ref.read(_imagePickerDataSourceProvider);
  return ImagePickerUsecase(repository);
});
