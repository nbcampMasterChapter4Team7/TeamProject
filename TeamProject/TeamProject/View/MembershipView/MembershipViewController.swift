//
//  MembershipViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit
import Then

class MembershipViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var membershipView = MembershipView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        setupNavigationBar()
        setupMembershipView()
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        navigationItem.title = "회원가입"
    }
    
    private func setupMembershipView() {
        view.addSubview(membershipView)
        membershipView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - Actions
    
    // 키보드 확장 옵저버 종료
    deinit {
        removeKeyboardObserver()
    }
}
