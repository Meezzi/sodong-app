import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/post/data/data_source/image_picker_data_source.dart';
import 'package:sodong_app/features/post/domain/use_case/pick_image_usecase.dart';
import 'package:sodong_app/features/post/presentation/view_models/image_picker_view_model.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final _imagePickerDataSourceProvider = Provider<ImagePickerDataSource>((ref) {
  final imagePicker = ref.read(imagePickerProvider);
  return ImagePickerDataSource(imagePicker);
});

final imagePickerUsecaseProvider = Provider((ref) {
  final repository = ref.read(_imagePickerDataSourceProvider);
  return ImagePickerUsecase(repository);
});

final imagePickerViewModelProvider =
    AutoDisposeNotifierProvider<ImagePickerViewModel, ImagePickerState>(() {
  return ImagePickerViewModel();
});
