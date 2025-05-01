//
//  MembershipViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class MembershipViewController: UIViewController {
    
    // MARK: - Properties
    private var membershipView = MembershipView()
    private let signUpVm = SignUpViewModel()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        setupNavigationBar()
        setupMembershipView()
        setupActions()
    }
    
    // MARK: - Methods
    private func setupNavigationBar() {
        navigationItem.title = "회원가입"
    }
    
    private func setupMembershipView() {
        view.addSubview(membershipView)
        membershipView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupActions() {
        membershipView.signUpButton.addTarget(
            self,
            action: #selector(signUpButtonTapped),
            for: .touchUpInside
        )
    }
    
    
    // MARK: - Actions
    @objc private func signUpButtonTapped() {
        guard let nickname = membershipView.nicknameTextField.text,
              let id = membershipView.idTextField.text,
              let password = membershipView.passwordTextField.text else { return }
        
        // 입력값 검증
        switch signUpVm.validateSignUp(id: id, password: password, name: nickname) {
        case .success:
            showSignUpConfirmAlert(id: id, password: password, nickname: nickname)
        case .failure(let message):
            showAlert(title: "알림", message: message)
        }
    }
    
    private func showSignUpConfirmAlert(id: String, password: String, nickname: String) {
        let alert = UIAlertController(
            title: "회원가입",
            message: "회원가입을 하시겠습니까?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.performSignUp(id: id, password: password, nickname: nickname)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    private func performSignUp(id: String, password: String, nickname: String) {
        signUpVm.signUp(id: id, password: password, name: nickname) { [weak self] success in
            if success {
                self?.showAlert(
                    title: "성공",
                    message: "회원가입이 완료되었습니다."
                ) { [weak self] _ in
                    // 로그인 화면으로 돌아가기
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                self?.showAlert(
                    title: "오류",
                    message: "회원가입에 실패했습니다."
                )
            }
        }
    }
    
    // MARK: - Actions
    deinit {
        removeKeyboardObserver()
    }
}
