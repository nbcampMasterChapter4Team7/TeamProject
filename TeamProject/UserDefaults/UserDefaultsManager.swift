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
    let defaults = UserDefaults.standard
    
    // UserDefaults 키 값들
    enum Keys {
        static let userId = "userId"
        static let userPassword = "userPassword"
        static let userName = "userName"
        static let isLoggedIn = "isLoggedIn"
        static let isRent = "isRent"
        static let kickboardID = "kickboardID"
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
    
    func setRentStatus(isRent: Bool) {
        defaults.set(isRent, forKey: Keys.isRent)
    }
    
    func saveKickboardID(kickboardID: UUID) {
        defaults.set(kickboardID.uuidString, forKey: Keys.kickboardID)
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
    
    func isRent() -> Bool {
        return defaults.bool(forKey: Keys.isRent)
    }
    
    func getKickboardID() -> String? {
        return defaults.string(forKey: Keys.kickboardID)
    }
    
    /// 로그아웃 메서드
    func logout() {
        defaults.set(false, forKey: Keys.isLoggedIn)
    }
}

