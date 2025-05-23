# 🎈 소소한 동네 소동 (SoDong)

![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Core-orange.svg)
![Riverpod](https://img.shields.io/badge/Riverpod-2.5.1-purple.svg)
![Status](https://img.shields.io/badge/Status-개발중-green)

<p align="center">
  <img src="https://github.com/user-attachments/assets/51217c86-d130-4523-8dc2-44dd9ae64b78" alt="소동 로고" width="200"/>
</p>



## 📱 앱 소개

**소소한 동네 소동**은 이웃 간의 소통과 정보 공유를 촉진하는 지역 기반 커뮤니티 앱입니다. 위치 기반 서비스를 통해 사용자들이 자신의 동네에서 일어나는 다양한 소식과 정보를 쉽게 접하고 공유할 수 있습니다. 이 앱은 사람들이 지역 사회에 더 깊이 참여하고 이웃과 유대감을 형성할 수 있도록 도와줍니다.

## 📸 앱 스크린샷

> 💡 **참고**: 아래 스크린샷을 보려면 `screenshots` 디렉토리에 해당 이미지 파일을 추가해주세요.
>
> 스크린샷 가이드: 1440x3088 해상도(갤럭시 S21), 테마를 포함하여 앱의 다양한 기능과 UI를 잘 보여주는 이미지를 추가해 주세요.

<div align="center">
  <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 10px;">
    <img src="screenshots/screenshot_01_splash.png" alt="스플래시 화면" width="200"/>
    <img src="screenshots/screenshot_02_login.png" alt="로그인 화면" width="200"/>
    <img src="screenshots/screenshot_03_home.png" alt="홈 화면" width="200"/>
    <img src="screenshots/screenshot_04_post_list.png" alt="게시물 목록" width="200"/>
  </div>
  <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; margin-top: 10px;">
    <img src="screenshots/screenshot_05_post_detail.png" alt="게시물 상세" width="200"/>
    <img src="screenshots/screenshot_06_create_post.png" alt="게시물 작성" width="200"/>
    <img src="screenshots/screenshot_07_profile.png" alt="프로필 화면" width="200"/>
    <img src="screenshots/screenshot_08_comments.png" alt="댓글 화면" width="200"/>
  </div>
  <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; margin-top: 10px;">
    <img src="screenshots/screenshot_09_notifications.png" alt="알림 화면" width="200"/>
    <img src="screenshots/screenshot_10_settings.png" alt="설정 화면" width="200"/>
    <img src="screenshots/screenshot_11_location.png" alt="위치 설정" width="200"/>
    <img src="screenshots/screenshot_12_categories.png" alt="카테고리 화면" width="200"/>
  </div>
</div>

### 📋 스크린샷 설명

| 스크린샷      | 설명                           | 주요 기능                          |
| ------------- | ------------------------------ | ---------------------------------- |
| 스플래시 화면 | 앱 시작 시 표시되는 화면       | 앱 로고 및 애니메이션              |
| 로그인 화면   | 소셜 로그인 옵션이 있는 화면   | 구글 로그인, 이용약관 동의         |
| 홈 화면       | 사용자의 위치 기반 추천 게시물 | 위치별 게시물 필터링, 새 소식 알림 |
| 게시물 목록   | 카테고리별 게시물 표시         | 무한 스크롤, 카테고리 필터링       |
| 게시물 상세   | 선택한 게시물의 상세 내용      | 이미지 갤러리, 좋아요, 공유 기능   |
| 게시물 작성   | 새 게시물 작성 화면            | 다중 이미지 업로드, 카테고리 선택  |
| 프로필 화면   | 사용자 프로필 정보             | 활동 내역, 작성 게시물 목록        |
| 댓글 화면     | 게시물의 댓글 목록             | 댓글 작성, 좋아요, 대댓글          |
| 알림 화면     | 사용자 알림 목록               | 읽음 표시, 알림 설정               |
| 설정 화면     | 앱 설정 화면                   | 다크 모드, 알림 설정, 계정 관리    |
| 위치 설정     | 사용자 위치 설정 화면          | 지도 표시, 위치 검색, 위치 변경    |
| 카테고리 화면 | 게시물 카테고리 선택           | 다양한 카테고리 옵션 제공          |

## ✨ 주요 기능

### 🧭 위치 기반 서비스

- **위치 탐색**: 사용자의 현재 위치를 자동으로 감지하여 지역별 게시물 표시
- **지역 필터링**: 특정 반경 내의 게시물만 볼 수 있는 필터링 기능
- **지도 통합**: 게시물 위치를 지도에서 시각적으로 확인 가능

### 📰 게시물 관리

- **카테고리별 게시물**: 일상, 정보, 질문, 모임 등 다양한 카테고리로 구분
- **무한 스크롤**: 최적화된 페이지네이션 기능으로 게시물을 부드럽게 로딩
- **이미지 지원**: 다중 이미지 업로드 및 표시 기능
- **게시물 작성/수정/삭제**: 직관적인 게시물 관리 인터페이스

### 👤 사용자 계정

- **소셜 로그인**: Google 계정을 통한 간편한 로그인 지원
- **프로필 관리**: 사용자 이름, 프로필 이미지, 지역 설정 기능
- **활동 내역**: 작성한 게시물, 댓글 등 활동 기록 확인

### 🔔 알림 시스템

- **실시간 알림**: 댓글, 좋아요 등에 대한 실시간 알림
- **알림 관리**: 알림 유형별 설정 가능

## 🛠️ 기술 스택 및 상세 구현

### Frontend: Flutter

- **상태 관리**: Flutter Riverpod 2.5.1을 사용한 반응형 상태 관리
- **UI 컴포넌트**: Material Design 기반 커스텀 UI 컴포넌트
- **반응형 디자인**: 다양한 화면 크기와 해상도 지원

### Backend: Firebase

- **인증**: Firebase Auth를 사용한 소셜 로그인 및 사용자 관리
- **데이터베이스**: Cloud Firestore를 활용한 NoSQL 데이터 저장 및 실시간 동기화
- **저장소**: Firebase Storage를 이용한 이미지 및 미디어 파일 관리
- **푸시 알림**: Firebase Cloud Messaging을 통한 실시간 알림 기능

### 위치 서비스

- **위치 감지**: Geolocator 14.0.0를 활용한 정확한 사용자 위치 감지
- **지오코딩**: 좌표와 주소 간 변환을 통한 위치 정보 표시
- **지오해싱**: 효율적인 위치 기반 데이터 쿼리 처리

### 네트워킹

- **HTTP 클라이언트**: Dio 5.8.0을 활용한 효율적인 네트워크 요청 처리
- **환경 변수 관리**: flutter_dotenv를 통한 안전한 API 키 관리

## 🏗️ 아키텍처

본 앱은 **클린 아키텍처(Clean Architecture)** 원칙과 **기능 중심 구조(Feature-first Architecture)**를 결합하여 설계되었습니다. 각 기능(Feature)은 데이터(Data), 도메인(Domain), 프레젠테이션(Presentation) 계층으로 분리되어 있습니다.

### 클린 아키텍처 적용

소동 앱은 로버트 마틴(Robert C. Martin)의 클린 아키텍처 원칙을 따르고 있습니다:

#### 계층 구조

1. **엔티티 계층(Entities)**: 핵심 비즈니스 규칙을 포함하는 엔티티 객체

   - 앱의 핵심 도메인 모델 (User, Post, Comment 등)
   - 외부 종속성이 없는 순수 Dart 클래스

2. **유스케이스 계층(Use Cases)**: 애플리케이션 특화 비즈니스 규칙

   - 각 기능에 대한 독립적인 유스케이스 클래스
   - 레포지토리 인터페이스에 의존, 구현체에는 의존하지 않음

3. **인터페이스 어댑터 계층(Interface Adapters)**: 외부 시스템/프레임워크와 내부 로직 간의 변환

   - 프레젠터(Presenters): 뷰모델, 프로바이더
   - 레포지토리 구현체: 데이터 소스와 도메인 간의 중개자

4. **프레임워크 및 드라이버 계층(Frameworks & Drivers)**: 외부 프레임워크와 도구
   - Flutter UI 컴포넌트
   - Firebase 데이터 소스
   - Geolocator 플러그인

#### 의존성 규칙

모든 종속성은 외부 계층에서 내부 계층으로 향하며, 내부 계층은 외부 계층에 의존하지 않습니다:

- 도메인 계층(Entity, UseCase)은 UI나 데이터 소스에 의존하지 않음
- 데이터 계층은 도메인 인터페이스를 구현하여 의존성 역전 원칙(DIP) 적용
- 의존성 주입을 통해 결합도 감소 및 테스트 용이성 확보

#### 클린 아키텍처의 이점

- **유지보수성**: 코드 변경이 격리되어 부작용 최소화
- **테스트 용이성**: 각 계층을 독립적으로 테스트 가능
- **확장성**: 새로운 기능 추가가 기존 코드에 영향 최소화
- **프레임워크 독립성**: Flutter, Firebase 등 외부 프레임워크 교체 용이

### 프로젝트 구조 (확장 버전)

```
lib/
├── core/                                         # 공통 유틸리티 및 핵심 컴포넌트
│   ├── result/                                   # 결과 처리 및 에러 핸들링
│   │   ├── result.dart                           # 성공/실패 결과 래핑 클래스
│   │   └── create_post_exception.dart            # 예외 처리 클래스
│   ├── utils/                                    # 유틸리티 함수
│   │   ├── date_formatter.dart                   # 날짜 형식 변환 유틸리티
│   │   ├── image_utils.dart                      # 이미지 처리 유틸리티
│   │   └── validators.dart                       # 입력 유효성 검사기
│   ├── constants/                                # 상수 정의
│   │   ├── app_colors.dart                       # 앱 색상 테마
│   │   ├── app_strings.dart                      # 앱 문자열 상수
│   │   └── api_paths.dart                        # API 경로 상수
│   └── widgets/                                  # 공통 위젯
│       ├── buttons/                              # 버튼 위젯
│       ├── dialogs/                              # 다이얼로그 위젯
│       ├── cards/                                # 카드 스타일 위젯
│       └── loading/                              # 로딩 인디케이터 위젯
│
├── features/                                     # 기능별 모듈화 (각 기능은 클린 아키텍처 구조 따름)
│   ├── auth/                                     # 인증 관련 기능
│   │   ├── data/                                 # 데이터 계층
│   │   │   ├── datasources/                      # 데이터 소스
│   │   │   │   ├── auth_remote_data_source.dart  # Firebase Auth 연동
│   │   │   │   └── user_data_source.dart         # 사용자 데이터 관리
│   │   │   ├── models/                           # 데이터 모델
│   │   │   │   └── user_model.dart               # 사용자 데이터 모델
│   │   │   └── repositories/                     # 레포지토리 구현
│   │   │       └── auth_repository_impl.dart     # 인증 레포지토리 구현
│   │   ├── domain/                               # 도메인 계층
│   │   │   ├── entities/                         # 엔티티 모델
│   │   │   │   └── user_entity.dart              # 사용자 엔티티
│   │   │   ├── repositories/                     # 레포지토리 인터페이스
│   │   │   │   └── auth_repository.dart          # 인증 레포지토리 인터페이스
│   │   │   └── usecases/                         # 비즈니스 로직 유스케이스
│   │   │       ├── login_usecase.dart            # 로그인 유스케이스
│   │   │       ├── logout_usecase.dart           # 로그아웃 유스케이스
│   │   │       └── get_user_profile_usecase.dart # 프로필 조회 유스케이스
│   │   └── presentation/                         # 프레젠테이션 계층
│   │       ├── pages/                            # 화면 페이지
│   │       │   ├── login/                        # 로그인 페이지
│   │       │   ├── splash/                       # 스플래시 페이지
│   │       │   ├── profile_edit/                 # 프로필 편집 페이지
│   │       │   └── policy/                       # 정책 페이지
│   │       ├── providers/                        # Riverpod 제공자
│   │       │   └── auth_provider.dart            # 인증 상태 제공자
│   │       ├── view_models/                      # 뷰 모델
│   │       │   └── auth_view_model.dart          # 인증 화면 뷰 모델
│   │       └── widgets/                          # UI 위젯
│   │           ├── login_button.dart             # 로그인 버튼 위젯
│   │           └── profile_avatar.dart           # 프로필 아바타 위젯
│   │
│   ├── location/                                 # 위치 서비스 기능
│   │   ├── data/                                 # 데이터 계층
│   │   │   ├── datasources/                      # 위치 데이터 소스
│   │   │   │   └── location_data_source.dart     # 위치 데이터 소스 구현
│   │   │   ├── models/                           # 위치 모델
│   │   │   │   └── location_model.dart           # 위치 데이터 모델
│   │   │   └── repositories/                     # 레포지토리 구현
│   │   │       └── location_repository_impl.dart # 위치 레포지토리 구현
│   │   ├── domain/                               # 도메인 계층
│   │   │   ├── entities/                         # 엔티티
│   │   │   │   └── location_entity.dart          # 위치 엔티티
│   │   │   ├── repositories/                     # 레포지토리 인터페이스
│   │   │   │   └── location_repository.dart      # 위치 레포지토리 인터페이스
│   │   │   └── usecases/                         # 유스케이스
│   │   │       ├── get_current_location_usecase.dart    # 현재 위치 조회
│   │   │       └── watch_location_changes_usecase.dart  # 위치 변경 감시
│   │   └── presentation/                         # 프레젠테이션 계층
│   │       ├── providers/                        # 위치 제공자
│   │       │   └── location_provider.dart        # 위치 상태 제공자
│   │       └── widgets/                          # 위치 관련 위젯
│   │           └── location_picker.dart          # 위치 선택 위젯
│   │
│   ├── post_list/                                # 게시물 목록 표시
│   │   ├── data/                                 # 데이터 계층
│   │   │   ├── datasources/                      # 원격 데이터 소스
│   │   │   │   └── post_remote_data_source.dart  # Firestore 게시물 데이터 소스
│   │   │   ├── models/                           # 모델
│   │   │   │   └── post_model.dart               # 게시물 모델
│   │   │   └── repositories/                     # 레포지토리 구현
│   │   │       └── post_repository_impl.dart     # 게시물 레포지토리 구현
│   │   ├── domain/                               # 도메인 계층
│   │   │   ├── entities/                         # 엔티티
│   │   │   │   ├── post_entity.dart              # 게시물 엔티티
│   │   │   │   └── post_filter_options.dart      # 게시물 필터 옵션
│   │   │   ├── repositories/                     # 레포지토리 인터페이스
│   │   │   │   └── post_repository.dart          # 게시물 레포지토리 인터페이스
│   │   │   └── usecases/                         # 유스케이스
│   │   │       ├── get_posts_usecase.dart        # 게시물 목록 조회
│   │   │       └── filter_posts_usecase.dart     # 게시물 필터링
│   │   └── presentation/                         # 프레젠테이션 계층
│   │       ├── pages/                            # 페이지
│   │       │   └── post_list_page.dart           # 게시물 목록 페이지
│   │       ├── providers/                        # 제공자
│   │       │   └── post_list_provider.dart       # 게시물 목록 상태 제공자
│   │       ├── view_models/                      # 뷰 모델
│   │       │   └── post_list_view_model.dart     # 게시물 목록 뷰 모델
│   │       └── widgets/                          # 위젯
│   │           ├── post_card.dart                # 게시물 카드 위젯
│   │           ├── post_filter_bar.dart          # 게시물 필터 바
│   │           ├── category_selector.dart        # 카테고리 선택기
│   │           └── empty_post_placeholder.dart   # 게시물 없음 표시자
│   │
│   ├── post_detail/                              # 게시물 상세 보기
│   │   ├── data/                                 # 데이터 계층
│   │   │   ├── datasources/                      # 데이터 소스
│   │   │   │   └── comment_data_source.dart      # 댓글 데이터 소스
│   │   │   ├── models/                           # 모델
│   │   │   │   └── comment_model.dart            # 댓글 모델
│   │   │   └── repositories/                     # 레포지토리 구현
│   │   │       └── comment_repository_impl.dart  # 댓글 레포지토리 구현
│   │   ├── domain/                               # 도메인 계층
│   │   │   ├── entities/                         # 엔티티
│   │   │   │   └── comment_entity.dart           # 댓글 엔티티
│   │   │   ├── repositories/                     # 레포지토리 인터페이스
│   │   │   │   └── comment_repository.dart       # 댓글 레포지토리 인터페이스
│   │   │   └── usecases/                         # 유스케이스
│   │   │       ├── get_post_details_usecase.dart # 게시물 상세 조회
│   │   │       ├── add_comment_usecase.dart      # 댓글 추가
│   │   │       └── like_post_usecase.dart        # 게시물 좋아요
│   │   └── presentation/                         # 프레젠테이션 계층
│   │       ├── pages/                            # 페이지
│   │       │   └── post_detail_page.dart         # 게시물 상세 페이지
│   │       ├── providers/                        # 제공자
│   │       │   └── post_detail_provider.dart     # 게시물 상세 상태 제공자
│   │       └── widgets/                          # 위젯
│   │           ├── comment_list.dart             # 댓글 목록 위젯
│   │           ├── post_image_gallery.dart       # 게시물 이미지 갤러리
│   │           └── post_action_buttons.dart      # 게시물 액션 버튼
│   │
│   ├── create_post/                              # 게시물 작성
│   │   ├── data/                                 # 데이터 계층
│   │   │   ├── datasources/                      # 데이터 소스
│   │   │   │   └── post_create_data_source.dart  # 게시물 생성 데이터 소스
│   │   │   └── repositories/                     # 레포지토리 구현
│   │   │       └── post_create_repository_impl.dart  # 게시물 생성 레포지토리 구현
│   │   ├── domain/                               # 도메인 계층
│   │   │   ├── repositories/                     # 레포지토리 인터페이스
│   │   │   │   └── post_create_repository.dart   # 게시물 생성 레포지토리 인터페이스
│   │   │   └── usecases/                         # 유스케이스
│   │   │       ├── create_post_usecase.dart      # 게시물 생성 유스케이스
│   │   │       └── upload_image_usecase.dart     # 이미지 업로드 유스케이스
│   │   └── presentation/                         # 프레젠테이션 계층
│   │       ├── pages/                            # 페이지
│   │       │   └── create_post_page.dart         # 게시물 작성 페이지
│   │       ├── providers/                        # 제공자
│   │       │   └── create_post_provider.dart     # 게시물 작성 상태 제공자
│   │       └── widgets/                          # 위젯
│   │           ├── post_form.dart                # 게시물 작성 폼
│   │           ├── image_picker_widget.dart      # 이미지 선택 위젯
│   │           └── category_picker.dart          # 카테고리 선택 위젯
│   │
│   └── profile/                                  # 사용자 프로필
│       ├── data/                                 # 데이터 계층
│       │   ├── datasources/                      # 데이터 소스
│       │   │   └── profile_data_source.dart      # 프로필 데이터 소스
│       │   └── repositories/                     # 레포지토리 구현
│       │       └── profile_repository_impl.dart  # 프로필 레포지토리 구현
│       ├── domain/                               # 도메인 계층
│       │   ├── repositories/                     # 레포지토리 인터페이스
│       │   │   └── profile_repository.dart       # 프로필 레포지토리 인터페이스
│       │   └── usecases/                         # 유스케이스
│       │       ├── get_user_posts_usecase.dart   # 사용자 게시물 조회
│       │       └── update_profile_usecase.dart   # 프로필 업데이트
│       └── presentation/                         # 프레젠테이션 계층
│           ├── pages/                            # 페이지
│           │   └── profile_page.dart             # 프로필 페이지
│           ├── providers/                        # 제공자
│           │   └── profile_provider.dart         # 프로필 상태 제공자
│           └── widgets/                          # 위젯
│               ├── profile_header.dart           # 프로필 헤더 위젯
│               └── user_activity_list.dart       # 사용자 활동 목록 위젯
│
├── firebase_options.dart                         # Firebase 구성 설정
└── main.dart                                     # 앱 진입점
```

### 주요 디자인 패턴

1. **Repository 패턴**

   - **목적**: 데이터 소스와 비즈니스 로직 분리
   - **구현**: 모든 데이터 접근은 Repository 인터페이스를 통해 이루어짐
   - **이점**: 데이터 소스 변경 시 비즈니스 로직 영향 최소화

2. **Provider 패턴**

   - **목적**: 상태 관리 및 의존성 주입
   - **구현**: Riverpod 라이브러리를 활용한 상태 관리
   - **이점**: 테스트 가능성 향상 및 컴포넌트 간 결합도 감소

3. **UseCase 패턴**

   - **목적**: 비즈니스 로직 캡슐화
   - **구현**: 각 기능별 독립적인 UseCase 클래스 생성
   - **이점**: 단일 책임 원칙 준수 및 코드 재사용성 향상

4. **Result 패턴**
   - **목적**: 에러 핸들링을 위한 결과 랩핑
   - **구현**: Success와 Failure를 포함하는 Result 클래스 사용
   - **이점**: 예외 처리 일관성 및 타입 안전성 보장

### 데이터 흐름 상세

```
UI (Widget)
   ↕️
Provider/ViewModel (상태 관리 및 UI 로직)
   ↕️
UseCase (비즈니스 로직 및 도메인 규칙)
   ↕️
Repository (도메인과 데이터 계층 간 중재자)
   ↕️
DataSource (Firebase, 로컬 저장소 등 데이터 접근 계층)
```

#### 데이터 흐름 예시: 게시물 로딩

1. 사용자가 게시물 목록 페이지 접근
2. PostListPage가 PostListProvider를 구독
3. PostListProvider가 GetPostsUseCase 호출
4. GetPostsUseCase가 PostRepository 인터페이스 메서드 호출
5. PostRepositoryImpl이 PostRemoteDataSource를 통해 Firestore에서 데이터 요청
6. 데이터가 PostModel로 변환되고 PostEntity로 매핑
7. 결과가 Repository → UseCase → Provider → UI로 전달되어 화면에 표시

## 📋 설치 및 실행 방법

### 필수 조건

- Flutter 3.0 이상
- Dart SDK 3.0 이상
- Firebase 프로젝트 설정

### 설치 단계

1. 리포지토리 클론

   ```bash
   git clone https://github.com/yourusername/sodong-app.git
   cd sodong-app
   ```

2. 의존성 설치

   ```bash
   flutter pub get
   ```

3. Firebase 설정

   - `.env` 파일을 프로젝트 루트에 생성하고 필요한 키 추가
   - Firebase 프로젝트 설정 및 `google-services.json`/`GoogleService-Info.plist` 추가

4. 앱 실행
   ```bash
   flutter run
   ```

## 🚀 배포

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## 🧾 트러블슈팅 사례

### 무한 스크롤 로딩 인디케이터 문제

- **문제**: 게시물이 없는데도 하단에 로딩 인디케이터가 계속 표시되는 문제
- **원인**:
  - `hasMorePosts` 플래그 관리 로직 오류
  - UI 조건부 렌더링 부족
  - 에러 상황에서 플래그 업데이트 누락
- **해결**:
  - Repository 로직 개선: `_hasMore = posts.length >= PostRemoteDataSource.pageSize`
  - 에러 처리 강화: 에러 발생 시 명시적으로 `_hasMore = false` 설정
  - UI 조건부 렌더링 개선: `hasMorePosts && !isLoading && posts.isNotEmpty` 조건 추가
  - 스크롤 리스너에 안전장치 추가: 추가 로드 시도 전 검증 로직 강화

## 💌 기여 방법

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🧪 테스트

```bash
# 단위 테스트 실행
flutter test

# 통합 테스트 실행
flutter test integration_test
```

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 👥 팀원

- [팀원 1](https://github.com/username1) - 개발자
- [팀원 2](https://github.com/username2) - 디자이너
- [팀원 3](https://github.com/username3) - 기획자

## 📞 연락처

프로젝트에 관한 질문이나 제안이 있으시면 이슈를 등록하거나 다음 이메일로 연락주세요: email@example.com
