import 'package:flutter/material.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/widgets/agreement_check_tile.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage({super.key});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool agreeTerms = false;
  bool agreePrivacy = false;
  bool agreeLocation = false;

  bool get allAgreed => agreeTerms && agreePrivacy && agreeLocation;
  bool get canProceed => allAgreed;

  void updateAll(bool value) {
    setState(() {
      agreeTerms = value;
      agreePrivacy = value;
      agreeLocation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('약관동의')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              AgreementCheckTile(
                title: '전체 동의',
                value: allAgreed,
                onChanged: (_) => updateAll(!allAgreed),
                showTrailingIcon: false,
              ),
              const Divider(),
              AgreementCheckTile(
                title: '(필수) 소소한 동네 이용약관',
                value: agreeTerms,
                onChanged: (val) => setState(() => agreeTerms = val!),
                onTapTrailing: () => Navigator.pushNamed(context, '/terms'),
              ),
              AgreementCheckTile(
                title: '(필수) 개인정보 수집 및 이용 동의',
                value: agreePrivacy,
                onChanged: (val) => setState(() => agreePrivacy = val!),
                onTapTrailing: () =>
                    Navigator.pushNamed(context, '/privacy_policy'),
              ),
              AgreementCheckTile(
                title: '(필수) 위치 정보 수집 및 이용 동의',
                value: agreeLocation,
                onChanged: (val) => setState(() => agreeLocation = val!),
                onTapTrailing: () =>
                    Navigator.pushNamed(context, '/location_policy'),
              ),
              const Spacer(),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canProceed
                      ? () => Navigator.pushReplacementNamed(context, '/login')
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('동의하고 계속하기'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
