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

class ImagePickerViewModel extends AutoDisposeNotifier<ImagePickerState> {
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

  void removeImage(int index) {
    if (state.imageFiles == null ||
        index < 0 ||
        index >= state.imageFiles!.length) {
      return;
    }

    final updatedImages = List<XFile>.from(state.imageFiles!);
    final removedImage = updatedImages.removeAt(index);

    // 이미지 상태 업데이트
    state = state.copyWith(imageFiles: updatedImages);

    // CreatePostViewModel에서도 해당 이미지 제거
    try {
      final createPostNotifier = ref.read(createPostViewModelProvider.notifier);
      createPostNotifier.removeImage(removedImage.path);
    } catch (e) {
      state = state.copyWith(
        error: '이미지 제거 실패: ${removedImage.path}',
      );
    }
  }

  // 모든 이미지 초기화 메서드 추가
  void clearAllImages() {
    if (state.imageFiles == null || state.imageFiles!.isEmpty) {
      return;
    }

    // CreatePostViewModel의 이미지도 함께 초기화
    try {
      final createPostNotifier = ref.read(createPostViewModelProvider.notifier);
      for (var file in state.imageFiles!) {
        createPostNotifier.removeImage(file.path);
      }
    } catch (e) {
      state = state.copyWith(
        error: '이미지 초기화 실패',
      );
    }

    // 이미지 상태 초기화
    state = state.copyWith(imageFiles: []);
  }
}

final imagePickerViewModelProvider =
    AutoDisposeNotifierProvider<ImagePickerViewModel, ImagePickerState>(() {
  return ImagePickerViewModel();
});
