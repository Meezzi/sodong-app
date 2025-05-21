import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/create_post_view_model.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/image_picker_view_model.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
part 'widgets/category_dropdown.dart';
part 'widgets/image_preview.dart';
part 'widgets/title_text_field.dart';
part 'widgets/content_text_field.dart';
part 'widgets/image_picker_and_anonymous_row.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostViewModelProvider);
    final createPostViewModel = ref.read(createPostViewModelProvider.notifier);
    final imagePickerState = ref.watch(imagePickerViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('글 쓰기'),
        actions: [
          TextButton(
            onPressed: createPostState.isLoading
                ? null
                : () async {
                    await createPostViewModel.submit('seoul_gangnam');
                    // TODO : 작성한 게시물 상세 화면으로 이동
                  },
            child: const Text('완료'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: createPostState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategoryDropdown(),
                    _TitleTextField(notifier: createPostViewModel),
                    _ContentTextField(notifier: createPostViewModel),
                    if (imagePickerState.imageFiles != null &&
                        imagePickerState.imageFiles!.isNotEmpty)
                      ImagePreview(imageFiles: imagePickerState.imageFiles!),
                    _ImagePickerAndAnonymousRow(
                      isAnonymous: createPostState.isAnonymous,
                      toggleAnonymous: (_) => createPostViewModel.toggleAnonymous(),
                      onPickImages: () => ref
                          .read(imagePickerViewModelProvider.notifier)
                          .pickImages(),
                    ),
                  ],
                )
        ),
      ),
    );
  }
}
