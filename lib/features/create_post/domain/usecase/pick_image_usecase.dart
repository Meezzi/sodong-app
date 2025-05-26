import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/create_post/data/repository/image_picker_repository.dart';

class ImagePickerUsecase {
  ImagePickerUsecase(this._repository);

  final ImagePickerService _repository;

  Future<List<XFile>> execute() async {
    return await _repository.pickImages();
  }
}

final pickImagesUsecaseProvider = Provider((ref) {
  final imagePickerRepository = ref.read(imagePickerRepositoryProvider);
  return ImagePickerUsecase(imagePickerRepository);
});
