import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/presentation/viewmodels/profile_view_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({required this.userId, super.key});
  final String userId;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final nicknameController = TextEditingController();
  bool isEditMode = false;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).fetchUser(widget.userId);
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      if (!isEditMode) {
        final user = ref.read(profileViewModelProvider).value;
        if (user != null) {
          nicknameController.text = user.nickname;
          selectedImage = null;
        }
      }
    });
  }

  void _saveProfile() async {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final currentUser = ref.read(profileViewModelProvider).value;

    if (currentUser == null) return;

    setState(() {});

    String imageUrl = currentUser.imageUrl;

    if (selectedImage != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child(
            'profiles/${widget.userId}_${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(selectedImage!);

        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미지 업로드 실패: $e')),
          );
        }
        return;
      }
    }

    final updatedProfile = Profile(
      nickname: nicknameController.text,
      imageUrl: imageUrl,
      location: currentUser.location,
    );

    try {
      await viewModel.updateUser(widget.userId, updatedProfile);

      setState(() {
        isEditMode = false;
        selectedImage = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필이 업데이트되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 업데이트 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (user) {
          if (!isEditMode && nicknameController.text.isEmpty) {
            nicknameController.text = user.nickname;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                GestureDetector(
                  onTap: isEditMode ? _pickImage : null,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!) as ImageProvider
                            : (user.imageUrl.isNotEmpty
                                ? NetworkImage(user.imageUrl)
                                : null),
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        child: (selectedImage == null && user.imageUrl.isEmpty)
                            ? const Icon(Icons.person,
                                size: 60, color: Colors.white)
                            : null,
                      ),
                      if (isEditMode)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF7B8E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: nicknameController,
                        style: const TextStyle(
                          color: Color(0xFFFF7B8E),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: isEditMode
                              ? const UnderlineInputBorder()
                              : InputBorder.none,
                          hintText: isEditMode ? '닉네임을 입력하세요' : null,
                        ),
                        textAlign: TextAlign.center,
                        readOnly: !isEditMode,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                if (isEditMode)
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7B8E),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '저장하기',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
