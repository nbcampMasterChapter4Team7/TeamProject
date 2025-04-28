//
//  MyPageView.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class MyPageView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    static let id = "TableViewCell"
    weak var delegate: LogoutViewControllerProtocol?
    
    let userNameLabel = UILabel().then {
        $0.text = "Test님"
        $0.font = UIFont.fontGuide(.MyPageUserName)
        $0.textColor = .label
        $0.textAlignment = .left
    }
    
    let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.backgroundColor = UIColor.asset(.gray1)
        $0.titleLabel?.font = UIFont.fontGuide(.MyPageLogoutButton)
        $0.layer.cornerRadius = 10
        $0.tintColor = .white
    }
    
    let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.id)
        $0.isScrollEnabled = false
        $0.rowHeight = 110
    }
    
    private let rentalButtonLabel = UIButton().then {
        $0.setTitle("킥보드 대여중", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.systemMint
        $0.titleLabel?.font = UIFont.fontGuide(.MyPageRentalButtonText)
        $0.layer.cornerRadius = 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        // 테이블뷰의 데이터소스와 델리게이트 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        addSubviews(userNameLabel, logoutButton, tableView, rentalButtonLabel)
        
        // 레이아웃 설정
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(35)
            make.leading.equalToSuperview().inset(35)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel)
            make.trailing.equalToSuperview().inset(35)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(35)
            make.bottom.equalTo(rentalButtonLabel.snp.top).offset(-20)
        }
        
        rentalButtonLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(35)
            make.height.equalTo(50)
        }
    }
    
    @objc private func logoutButtonTapped() {
        delegate?.logoutButtonTapped()
    }
    
    // 테이블뷰 데이터소스 및 델리게이트 메서드 구현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageTableViewCell.data[section].details.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MyPageTableViewCell.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.id, for: indexPath) as! MyPageTableViewCell
        let titleText = MyPageTableViewCell.data[indexPath.section].title
        let detailText = MyPageTableViewCell.data[indexPath.section].details[indexPath.row]
        cell.configure(with: titleText, detail: detailText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected section: \(indexPath.section), row: \(indexPath.row)")
        // 선택된 셀에 대한 액션을 수행
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
