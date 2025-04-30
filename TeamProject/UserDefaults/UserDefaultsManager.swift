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
        static let users = "users" // 사용자 정보 배열을 저장할 키
        static let currentUserId = "currentUserId" // 현재 로그인한 사용자의 ID
        static let isLoggedIn = "isLoggedIn"
        static let isRent = "isRent"
        static let kickboardID = "kickboardID"
    }

    // 사용자 정보를 저장하는 구조체
    struct UserInfo: Codable {
        let id: String
        let password: String
        let name: String
    }

    // MARK: - Methods

    func saveUserInfo(id: String, password: String, name: String) {
        var users = getAllUsers()
        let newUser = UserInfo(id: id, password: password, name: name)

        // 기존 사용자가 있다면 업데이트, 없다면 추가
        if let index = users.firstIndex(where: { $0.id == id }) {
            users[index] = newUser
        } else {
            users.append(newUser)
        }

        if let encoded = try? JSONEncoder().encode(users) {
            defaults.set(encoded, forKey: Keys.users)
        }

    }

    func setLoginStatus(isLoggedIn: Bool) {
        defaults.set(isLoggedIn, forKey: Keys.isLoggedIn)
    }


    // 모든 사용자 정보 가져오기
    func getAllUsers() -> [UserInfo] {
        guard let data = defaults.data(forKey: Keys.users),
            let users = try? JSONDecoder().decode([UserInfo].self, from: data) else {
            return []
        }
        return users
    }

    func setRentStatus(isRent: Bool) {
        defaults.set(isRent, forKey: Keys.isRent)
        NotificationCenter.default.post(name: Notification.Name("rentStatusChanged"), object: nil)
    }

    func saveKickboardID(kickboardID: String) {
        defaults.set(kickboardID, forKey: Keys.kickboardID)

    }

    /// 조회 메서드들
    //현재 로그인한 사용자 정보 가져오기
    func getCurrentUser() -> UserInfo? {
        guard let id = defaults.string(forKey: Keys.currentUserId) else { return nil }
        return getUser(id: id)
    }

    // 특정 ID의 사용자 정보 가져오기
    func getUser(id: String) -> UserInfo? {
        return getAllUsers().first(where: { $0.id == id })
    }

    // 현재 로그인한 사용자 ID 설정
    func setCurrentUserId(_ id: String) {
        defaults.set(id, forKey: Keys.currentUserId)
    }

    // 로그인 상태 확인
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

    // TODO: getUser(id:) - getAllUsers().first(where:)로 직접 사용하도록 나중에 리팩토링하기
    // 기존 메서드들의 대체 구현
    func getUserId() -> String? {
        return getCurrentUser()?.id
    }

    func getUserPassword() -> String? {
        return getCurrentUser()?.password
    }

    func getUserName() -> String? {
        return getCurrentUser()?.name
    }
}


