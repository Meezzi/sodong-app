import 'package:image_picker/image_picker.dart';

class ImagePickerDataSource {
  ImagePickerDataSource(this._picker);

  final ImagePicker _picker;

  Future<List<XFile>> pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      return pickedFiles;
    } catch (e) {
      throw Exception('이미지 선택 오류: $e');
    }
  }
}
