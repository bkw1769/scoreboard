# Scoreboard

Flutter로 구현된 실시간 점수판 애플리케이션입니다.  
본 앱은 배드민턴, 탁구, 테니스 등 1:1 또는 팀 대결을 기반으로 한 스포츠에서 사용할 수 있도록 설계되었습니다.  
두 팀의 점수와 세트 스코어를 관리하며, 타이머 및 색상 설정 등 다양한 커스터마이징 기능을 제공합니다.  
게임 기록은 로컬 SQLite 데이터베이스에 저장되어 추후 조회가 가능합니다.

## 프로젝트 구조

<pre><code>project/
├── lib/
│   ├── main.dart                      # 앱 엔트리포인트
│   ├── models/                        # 데이터 모델 정의
│   │   ├── game_record.dart
│   │   └── score_record.dart
│   ├── providers/                     # 상태 관리
│   │   ├── game_record_provider.dart
│   │   ├── scoreboard_provider.dart
│   │   ├── settings_provider.dart
│   │   └── timer_provider.dart
│   ├── screens/                       # 주요 화면
│   │   ├── scoreboard_screen.dart
│   │   └── settings_screen.dart
│   ├── services/                      # 서비스 로직
│   │   └── database_helper.dart
│   └── widgets/                       # 공통 UI 컴포넌트
│       ├── game_timer.dart
│       ├── score_display.dart
│       └── set_score_display.dart
├── android/
├── ios/
├── test/
├── pubspec.yaml
└── README.md
</code></pre>


## 주요 기능

- ✅ 세트 스코어 규칙 기반 자동 점수 계산
- 🎨 팀별 색상 설정 및 코트 위치 전환
- ⏱️ 경기 타이머 (시작, 일시정지, 초기화 기능 포함)
- 💾 SQLite(`sqflite`) 기반 경기 기록 저장 및 조회
- 📦 Provider 패턴 기반 상태 관리

## 실행 방법

1. Flutter SDK가 설치되어 있어야 합니다.
2. 아래 명령어를 프로젝트 루트에서 실행하세요:

```bash
flutter pub get
flutter run
