# 🛴 GodRide: 킥보드 대여 및 관리 iOS 앱

## 📱 프로젝트 소개

**GodRide**는 사용자가 킥보드를 직접 등록하고, 대여 및 반납하며 이용 이력을 관리할 수 있는 iOS 애플리케이션입니다. KakaoMap을 기반으로 위치 기반 서비스를 제공하며, 직관적인 UI와 확장성 있는 데이터 구조로 구현되었습니다.

> 🚀 *“사용자가 직접 킥보드를 등록하고 대여하는 서비스, 어디서든 내 킥보드를 관리해보세요!”*

---

## 🧑‍💻 팀 목표

* 실사용 가능한 iOS 앱을 개발하며 팀 협업 역량 및 아키텍처 설계 경험 향상
* CoreData와 KakaoMapSDK를 활용한 실시간 위치 기반 서비스 개발
* MVVM 디자인 패턴을 적용한 깔끔하고 유지 보수 가능한 구조 구성

---

## 👨‍👩‍👧‍👦 팀원 소개

- 이세준 : 발표, 프로젝트 셋팅, 지도 API 분석
- 신재욱 : 지도 API 분석, 등록 View
- 이부용 : 로그인, 회원가입, 마이페이지, 등록 내역, 이용 내역 View, Readme 작성
- **공통** : SA 작성, 스크럼 일지 정리, QnA 정리 등.. + 시연 영상, 발표 자료, 디자인

---

## 🧩 핵심 기능 요약

| 기능 구분     | 주요 기능 설명                              |
| --------- | ------------------------------------- |
| 👤 회원 관리  | 회원가입, 로그인, 로그아웃 (UserDefaults 활용)     |
| 🗺️ 지도 기능 | 실시간 킥보드 위치 확인, 대여/반납 기능 (KakaoMap 기반) |
| 📥 킥보드 등록 | 킥보드 직접 등록 및 삭제, 등록 이력 관리              |
| 📈 이용 이력  | 대여 내역 및 거리 계산 기능, CoreData 기반 저장      |
| 👤 마이페이지  | 내가 등록한 킥보드, 이용 이력 확인 및 로그아웃           |

---

## 🔧 기술 스택

| 구분           | 내용                     |
| ------------ | ---------------------- |
| **언어**       | Swift                  |
| **UI 프레임워크** | UIKit, SnapKit, Then   |
| **지도**       | KakaoMapSDK            |
| **데이터**      | CoreData, UserDefaults |
| **아키텍처**     | MVVM                   |
| **버전 관리**    | Git, GitHub            |

---

## 🧠 아키텍처

| 아키텍처 타입           | 사용 이유                           |
| ----------------- | ------------------------------- |
| **MVVM**          | View 로직과 비즈니스 로직 분리, 테스트 용이성 확보 |
| **CoreData 저장구조** | 사용자 이력 및 킥보드 등록 정보의 영속적 관리      |
| **UserDefaults**  | 로그인 상태 및 사용자 정보 저장              |

---

## 📁 프로젝트 구조

