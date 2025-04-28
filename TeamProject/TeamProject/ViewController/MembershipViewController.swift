//
//  MembershipViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit
import SnapKit

class MembershipViewController: UIViewController {
    private var membershipView = MembershipView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver() // 키보드 확장 옵저버 사용
        setupNavigationBar()
        setupMembershipView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "회원가입"
    }
    
    private func setupMembershipView() {
        view.addSubview(membershipView)
        
        membershipView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // 키보드 확장 옵저버 종료
    deinit {
        removeKeyboardObserver()
    }
}
