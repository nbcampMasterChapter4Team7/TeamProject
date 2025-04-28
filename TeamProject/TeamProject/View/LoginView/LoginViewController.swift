//
//  LoginViewCont.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit
import Then

protocol SignUpProtocol: AnyObject {
    func signUpButtonTapped()
}

final class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var loginView = LoginView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        addKeyboardObserver()
        setupNavigationBar()
        loginViewDelegate()
    }
    
    // MARK: - Methods
    
    /// 화면 전환을 위한 델리게이트 설정
    private func loginViewDelegate() {
        loginView.delegate = self
    }
    
    /// loginView의 화면 제약
    private func setupLoginView() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    /// memebershipView의 네비게이션 뒤로가기 타이틀 없애기
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - @objc Methods
    
    @objc private func navigateToMembershipViewController() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: true)
    }
    
    // MARK: - Actions
    
    // 키보드 확장 옵저버 종료
    deinit {
        removeKeyboardObserver()
    }
}

// MARK: - SignUpProtocol

extension LoginViewController: SignUpProtocol {
    func signUpButtonTapped() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: false)
    }
}
