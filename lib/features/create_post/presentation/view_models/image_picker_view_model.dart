import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/create_post/domain/usecase/pick_image_usecase.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/create_post_view_model.dart';

class ImagePickerState {
  ImagePickerState({
    this.imageFiles,
    this.isLoading = false,
    this.error,
  });

  final List<XFile>? imageFiles;
  final bool isLoading;
  final String? error;

  ImagePickerState copyWith({
    List<XFile>? imageFiles,
    bool? isLoading,
    String? error,
  }) {
    return ImagePickerState(
      imageFiles: imageFiles ?? this.imageFiles,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ImagePickerViewModel extends Notifier<ImagePickerState> {
  @override
  ImagePickerState build() {
    return ImagePickerState();
  }

  Future<void> pickImages() async {
    try {
      state = state.copyWith(isLoading: true);
      final imagePickerUsecase = ref.read(pickImagesUsecaseProvider);
      final selectedImages = await imagePickerUsecase.execute();
      state = state.copyWith(
        imageFiles: selectedImages,
        isLoading: false,
      );

      final createPostNotifier = ref.read(createPostViewModelProvider.notifier);
      for (var file in selectedImages) {
        try {
          createPostNotifier.addImage(file.path);
        } catch (e) {
          state = state.copyWith(
            error: '이미지 추가 실패: ${file.path}',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '$e',
      );
    }
  }
}

final imagePickerViewModelProvider =
    NotifierProvider<ImagePickerViewModel, ImagePickerState>(() {
  return ImagePickerViewModel();
});
