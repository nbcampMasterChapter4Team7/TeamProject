//
//  MyPageViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController, LogoutViewControllerProtocol, MyPageTableViewCellProtocol {
    
    // MARK: - Properties
    
    private var mypageView = MyPageView()
    private var mypageTableViewCell = MyPageTableViewCell()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMyPageView()
        setupDelegates()
        setupNavigationBar()
        updateUserName()
    }
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserName()
        mypageView.configure()
    }
    
    // MARK: - Layout Helper
    
    private func setupMyPageView() {
        view.addSubviews(mypageView)
        mypageView.snp.makeConstraints { $0.edges.equalToSuperview()
        }
    }
    
    /// 네비게이션 뒤로가기 타이틀 없애기
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - Methods
    
    /// 화면 전환을 위한 델리게이트 설정
    private func setupDelegates() {
        mypageView.delegate = self
        mypageView.cellDelegate = self
    }
    
    // userName 업데이트 메서드
    private func updateUserName() {
        if let userName = UserDefaultsManager.shared.getUserName() {
            mypageView.setUserName(userName)
        }
    }
    
    // MyPageViewController.swift
    func logoutButtonTapped() {
        let alert = UIAlertController(title: "로그아웃",
                                     message: "로그아웃 하시겠습니까?",
                                     preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
            // UserDefaults 로그인 상태만 초기화
            UserDefaultsManager.shared.logout()
            
            // 로그인 화면으로 이동
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            navigationController.modalPresentationStyle = .fullScreen
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navigationController
                UIView.transition(with: window,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: nil,
                                completion: nil)
            }
        })
        
        present(alert, animated: true)
    }


    
    func usageHistoryButtonTapped() {
        let usageHistoryVC = UsageHistoryViewController()
        navigationController?.pushViewController(usageHistoryVC, animated: true)
    }
    
    func registrationHistoryButtonTapped() {
        let registrationHistoryVC = RegistrationHistoryViewController()
        navigationController?.pushViewController(registrationHistoryVC, animated: true)
    }
}
