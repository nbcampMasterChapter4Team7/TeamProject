//
//  UserDefaultsManager.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//

import Foundation

final class UserDefaultsManager {
    
    // MARK: - Properties
    
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    // UserDefaults 키 값들
    private enum Keys {
        static let userId = "userId"
        static let userPassword = "userPassword"
        static let userName = "userName"
        static let isLoggedIn = "isLoggedIn"
    }
    
    // MARK: - Methods
    
    func saveUserInfo(id: String, password: String, name: String) {
        defaults.set(id, forKey: Keys.userId)
        defaults.set(password, forKey: Keys.userPassword)
        defaults.set(name, forKey: Keys.userName)
    }
    
    func setLoginStatus(isLoggedIn: Bool) {
        defaults.set(isLoggedIn, forKey: Keys.isLoggedIn)
    }
    
    /// 조회 메서드들
    func getUserId() -> String? {
        return defaults.string(forKey: Keys.userId)
    }
    
    func getUserPassword() -> String? {
        return defaults.string(forKey: Keys.userPassword)
    }
    
    func getUserName() -> String? {
        return defaults.string(forKey: Keys.userName)
    }
    
    func isLoggedIn() -> Bool {
        return defaults.bool(forKey: Keys.isLoggedIn)
    }
    
    /// 로그아웃 메서드
    func logout() {
        // 로그인 상태만 초기화하고 저장된 정보(userId, password)는 유지
        defaults.set(false, forKey: Keys.isLoggedIn)
        defaults.removeObject(forKey: Keys.userName)
    }
}

