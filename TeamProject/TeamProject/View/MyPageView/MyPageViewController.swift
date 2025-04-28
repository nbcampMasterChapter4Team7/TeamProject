//
//  MyPageViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit

class MyPageViewController: UIViewController, LogoutViewControllerProtocol {
    
    private var mypageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        logoutViewDelegate()
    }
    
    private func setupUI() {
        view.addSubviews(mypageView)
        mypageView.snp.makeConstraints { $0.edges.equalToSuperview()
        }
    }
    
    /// 화면 전환을 위한 델리게이트 설정
    private func logoutViewDelegate() {
        mypageView.delegate = self
    }
    
    func logoutButtonTapped() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
