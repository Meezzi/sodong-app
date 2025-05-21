import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodong_app/features/location/location_viewmodel.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
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
                onPressed: () {
                  final nickname = _nicknameController.text;
                  final region = location.region ?? '';
                  final profileFile = _profileImage;

                  if (nickname.isEmpty ||
                      profileFile == null ||
                      region.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('모든 정보를 입력해주세요')),
                    );
                    return;
                  }

                  // TODO: Firestore 저장 및 Storage 업로드 로직 추가
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
