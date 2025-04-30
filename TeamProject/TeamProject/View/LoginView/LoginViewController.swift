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
            guard let id = loginView.getId() else { return }
            UserManager.shared.save(user: User(id: id))
            loginVM.saveUserLoginInfo(id: id, password: password) //로그인 시 사용자 정보 저장
            loginVM.login()
            navigateToMain()
        case .failure(let message):
            showAlert(title: "알림", message: message)
        }
    }
    
    private func navigateToMain() {
        let mainVC = MainViewController()
        // 네비게이션 스택을 초기화하고 메인화면을 루트로 설정
        navigationController?.setViewControllers([mainVC], animated: true)
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
