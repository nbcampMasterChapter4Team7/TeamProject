//
//  ViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

import SnapKit
import Then

final class ViewController: UITabBarController {

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
        bottomTabBar.stackedLayoutAppearance.configureWithDefault(for: .inline)
        bottomTabBar.stackedLayoutAppearance.normal.titleTextAttributes = [.font: font]
        bottomTabBar.stackedLayoutAppearance.selected.titleTextAttributes = [.font: font]
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
            createViewController(for: KickBoardRegisterViewController(), title: "킥보드 등록")
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
        navigationController.navigationBar.isTranslucent = false
        navigationController.tabBarItem.title = title
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        return navigationController
    }
}
