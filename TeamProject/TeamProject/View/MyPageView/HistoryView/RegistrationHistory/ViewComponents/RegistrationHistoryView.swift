//
//  RegistrationHistoryView.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//

import UIKit

import SnapKit
import Then

final class RegistrationHistoryView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    private var registrationHistories: [RegistrationHistory] = []
    
    // MARK: - UI Components
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(RegistrationHistoryTableViewCell.self, forCellReuseIdentifier: RegistrationHistoryTableViewCell.RegistrationHistoryCellid)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setLayout()
        tableViewDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Helper
    
    private func setup() {
        backgroundColor = .systemBackground
        addSubviews(tableView)
    }
    
    private func setLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // MARK: - Methods

    private func tableViewDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /// 데이터 업데이트 메서드 추가
    func updateData(_ histories: [RegistrationHistory]) {
        self.registrationHistories = histories.reversed()
        tableView.reloadData()
    }
    
    /// 테이블뷰의 각 섹션의 헤더 높이를 설정 (헤더 높이 0으로 설정)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    ///푸터에 특별한 내용을 표시하지 않고 단순히 간격을 주기 위한 용도로 사용
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    /// 푸터의 높이를 20포인트로 설정 (셀 간의 간격)
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    /// numberOfSections 메서드 추가
    func numberOfSections(in tableView: UITableView) -> Int {
        return registrationHistories.count
    }
    
    /// numberOfRowsInSection 수정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 /// 각 섹션당 1개의 셀만 표시
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationHistoryTableViewCell.RegistrationHistoryCellid, for: indexPath) as? RegistrationHistoryTableViewCell else {
            return UITableViewCell()
        }
        /// 실제 데이터로 구성할 때 다음과 같이 구성
        let history = registrationHistories[indexPath.section]
        cell.configure(with: history)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
