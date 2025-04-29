//
//  SignUpViewModel.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//  사용자 입력 검증 및 회원가입 로직 처리

final class SignUpViewModel {
    // 입력값 검증
    func validateSignUp(id: String, password: String, name: String) -> ValidationResult {
        // ID 검증
        guard !id.isEmpty else {
            return .failure("아이디를 입력해주세요.")
        }
        
        // 기존 ID 중복 체크
        if UserDefaultsManager.shared.getUserId() == id {
            return .failure("이미 사용 중인 아이디입니다.")
        }
        
        // 비밀번호 검증
        guard !password.isEmpty else {
            return .failure("비밀번호를 입력해주세요.")
        }
        
        // 이름 검증
        guard !name.isEmpty else {
            return .failure("이름을 입력해주세요.")
        }
        
        return .success
    }
    
    // 회원가입 처리
    func signUp(id: String, password: String, name: String, completion: @escaping (Bool) -> Void) {
        UserDefaultsManager.shared.saveUserInfo(id: id, password: password, name: name)
        completion(true)
    }
}

enum ValidationResult {
    case success
    case failure(String)
}