```
─── TeamProject
    ├── APIKey.xcconfig
    ├── KakaoAPIKey.xcconfig
    ├── TeamProject
    │   ├── App
    │   │   ├── AppDelegate.swift
    │   │   └── SceneDelegate.swift
    │   ├── Model
    │   │   ├── CoreData
    │   │   │   ├── KickBoardRecordEntity+CoreDataClass.swift
    │   │   │   ├── KickBoardRecordEntity+CoreDataProperties.swift
    │   │   │   ├── UsageHistoryEntity+CoreDataClass.swift
    │   │   │   └── UsageHistoryEntity+CoreDataProperties.swift
    │   │   ├── Entity
    │   │   │   ├── KickBoardRecord.swift
    │   │   │   ├── Location.swift
    │   │   │   ├── RegistrationHistory.swift
    │   │   │   ├── SearchData.swift
    │   │   │   ├── UsageHistory.swift
    │   │   │   ├── User.swift
    │   │   │   └── ValidationResult.swift
    │   │   └── Manager
    │   │       ├── CoreDataManager.swift
    │   │       ├── UserDefaultsManager.swift
    │   │       └── UserManager.swift
    │   ├── Model.xcdatamodeld
    │   ├── Resource
    │   │   ├── Assets.xcassets
    │   │   ├── Colors.xcassets
    │   │   └── Info.plist
    │   ├── Storyboard
    │   │   └── Base.lproj
    │   │       └── LaunchScreen.storyboard
    │   ├── Utility
    │   │   ├── Extensions
    │   │   │   ├── Date+.swift
    │   │   │   ├── Int+.swift
    │   │   │   ├── KeyboardObserver+.swift
    │   │   │   ├── UIColor+.swift
    │   │   │   ├── UIFont+.swift
    │   │   │   ├── UIImage+.swift
    │   │   │   ├── UIStackView+.swift
    │   │   │   ├── UITextFieldDelegate+.swift
    │   │   │   ├── UIView+.swift
    │   │   │   └── UIViewController+.swift
    │   │   └── Literals
    │   │       ├── FontLiterals.swift
    │   │       ├── ImageLiterals.swift
    │   │       └── SizeLiterals.swift
    │   ├── View
    │   │   ├── AuthView
    │   │   │   ├── LoginView
    │   │   │   │   ├── LoginViewController.swift
    │   │   │   │   └── ViewComponents
    │   │   │   │       └── LoginView.swift
    │   │   │   └── MembershipView
    │   │   │       ├── MembershipViewController.swift
    │   │   │       └── ViewComponents
    │   │   │           └── MembershipView.swift
    │   │   ├── Common
    │   │   │   └── KakaoMapViewController.swift
    │   │   ├── KickBoardRegisterView
    │   │   │   ├── KickBoardRegisterViewController.swift
    │   │   │   └── ViewComponets
    │   │   │       ├── DeleteModelViewController.swift
    │   │   │       └── RegisterKickboardAlertViewController.swift
    │   │   ├── MainViewController.swift
    │   │   ├── MyPageView
    │   │   │   ├── HistoryView
    │   │   │   │   ├── RegistrationHistory
    │   │   │   │   │   ├── RegistrationHistoryViewController.swift
    │   │   │   │   │   └── ViewComponents
    │   │   │   │   │       ├── RegistrationHistoryTableViewCell.swift
    │   │   │   │   │       └── RegistrationHistoryView.swift
    │   │   │   │   └── UsageHistory
    │   │   │   │       ├── UsageHistoryViewController.swift
    │   │   │   │       └── ViewComponents
    │   │   │   │           ├── UsageHistoryTableViewCell.swift
    │   │   │   │           └── UsageHistoryView.swift
    │   │   │   ├── MyPageViewController.swift
    │   │   │   └── ViewComponenets
    │   │   │       ├── MyPageTableViewCell.swift
    │   │   │       └── MyPageView.swift
    │   │   └── RentView
    │   │       ├── RentViewController.swift
    │   │       └── ViewComponents
    │   │           └── RentModalViewController.swift
    │   └── ViewModel
    │       ├── KickBoardRecordViewModel.swift
    │       ├── LoginViewModel.swift
    │       ├── RentModalViewModel.swift
    │       ├── RentViewModel.swift
    │       ├── SignUpViewModel.swift
    │       └── UsageHistoryViewModel.swift
```

---

## 📁 프로젝트 구조 요약

```
TeamProject
├── App               // App 생명주기
├── Model             // CoreData, Entity, Manager
├── Resource          // Assets, Info.plist
├── Storyboard        // LaunchScreen
├── Utility           // Extensions, Literals
├── View              // 각 기능별 ViewController & View
├── ViewModel         // 화면별 ViewModel
├── APIKey.xcconfig   // API 키 관리
└── KakaoAPIKey.xcconfig
```

---

## ✨ 화면 미리보기

