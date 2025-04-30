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
        
        print("ID:", UserDefaults.standard.string(forKey: "userId") ?? "없음")
        print("비밀번호:", UserDefaults.standard.string(forKey: "userPassword") ?? "없음")
        print("이름:", UserDefaults.standard.string(forKey: "userName") ?? "없음")
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
    
    private func setupAutoFill() {
        // 자동 입력 설정
        if let savedId = UserDefaultsManager.shared.getUserId() {
            loginView.setId(savedId)
        }
    }
    
    func loginButtonTapped() {
        guard let id = loginView.getId(),
              let password = loginView.getPassword() else { return }
        
        switch loginVM.validateLogin(id: id, password: password) {
        case .success:
            loginVM.login()
            navigateToMain()
        case .failure(let message):
            showAlert(message: message)
        }
    }
    
    // 로그인 성공 시 호출되는 메서드
    func loginSuccess() {
        guard let id = loginView.getId(),
              let password = loginView.getPassword() else { return }
        
        // UserDefaults에서 저장된 이름 가져오기
        if let userName = UserDefaultsManager.shared.getUserName() {
            // UserDefaults에 사용자 정보 저장
            UserDefaultsManager.shared.saveUserInfo(id: id, password: password, name: userName)
            UserDefaultsManager.shared.setLoginStatus(isLoggedIn: true)
            
            // MainVC로 이동
            let mainVC = MainViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
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
        }
    }

    
    private func navigateToMain() {
        let mainVC = MainViewController()
        // 네비게이션 스택을 초기화하고 메인화면을 루트로 설정
        navigationController?.setViewControllers([mainVC], animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
