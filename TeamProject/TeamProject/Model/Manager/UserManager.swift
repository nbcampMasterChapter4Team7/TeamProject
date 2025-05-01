//
//  UserManager.swift
//  TeamProject
//
//  Created by tlswo on 4/30/25.
//

class UserManager {
    // MARK: - Singleton
    static let shared = UserManager()
    private init() {}

    // MARK: - Properties
    private var currentUser: User?

    // MARK: - Methods
    func save(user: User) {
        self.currentUser = user
    }

    func getUser() -> User? {
        return currentUser
    }
}
