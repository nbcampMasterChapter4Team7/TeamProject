//
//  ViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit
import Then
import SnapKit

<<<<<<< HEAD
protocol SignUpProtocol: AnyObject {
    func signUpButtonTapped()
}

=======
>>>>>>> origin/feat/#5
final class LoginViewController: UIViewController {
    private var loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        addKeyboardObserver() // 키보드 확장 옵저버 사용
        setupNavigationBar()
<<<<<<< HEAD
        loginViewDelegate()
    }
    
    func loginViewDelegate() {
        loginView.delegate = self // 델리게이트 설정
=======
>>>>>>> origin/feat/#5
    }

    func setupLoginView() {
        view.addSubview(loginView)
            
        loginView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // memebershipView의 네비게이션 뒤로가기 타이틀 없애기
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
<<<<<<< HEAD
    @objc private func navigateToMembershipViewController() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: true)
    }
    
=======
>>>>>>> origin/feat/#5
    // 키보드 확장 옵저버 종료
    deinit {
        removeKeyboardObserver()
    }
<<<<<<< HEAD
}

extension LoginViewController: SignUpProtocol {
    func signUpButtonTapped() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: false)
    }
}
=======
    
    
}
>>>>>>> origin/feat/#5
