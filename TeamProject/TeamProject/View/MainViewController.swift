//
//  MainViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

import SnapKit
import Then

final class MainViewController: UITabBarController {
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTabBar()
        setAttribute()
    }
    
    // MARK: - SetTabBar
    
    private func setTabBar() {
        let font = UIFont.fontGuide(.TabBarTitle)
        let bottomTabBar = UITabBarAppearance()
        
        bottomTabBar.configureWithOpaqueBackground()
        
        let tabItem = bottomTabBar.stackedLayoutAppearance
        
        tabItem.configureWithDefault(for: .inline)
        tabItem.normal.titleTextAttributes = [.font: font]
        tabItem.selected.titleTextAttributes = [.font: font]
        
        let offset = UIOffset(horizontal: 0, vertical: -6)
        tabItem.normal.titlePositionAdjustment = offset
        tabItem.selected.titlePositionAdjustment = offset
        
        tabBar.standardAppearance = bottomTabBar
        tabBar.tintColor = UIColor.asset(.main)
        tabBar.backgroundColor = .systemBackground
    }
    
    // MARK: - SetAttribute
    /// 탭바에 들어갈 ViewController호출
    /// 밑에 있는 create [ViewController | NavigationController] 로 생성
    
    private func setAttribute() {
        viewControllers = [
            createViewController(for: RentViewController(), title: "대여"),
            createViewController(for: KickBoardRegisterViewController(), title: "킥보드 등록"),
            createNavigationController(for: MyPageViewController(), title: "마이페이지")
            
        ]
    }
    
    // UIViewController 생성
    private func createViewController(for vc: UIViewController, title: String?) -> UIViewController {
        vc.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
        return vc
    }
    
    // Navigation이 포함된 UIViewController 생성
    private func createNavigationController(for vc: UIViewController, title: String?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: vc)

        // iOS 15 이상 appearance 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        // 네비게이션바 밑의 선 제거
        appearance.shadowImage = nil  // 이 줄 추가
        appearance.shadowColor = .clear  // nil 대신 .clear 사용
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.compactScrollEdgeAppearance = appearance

        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.view.backgroundColor = .systemBackground  // 이 줄 추가
        navigationController.tabBarItem.title = title
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        return navigationController
    }
}
