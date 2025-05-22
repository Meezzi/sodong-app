import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/location/location_viewmodel.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  const ProfileEdit({super.key});

  @override
  ConsumerState<ProfileEdit> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEdit> {
  final TextEditingController _nicknameController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(locationProvider.notifier).getLocation();
    });
  }

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Color(0xFFFFE6E9),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFFFFE6E9),
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt,
                          color: Color(0xFFFF7B8E), size: 35)
                      : null,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '닉네임',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      location.region != null
                          ? '📍 ${location.region}'
                          : '위치 불러오는 중...',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(locationProvider.notifier).getLocation();
                    },
                    child: const Text('위치 다시 불러오기'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFE6E9),
                    foregroundColor: Colors.black,
                    minimumSize: Size(150, 50)),
                onPressed: () async {
                  final nickname = _nicknameController.text;
                  final region = location.region;
                  final profileFile = _profileImage;

                  if (nickname.isEmpty ||
                      profileFile == null ||
                      region == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('모든 정보를 입력해주세요')),
                    );
                    return;
                  }

                  try {
                    // 1. 이미지 Firebase Storage에 업로드
                    final storageRef = FirebaseStorage.instance.ref().child(
                        'profiles/${DateTime.now().millisecondsSinceEpoch}.jpg');
                    await storageRef.putFile(profileFile);
                    final imageUrl = await storageRef.getDownloadURL();

                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) throw Exception('로그인되지 않았습니다');

                    // 2. Firestore에 사용자 정보 저장
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .set({
                      'nickname': nickname,
                      'region': region,
                      'profileImageUrl': imageUrl,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    // 다음 페이지로 이동 또는 홈으로 이동
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('프로필이 성공적으로 생성되었습니다!')),
                    );
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    await Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('프로필 생성 중 오류가 발생했습니다')),
                    );
                  }
                },
                child: const Text(
                  '프로필 생성',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
