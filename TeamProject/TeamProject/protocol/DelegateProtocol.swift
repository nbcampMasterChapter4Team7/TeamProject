//
//  DelegateProtocol.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

protocol LoginViewContollerProtocol: AnyObject {
    func signUpButtonTapped()
    func loginButtonTapped()
}

protocol LogoutViewControllerProtocol: AnyObject {
    func logoutButtonTapped()
}

protocol MyPageTableViewCellProtocol: AnyObject {
    func registrationHistoryButtonTapped()
    func usageHistoryButtonTapped()
}
