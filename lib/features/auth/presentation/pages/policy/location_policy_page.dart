import 'package:flutter/material.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/widgets/common_widgets.dart';

class LocationPolicyPage extends StatelessWidget {
  const LocationPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('위치정보 수집 및 이용 동의')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionSubTitle('1. 수집하는 위치정보의 항목'),
                SectionContent(
                    '단말기의 GPS, Wi-Fi, 기지국 정보를 기반으로 한 현재 위치 좌표 (위도, 경도)'),
                SizedBox(height: 16),
                SectionSubTitle('2. 위치정보 수집·이용 목적'),
                SectionContent('- 지역 기반 커뮤니티 콘텐츠 제공\n'
                    '- 내 주변 게시물, 사용자, 장소 정보 제공\n'
                    '- 동네 인증, 지역 추천 기능 등 서비스 품질 향상 목적'),
                SizedBox(height: 16),
                SectionSubTitle('3. 위치정보의 보유 및 이용 기간'),
                SectionContent('- 위치정보는 수집 당시 즉시 처리되며, 별도로 저장하지 않습니다.\n'
                    '- 단, 서비스 이용 기록과 함께 저장되는 경우는 관련 법령 또는 내부 정책에 따라 일정 기간 보관될 수 있습니다.'),
                SizedBox(height: 16),
                SectionSubTitle('4. 동의를 거부할 권리 및 불이익'),
                SectionContent(
                    '- 회원은 위치정보 수집에 동의하지 않을 수 있으며, 이 경우 지역 기반 서비스 이용에 제한이 있을 수 있습니다.\n'
                    '  예: 내 주변 글 보기, 지역 인증, 위치 기반 알림 등'),
                SizedBox(height: 16),
                SectionSubTitle('5. 제3자 제공 및 위탁'),
                SectionContent('- 위치정보는 제3자에게 제공되지 않으며, 운영 목적 외로는 사용되지 않습니다.\n'
                    '- 단, 시스템 운영을 위한 일부 처리(예: 인프라 운영)는 위탁될 수 있습니다.'),
                SizedBox(height: 16),
                SectionSubTitle('6. 기타 사항'),
                SectionContent(
                    '- 회원은 언제든지 위치정보 제공을 중단할 수 있으며, 기기 설정 또는 서비스 내 메뉴를 통해 설정 가능합니다.\n'
                    '- 기타 자세한 내용은 개인정보처리방침을 참고하시기 바랍니다.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
