//
//  LoginViewCont.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

//
//  ViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit
import Then
import SnapKit

protocol SignUpProtocol: AnyObject {
    func signUpButtonTapped()
}

final class LoginViewController: UIViewController {
    private var loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        addKeyboardObserver()
        setupNavigationBar()
        loginViewDelegate()
    }
    
    // MARK: 화면 전환을 위한 델리게이트 설정
    func loginViewDelegate() {
        loginView.delegate = self
    }
    
    func setupLoginView() {
        view.addSubview(loginView)
        
        loginView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: memebershipView의 네비게이션 뒤로가기 타이틀 없애기
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func navigateToMembershipViewController() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: true)
    }
    
    // MARK: 키보드 확장 옵저버 종료
    deinit {
        removeKeyboardObserver()
    }
}

extension LoginViewController: SignUpProtocol {
    func signUpButtonTapped() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: false)
    }
}