|                       로그인/회원가입                       |                      메인 지도                      |                           킥보드 등록                          |                          이용 이력                          |
| :-------------------------------------------------: | :---------------------------------------------: | :-------------------------------------------------------: | :-----------------------------------------------------: |
| ![login](https://github.com/user-attachments/assets/a2ebbf81-5282-4e4d-8706-163a4f47cfdb) | ![map](https://github.com/user-attachments/assets/835abf71-dd07-474e-a825-033a00583473) | ![register](https://github.com/user-attachments/assets/2a6eb363-34db-4383-87be-1fd9e5e2942f) | ![history](https://github.com/user-attachments/assets/b0b90bae-cd2d-4b98-bb3d-e7c321e79570) |
| ![login](https://github.com/user-attachments/assets/de0be642-f16d-482a-a3c4-4955c61ee8dc)
) | ![map](https://github.com/user-attachments/assets/216824f3-fb38-4d7e-bbf6-10776bb34f43) | ![register](https://github.com/user-attachments/assets/c1b2924d-1e6d-4490-a962-11a2ff81e5f7) | ![history](https://github.com/user-attachments/assets/04f311d0-d901-4f0d-ae8d-9133f3e6b1ad) |

---

## 💾 CoreData 활용

| Entity                | 주요 속성                                                                 |
| --------------------- | --------------------------------------------------------------------- |
| KickBoardRecordEntity | basicCharge, hourlyCharge, kickboardIdentifier, latitude, longitude, type, userID |
| UsageHistoryEntity    | charge, distance, finishTime, kickboardIdentifier, startTime, useDate, userID    |

* 거리 계산 시 Haversine 공식 기반 계산
* 대여 종료 시, 계산된 거리 및 소요 시간 자동 저장

---

## 📌 주요 UI 요소 및 UX 설계

| 요소                     | 설명                                    |
| ---------------------- | ------------------------------------- |
| **모듈화된 ViewComponent** | 각 화면 구성 요소를 View 내에서 별도 분리            |
| **KakaoMap 연동**        | 커스텀 마커, 대여 위치 실시간 표시                  |
| **Alert 커스터마이징**       | 킥보드 삭제 시 경고창 등 UX 고려                  |
| **폰트 & 컬러 관리**         | FontLiterals / ColorLiterals 파일 통합 관리 |
| **키보드 옵저버**         | 키보드가 올라올 때 UI가 위로 이동하고, return을 누르면 키보드가 내려감 |

---

## ✅ 주요 구현 기능 체크리스트

* [x] 회원가입 및 로그인
* [x] 지도 기반 대여 기능
* [x] 킥보드 등록 및 삭제 기능
* [x] 이용 이력 관리 및 거리 계산
* [x] 마이페이지 및 로그아웃 기능
* [x] CoreData를 통한 오프라인 데이터 저장
* [x] UI/UX 컴포넌트 분리 및 유지 보수성 향상

---

## 🧪 시연 영상

| 화면          | 링크      |
| ----------- | ------- |
| 유튜브 시연 영상     | 바로가기(https://youtu.be/kJfitA46cZU?si=fqw-tWM9eqy9pLft) |

---

## 🔗 프로젝트 문서 및 리소스

1. [노션 정리문서](https://www.notion.so/teamsparta/07-1e02dc3ef51480b0b232dec00133e751)
2. [팀 프로젝트 노션](https://www.notion.so/teamsparta/7-TJ-1d42dc3ef51480e9ada2d6cad9dfcec1)
3. [피그마 링크](https://www.figma.com/design/ohl26DfH7JOqVSkxe3CmiU/TJ%ED%8A%B9%EA%B3%B5%EB%8C%80?node-id=0-1\&p=f\&t=ezS4fR9iKBDTTqYZ-0)
4. [카카오 API 공식문서 가이드](https://apis.map.kakao.com/ios_v2/)
5. [아이콘을 가져온 구글 머터리얼 디자인](https://fonts.google.com/icons?icon.set=Material+Icons)

---
