//
//  SceneDelegate.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        _ = LoginViewController()
        
        
        // UserDefaults에서 로그인 상태 확인
        let isLoggedIn = UserDefaultsManager.shared.defaults.bool(forKey: UserDefaultsManager.Keys.isLoggedIn)
        
        if isLoggedIn {
            //id 가져오는 메서드
            if let id = UserDefaultsManager.shared.getUserId() {
                UserManager.shared.save(user: User(id: id)) // UserManager에 현재 사용자 정보 저장
                
                // 로그인된 상태면 MainVC로 이동
                let mainVC = MainViewController()
                let navigationController = UINavigationController(rootViewController: mainVC)
                window?.rootViewController = navigationController
            }
        } else {
            // 로그인되지 않은 상태면 LoginVC로 이동
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

