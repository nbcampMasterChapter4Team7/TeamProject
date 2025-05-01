# TeamProject

# 프로젝트 소개 
- 킥보드 대여, 등록 및 이력 관리를 위한 iOS 애플리케이션

# 기술 스택
- Swift
- UIKit
- SnapKit
- Then
- KakaoMapSDK

# 프로젝트 구조
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
    │       └── SignUpViewModel.swift
```

# 프로젝트 주요 기능
- Auth(회원가입,로그인)
- 지도 페이지(킥보드 대여, 반납)
- 킥보드 등록 페이지(킥보드 등록,삭제)
- 마이 페이지(킥보드 이용 내역, 로그아웃)

# 시연 영상
