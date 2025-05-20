import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>> pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      return pickedFiles;
    } catch (e) {
      throw Exception('이미지 선택 오류: $e');
    }
  }
}

final imagePickerRepositoryProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService();
});
