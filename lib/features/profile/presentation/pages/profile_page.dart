import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/profile/presentation/viewmodels/profile_view_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({required this.userId, super.key});
  final String userId;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(profileViewModelProvider.notifier).fetchUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (user) {
          nicknameController.text = user.nickname;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Center(
                  child: CircleAvatar(
                    backgroundImage: user.imageUrl.isNotEmpty
                        ? NetworkImage(user.imageUrl)
                        : null,
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: user.imageUrl.isEmpty
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.center,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 3),
              ],
            ),
          );
        },
      ),
    );
  }
}
