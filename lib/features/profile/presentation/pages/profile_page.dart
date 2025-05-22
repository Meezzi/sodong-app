import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(profileNotifierProvider.notifier).fetchUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: userState.when(
        data: (user) {
          nicknameController.text = user.nickname;
          imageUrlController.text = user.imageUrl;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 60,
                  ),
                ),
                const SizedBox(height: 30),
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFFFF7B8E)),
                      onPressed: () async {
                        final updated = Profile(
                          nickname: nicknameController.text,
                          imageUrl: imageUrlController.text,
                          location: user.location,
                        );
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .updateUser(widget.userId, updated);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('프로필이 수정완료.')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
      ),
    );
  }
}
