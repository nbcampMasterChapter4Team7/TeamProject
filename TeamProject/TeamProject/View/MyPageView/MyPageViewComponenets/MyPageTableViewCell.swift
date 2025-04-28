//
//  MyPageTableViewCell.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class MyPageTableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    static let data: [(title: String, details: [String])] = [
        ("이용 내역", ["전체 이용 내역 보기"]),
        ("등록한 킥보드", ["전체 등록 내역 보기"]),
        ("고객센터", ["자주 묻는 질문", "1:1 문의하기", "공지사항"])
    ]

    private let titleLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.MyPageRegistrationKickboardLabel)
        $0.textColor = .secondaryLabel
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }

    private let arrowButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.setTitleColor(.systemBackground, for: .normal)
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        selectionStyle = .none
    }

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(arrowButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalTo(arrowButton.snp.leading)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(stackView)
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(with title: String, details: [String]) {
        titleLabel.text = title
        
        // 스택뷰 초기화
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        details.forEach { detailText in
            let label = UILabel()
            label.text = detailText
            label.font = UIFont.fontGuide(.MyPageTotalRegistrationKickboardLabel)
            label.textColor = .label
            stackView.addArrangedSubview(label)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
