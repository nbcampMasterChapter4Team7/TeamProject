//
//  MyPageViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController, LogoutViewControllerProtocol, MyPageTableViewCellProtocol {
    
    // MARK: - UI Components
    private var mypageView = MyPageView()
    private var mypageTableViewCell = MyPageTableViewCell()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMyPageView()
        setupDelegates()
        setupNavigationBar()
    }
    
    // MARK: - Layout Helper
    private func setupMyPageView() {
        view.addSubviews(mypageView)
        mypageView.snp.makeConstraints { $0.edges.equalToSuperview()
        }
    }
    
    /// 네비게이션 뒤로가기 타이틀 없애기
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - Methods
    /// 화면 전환을 위한 델리게이트 설정
    private func setupDelegates() {
        mypageView.delegate = self
        mypageView.cellDelegate = self  // cellDelegate 설정
    }
    
    // MARK: - Actions
    func logoutButtonTapped() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    func usageHistoryButtonTapped() {
        let usageHistoryVC = UsageHistoryViewController()
        navigationController?.pushViewController(usageHistoryVC, animated: true)
    }
    
    func registrationHistoryButtonTapped() {
        let registrationHistoryVC = RegistrationHistoryViewController()
        navigationController?.pushViewController(registrationHistoryVC, animated: true)
    }
}
