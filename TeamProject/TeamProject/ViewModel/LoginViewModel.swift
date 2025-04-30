//
//  LoginViewModel.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//  로그인 로직을 처리 (로그인 성공 시 UserDefaults에 아이디와 비밀번호 저장)

final class LoginViewModel {
    
    // MARK: - Properties

    func validateLogin(id: String, password: String) -> ValidationResult {
        guard let savedId = UserDefaultsManager.shared.getUserId() else {
            return .failure("등록되지 않은 아이디입니다.")
        }
        
        guard let savedPassword = UserDefaultsManager.shared.getUserPassword() else {
            return .failure("오류가 발생했습니다.")
        }
        
        if id != savedId {
            return .failure("아이디가 일치하지 않습니다.")
        }
        
        if password != savedPassword {
            return .failure("비밀번호가 일치하지 않습니다.")
        }
        
        return .success
    }
    
    func login() {
        UserDefaultsManager.shared.setLoginStatus(isLoggedIn: true)
    }
    
    // 로그인 성공 시 사용자 정보 저장 메서드 추가
    func saveUserLoginInfo(id: String, password: String) {
        if let userName = UserDefaultsManager.shared.getUserName() {
            UserDefaultsManager.shared.saveUserInfo(id: id, password: password, name: userName)
        }
        UserDefaultsManager.shared.setLoginStatus(isLoggedIn: true)
    }
}
