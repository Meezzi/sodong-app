import 'package:flutter/material.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/widgets/common_widgets.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이용약관')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('제1장 소소한 동네에 오신 걸 환영합니다'),
                SectionSubTitle('제1조 (목적)'),
                SectionContent(
                    '이 약관은 "소소한 동네"(이하 \'회사\')가 제공하는 서비스의 이용조건, 회사와 회원 간의 권리 및 의무, 책임 등을 정하는 것을 목적으로 합니다.'),
                SectionSubTitle('제2조 (약관의 적용과 변경)'),
                SectionContent('1. 본 약관은 서비스 내 게시되며, 회원 가입과 동시에 효력이 발생합니다.\n'
                    '2. 법령 변경 또는 서비스 개선을 위해 약관이 개정될 수 있으며, 변경사항은 시행일 7일 전부터 서비스 내 공지됩니다.\n'
                    '3. 회원이 변경된 약관에 동의하지 않을 경우, 서비스 이용을 중단하고 탈퇴할 수 있습니다.'),
                SectionSubTitle('제3조 (기타 준칙)'),
                SectionContent('약관에서 다루지 않은 사항은 관계 법령 및 별도 운영정책에 따릅니다.'),
                SizedBox(height: 20),
                SectionTitle('제2장 계정과 가입'),
                SectionSubTitle('제4조 (가입 조건 및 방식)'),
                SectionContent('1. 소소한 동네는 Google 계정 로그인을 통해 간편하게 가입할 수 있습니다.\n'
                    '2. 만 14세 이상만 회원 가입이 가능하며, 회사는 필요 시 본인 확인을 요청할 수 있습니다.'),
                SectionSubTitle('제5조 (가입 거절 및 제한)'),
                SectionContent('- 타인 정보를 무단 사용하거나 허위 정보를 입력한 경우\n'
                    '- 과거 서비스 이용 중 정지 또는 탈퇴 처리된 경우\n'
                    '- 시스템 오용 또는 서비스 방해 행위가 의심되는 경우\n'
                    '- 기타 회사의 정책상 이용이 부적절하다고 판단되는 경우'),
                SizedBox(height: 20),
                SectionTitle('제3장 서비스 이용'),
                SectionSubTitle('제6조 (제공되는 서비스)'),
                SectionContent(
                    '소소한 동네는 위치 기반으로 지역 주민들과 익명으로 소통할 수 있는 커뮤니티 기능을 제공합니다.\n'
                    '게시판 글쓰기, 댓글, 공감 등의 기능을 포함하며, 서비스는 연중무휴로 운영됩니다.'),
                SectionSubTitle('제7조 (이용자의 책임과 금지행위)'),
                SectionContent('- 허위 정보 등록, 타인 사칭\n'
                    '- 욕설, 혐오 표현, 차별, 음란물 등 부적절한 콘텐츠 작성\n'
                    '- 광고 또는 상업적 목적의 홍보 활동\n'
                    '- 서비스나 서버에 악영향을 주는 기술적 시도\n'
                    '- 기타 법령 또는 사회질서에 위반되는 행위\n'
                    '회사는 위반 시 사전 경고 없이 게시물 삭제, 이용 제한, 탈퇴 등의 조치를 할 수 있습니다.'),
                SectionSubTitle('제8조 (게시물 운영)'),
                SectionContent('1. 회원이 작성한 게시물의 권리와 책임은 본인에게 있습니다.\n'
                    '2. 회사는 다음과 같은 경우 게시물을 삭제하거나 숨김 처리할 수 있습니다:\n'
                    '- 법 위반 또는 타인의 권리를 침해하는 경우\n'
                    '- 커뮤니티 운영 정책에 위배되는 경우\n'
                    '- 허위 또는 악의적 내용을 포함하는 경우'),
                SizedBox(height: 20),
                SectionTitle('제4장 계정 관리와 해지'),
                SectionSubTitle('제9조 (계정 탈퇴)'),
                SectionContent(
                    '회원은 언제든지 서비스 설정 메뉴를 통해 계정을 삭제할 수 있으며, 탈퇴 즉시 개인정보는 관련 법령에 따라 파기 또는 분리 보관됩니다.'),
                SectionSubTitle('제10조 (이용 제한 및 제재)'),
                SectionContent('- 약관 및 운영정책 반복 위반\n'
                    '- 명백한 불법 행위나 타인 권리 침해\n'
                    '- 커뮤니티 내 반복된 문제 유발\n'
                    '- 기술적 공격 또는 시스템 위협 행위'),
                SizedBox(height: 20),
                SectionTitle('제5장 기타 사항'),
                SectionSubTitle('제11조 (위치기반 서비스 안내)'),
                SectionContent(
                    '1. 소소한 동네는 회원의 위치 정보를 활용하여 지역 커뮤니티 콘텐츠를 제공합니다.\n'
                    '2. 위치 정보 수집은 회원의 동의 하에 이루어지며, 관련 정보는 개인정보처리방침에 따릅니다.'),
                SectionSubTitle('제12조 (개인정보 보호)'),
                SectionContent(
                    '회사는 회원의 개인정보를 소중히 다루며, 수집 및 이용에 대한 세부 사항은 개인정보처리방침을 통해 안내합니다.'),
                SectionSubTitle('제13조 (서비스 책임 제한)'),
                SectionContent(
                    '1. 회사는 천재지변, 네트워크 장애 등 불가항력적 사유로 인한 서비스 중단에 책임지지 않습니다.\n'
                    '2. 게시물, 댓글 등 사용자 생성 콘텐츠에 대한 법적 책임은 작성자에게 있습니다.'),
                SectionSubTitle('제14조 (준거법 및 관할)'),
                SectionContent(
                    '서비스와 관련된 분쟁은 대한민국 법률을 따르며, 관할 법원은 회사 본사가 위치한 법원으로 합니다.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
