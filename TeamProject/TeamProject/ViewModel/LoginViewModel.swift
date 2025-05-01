//
//  LoginViewModel.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//  로그인 로직을 처리 (로그인 성공 시 UserDefaults에 아이디와 비밀번호 저장)

final class LoginViewModel {
    
    // MARK: - Properties
    
    func validateLogin(id: String, password: String) -> ValidationResult {
        let users = UserDefaultsManager.shared.getAllUsers()
        
        guard let user = users.first(where: { $0.id == id }) else {
            return .failure("등록되지 않은 아이디입니다.")
        }
        
        if password != user.password {
            return .failure("비밀번호가 일치하지 않습니다.")
        }
        
        // 로그인 성공 시 현재 사용자 ID 설정
        UserDefaultsManager.shared.setCurrentUserId(id)
        return .success
    }
    
    func login() {
        UserDefaultsManager.shared.setLoginStatus(isLoggedIn: true)
    }
    
    // 로그인 성공 시 사용자 정보 저장 메서드 추가
    func saveUserLoginInfo(id: String, password: String) {
        if let userName = UserDefaultsManager.shared.getUserName() {
            // 기존 사용자 정보를 유지하면서 현재 로그인 정보 업데이트
            UserDefaultsManager.shared.saveUserInfo(id: id, password: password, name: userName)
        }
        UserDefaultsManager.shared.setLoginStatus(isLoggedIn: true)
    }
}
