//
//  ViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit
import Then
import SnapKit

final class LoginViewController: UIViewController {
    private var loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        addKeyboardObserver() // 키보드 확장 옵저버 사용
        setupNavigationBar()
    }

    func setupLoginView() {
        view.addSubview(loginView)
            
        loginView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // memebershipView의 네비게이션 뒤로가기 타이틀 없애기
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
    // 키보드 확장 옵저버 종료
    deinit {
        removeKeyboardObserver()
    }
    
    
}
