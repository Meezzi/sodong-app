import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/create_post_view_model.dart';
import 'package:sodong_app/features/create_post/presentation/view_models/image_picker_view_model.dart';
import 'package:sodong_app/features/location/location_viewmodel.dart';
import 'package:sodong_app/features/post_detail/presentation/pages/post_detail_page.dart';
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
                : () => _handleCreatePost(context, ref),
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
                        toggleAnonymous: (_) =>
                            createPostViewModel.toggleAnonymous(),
                        onPickImages: () => ref
                            .read(imagePickerViewModelProvider.notifier)
                            .pickImages(),
                      ),
                    ],
                  )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(locationProvider.notifier).getLocation();
      },
    );
  }

  Future<void> _handleCreatePost(BuildContext context, WidgetRef ref) async {
    final region = ref.read(locationProvider).region;

    if (region == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 정보를 불러오고 있습니다. 잠시만 기다려주세요.')),
      );
      return;
    }

    final createPostViewModel = ref.read(createPostViewModelProvider.notifier);

    try {
      final newPost = await createPostViewModel.submit(region);
      if (!context.mounted) return;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PostDetailPage(
            location: region,
            category: newPost.category.id,
            postId: newPost.postId,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('작성 실패: ${e.toString()}')),
      );
    }
  }
}
