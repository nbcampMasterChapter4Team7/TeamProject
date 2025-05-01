//
//  LoginViewCont.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class LoginViewController: UIViewController,LoginViewContollerProtocol {
    
    // MARK: - UI Components
    
    private var loginView = LoginView()
    private var loginVM = LoginViewModel()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        addKeyboardObserver()
        setupNavigationBar()
        loginViewDelegate()
        setupAutoFill()
        
        // 저장된 모든 사용자 정보 출력
        let allUsers = UserDefaultsManager.shared.getAllUsers()
        print("\n=== 저장된 모든 사용자 정보 ===")
        allUsers.forEach { user in
            print("ID: \(user.id)")
            print("비밀번호: \(user.password)")
            print("이름: \(user.name)")
            print("------------------------")
        }
        
        // 현재 로그인된 사용자 정보 출력
        print("\n=== 현재 로그인된 사용자 정보 ===")
        if let currentUser = UserDefaultsManager.shared.getCurrentUser() {
            print("현재 로그인된 ID: \(currentUser.id)")
            print("현재 로그인된 사용자 비밀번호: \(currentUser.password)")
            print("현재 로그인된 사용자 이름: \(currentUser.name)")
        } else {
            print("현재 로그인된 사용자 없음")
        }
        print("로그인 상태: \(UserDefaultsManager.shared.isLoggedIn())")
        print("===========================\n")
    }
    
    // MARK: - Methods
    
    /// loginView의 화면 제약
    private func setupLoginView() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    /// memebershipView의 네비게이션 뒤로가기 타이틀 없애기
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
    /// 화면 전환을 위한 델리게이트 설정
    private func loginViewDelegate() {
        loginView.delegate = self
    }
    
    /// 자동 입력 설정
    private func setupAutoFill() {
        if let savedId = UserDefaultsManager.shared.getUserId() {
            loginView.setId(savedId)
        }
        
        if let savedPassword = UserDefaultsManager.shared.getUserPassword() {
            loginView.setPassword(savedPassword)
        }
    }
    
    func loginButtonTapped() {
        guard let id = loginView.getId(),
              let password = loginView.getPassword() else { return }
        
        switch loginVM.validateLogin(id: id, password: password) {
        case .success:
            UserManager.shared.save(user: User(id: id))
            loginVM.saveUserLoginInfo(id: id, password: password) //로그인 시 사용자 정보 저장
            loginVM.login()
            navigateToMain()
        case .failure(let message):
            showAlert(title: "알림", message: message)
        }
    }
    
    // 로그인 후 완전히 새로운 시작점을 만들어 네비게이션 컨트롤러 중첩 문제를 해결
    private func navigateToMain() {
        let mainVC = MainViewController()
        if let window = view.window {
            window.rootViewController = mainVC
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    func signUpButtonTapped() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: true)
    }
    
    // MARK: - @objc Methods
    
    @objc private func navigateToMembershipViewController() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: true)
    }
    
    // MARK: - Actions
    
    /// 키보드 확장 옵저버 종료
    deinit {
        removeKeyboardObserver()
    }
}
