import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/post/data/data_source/image_picker_data_source.dart';

class ImagePickerUsecase {
  ImagePickerUsecase(this._repository);

  final ImagePickerDataSource _repository;

  Future<List<XFile>> execute() async {
    return await _repository.pickImages();
  }
}
