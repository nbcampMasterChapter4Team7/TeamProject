//
//  MembershipView.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class MembershipView: UIView, UITextFieldDelegate {
    
    // MARK: - UI Components
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .label
        $0.font = UIFont.fontGuide(.SignUpNickName)
    }
    
    let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력하세요"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = UIColor.asset(.gray4)
        $0.font = UIFont.fontGuide(.LoginPlaceholder)
    }
    
    let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont.fontGuide(.SignUpID)
    }
    
    let idTextField = UITextField().then {
        $0.placeholder = "아이디를 입력하세요"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = UIColor.asset(.gray4)
        $0.font = UIFont.fontGuide(.LoginPlaceholder)
    }
    
    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont.fontGuide(.SignUpPassword)
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력하세요"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = UIColor.asset(.gray4)
        $0.font = UIFont.fontGuide(.LoginPlaceholder)
        $0.isSecureTextEntry = true
    }
    
    let signUpButton = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.asset(.main)
        $0.titleLabel?.font = UIFont.fontGuide(.SignUpButtonText)
        $0.layer.cornerRadius = 5
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setup()
        textFieldSetupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private func setup() {
        self.addSubviews(nicknameLabel, nicknameTextField, idLabel, idTextField, passwordLabel, passwordTextField, signUpButton)
        setLayout()
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(220)
            make.leading.equalToSuperview().inset(40)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(45)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(40)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(45)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(45)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Methods
    
    private func textFieldSetupDelegate() {
        nicknameTextField.delegate = self
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    /// 확장을 사용하여 영어, 숫자, 특수문자만 입력 가능하도록 바꿈
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        
        if textField == nicknameTextField {
            return newLength <= 10
        } else if textField == idTextField {
            let allowCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
            if string.rangeOfCharacter(from: allowCharacters.inverted) != nil || newLength > 12 {
                return false
            }
        } else if textField == passwordTextField {
            let allowCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;':\",.<>/?`~")
            if string.rangeOfCharacter(from: allowCharacters.inverted) != nil || newLength > 18 {
                return false
            }
        }
        return true
    }
    
    /// 리턴 키 눌렀을 때 키보드 내리기
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
