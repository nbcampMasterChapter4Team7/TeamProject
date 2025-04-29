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
    
    // MARK: - Properties
    static let id = "TableViewCell"
    weak var delegate: LogoutViewControllerProtocol?
    weak var cellDelegate: MyPageTableViewCellProtocol?  // 추가
    
    // MARK: - UI Components
    private let userNameLabel = UILabel().then {
        $0.text = "Test님"
        $0.font = UIFont.fontGuide(.MyPageUserName)
        $0.textColor = .label
        $0.textAlignment = .left
    }
    
    private let logoutButton = UIButton().then {
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
        $0.rowHeight = UITableView.automaticDimension  /// 고정값 대신 자동
        $0.estimatedRowHeight = 110 /// 대략적인 예상 높이
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.tableFooterView = UIView()
    }
    
    private let rentalButtonLabel = UIButton().then {
        $0.setTitle("킥보드 대여중", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.systemMint
        $0.titleLabel?.font = UIFont.fontGuide(.MyPageRentalButtonText)
        $0.layer.cornerRadius = 5
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tableViewDelegate()
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Helper
    private func setup() {
        backgroundColor = .systemBackground
        addSubviews(userNameLabel, logoutButton, tableView, rentalButtonLabel)
        
        /// 레이아웃 설정
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().inset(35)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel)
            make.trailing.equalToSuperview().inset(35)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(35)
            make.bottom.equalTo(rentalButtonLabel.snp.top).offset(-20)
        }
        
        rentalButtonLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(35)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - @objc Methods
    @objc private func logoutButtonTapped() {
        delegate?.logoutButtonTapped()
    }

    // MARK: - Methods
    private func tableViewDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /// 테이블뷰 데이터소스 및 델리게이트 메서드 구현
    func numberOfSections(in tableView: UITableView) -> Int {
        return MyPageTableViewCell.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 /// 한 섹션당 하나의 셀 (타이틀 + 여러 디테일)
    }
    
    /// 마지막 섹션일 때만 footer 높이를 0이 아니라 1로 만들어서 separator를 숨기기
    /// 섹션 푸터 높이 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == MyPageTableViewCell.data.count - 1 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.id, for: indexPath) as! MyPageTableViewCell
        let titleText = MyPageTableViewCell.data[indexPath.section].title
        let detailTexts = MyPageTableViewCell.data[indexPath.section].details
        cell.configure(with: titleText, details: detailTexts)
        cell.delegate = cellDelegate  // cellDelegate 설정
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected section: \(indexPath.section)")
    }
}
