import 'package:flutter/material.dart';
import 'package:sodong_app/features/auth/presentation/pages/policy/widgets/common_widgets.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보 처리방침')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionContent(
                  '소소한 동네는 개인정보 보호법 등 관련 법령을 준수하며, '
                  '이용자의 개인정보를 소중하게 관리하고 보호합니다. 본 개인정보처리방침은 '
                  '이용자가 서비스를 이용함에 있어 제공하는 개인정보의 처리 목적, 수집 항목, '
                  '보유 기간, 권리 등을 안내합니다.',
                ),
                SizedBox(height: 20),
                SectionTitle('1. 개인정보의 처리 목적'),
                SectionContent('''
                    • 서비스 회원가입 및 본인 확인
                    • 서비스 제공 및 기능 개선
                    • 이용자 문의 대응 및 공지사항 전달
                    • 부정 이용 방지 및 이용자 보호
                '''),
                SizedBox(height: 20),
                SectionTitle('2. 처리하는 개인정보 항목'),
                SectionSubTitle('[필수 수집 항목]'),
                SectionContent('''
                    • 구글 계정 이메일 주소
                    • 닉네임
                    • 프로필 사진
                '''),
                SizedBox(height: 8),
                SectionSubTitle('[선택 수집 항목]'),
                SectionContent('''
                    • 위치 정보: 지역 기반 기능 제공을 위해 사용되며, 이용자의 명시적 동의를 받아 수집합니다.
                '''),
                SizedBox(height: 20),
                SectionTitle('3. 개인정보의 처리 및 보유 기간'),
                SectionContent('''
                    • 회원 탈퇴 시 즉시 파기
                    • 부정 이용 방지를 위해 탈퇴 후 1년간 최소 정보 보관 가능
                    • 관계법령에 따라 일정 기간 보관이 필요한 경우 해당 법령에 따름
                '''),
                SizedBox(height: 20),
                SectionTitle('4. 개인정보의 파기 절차 및 방법'),
                SectionContent('''
                    • 전자적 파일: 복구 불가능한 방식으로 영구 삭제
                    • 서면 자료: 분쇄 또는 소각
                '''),
                SizedBox(height: 20),
                SectionTitle('5. 개인정보의 제3자 제공'),
                SectionSubTitle(
                    '소소한 동네는 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않습니다. '
                    '단, 법령에 따라 필요한 경우는 예외로 합니다.',
                ),
                SizedBox(height: 20),
                SectionTitle('6. 개인정보 처리의 위탁'),
                SectionSubTitle(
                    '서비스 운영을 위해 개인정보 처리 업무를 외부 업체에 위탁할 수 있으며, '
                    '수탁자는 개인정보 보호법상 의무를 준수하도록 관리·감독합니다.',
                ),
                SizedBox(height: 20),
                SectionTitle('7. 개인정보 자동 수집 장치의 설치·운영 및 거부'),
                SectionContent('''
                    • 쿠키 등 자동 수집 장치를 통해 이용자 접속 기록, 서비스 이용 내역을 수집할 수 있습니다.
                    • 이용자는 웹 브라우저 설정을 통해 쿠키 저장을 거부할 수 있습니다.
                '''),
                SizedBox(height: 20),
                SectionTitle('8. 정보주체의 권리·의무 및 행사 방법'),
                SectionSubTitle(
                    '이용자는 언제든지 개인정보의 열람, 정정, 삭제, 처리 정지를 요청할 수 있으며, '
                    '서비스 내 설정 또는 고객센터를 통해 권리를 행사할 수 있습니다.',
                ),
                SizedBox(height: 20),
                SectionTitle('9. 14세 미만 아동의 개인정보 처리'),
                SectionSubTitle(
                    '소소한 동네는 14세 미만 아동의 개인정보를 수집하지 않으며, 가입 또한 제한합니다.',
                ),
                SizedBox(height: 20),
                SectionTitle('10. 개인정보의 안전성 확보조치에 관한 사항'),
                SectionContent('''
                    • 암호화: Google 로그인을 통해 수집한 개인정보는 암호화하여 안전하게 저장합니다.
                    • 접근 제한: 개인정보 접근 권한을 최소한의 인원에게만 부여하고, 접근 기록을 관리합니다.
                    • 내부 교육: 개인정보를 처리하는 직원에게 정기적인 개인정보 보호 교육을 실시합니다.
                '''),
                SizedBox(height: 20),
                SectionTitle('11. 개인정보 보호책임자'),
                SectionContent('''
                    • 성명: 강민지
                    • 연락처: glow3941@gmail.com
                    • 담당 부서: 개인정보보호팀
                '''),
                SizedBox(height: 20),
                SectionTitle('12. 개인정보 처리방침 변경에 관한 사항'),
                SectionSubTitle(
                    '본 방침은 법령, 정책 변경 또는 서비스 변경에 따라 수정될 수 있으며, '
                    '변경 시 최소 7일 전 서비스 내 공지합니다.',
                ),
                SizedBox(height: 8),
                SectionContent('''
                    • 공고일자: 2025년 5월 21일
                    • 시행일자: 2025년 5월 28일
                '''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
