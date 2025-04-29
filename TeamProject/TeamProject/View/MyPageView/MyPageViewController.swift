//
//  MyPageViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController, LogoutViewControllerProtocol {
    
    // MARK: - UI Components
    private var mypageView = MyPageView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        logoutViewDelegate()
    }
    
    // MARK: - Layout Helper
    private func setupUI() {
        view.addSubviews(mypageView)
        mypageView.snp.makeConstraints { $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    /// 화면 전환을 위한 델리게이트 설정
    private func logoutViewDelegate() {
        mypageView.delegate = self
    }
    
    // MARK: - Actions
    func logoutButtonTapped() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
