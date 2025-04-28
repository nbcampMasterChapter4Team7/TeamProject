//
//  MyPageTableViewCell.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit
import SnapKit

final class MyPageTableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    // 데이터 구성: 섹션별로 데이터를 배열로 관리
    static let data: [(title: String, details: [String])] = [
        ("이용 내역", ["전체 이용 내역 보기"]),
        ("등록한 킥보드", ["전체 등록 내역 보기"])
    ]

    private let titleLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.MyPageRegistrationKickboardLabel)
        $0.textColor = .secondaryLabel
    }
    
    private let detailLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.MyPageTotalRegistrationKickboardLabel)
        $0.textColor = .label
    }

    private let arrowButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.setTitleColor(.systemBackground, for: .normal)
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        selectionStyle = .none  // 선택 시 스타일을 없애기
    }

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(arrowButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalTo(arrowButton.snp.leading)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        arrowButton.snp.makeConstraints {make in
            make.centerY.equalTo(detailLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}
