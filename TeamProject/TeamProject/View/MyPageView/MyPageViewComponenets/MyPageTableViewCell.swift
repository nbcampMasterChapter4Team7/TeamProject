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
    
    // MARK: - Properties
    static let id = "TableViewCell"
    weak var delegate: MyPageTableViewCellProtocol?
    
    static let data: [(title: String, details: [String])] = [
        ("이용 내역", ["전체 이용 내역 보기"]),
        ("등록한 킥보드", ["전체 등록 내역 보기"]),
        ("고객센터", ["자주 묻는 질문", "1:1 문의하기", "공지사항"])
    ]
    
    // MARK: - UI Components
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
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Helper
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - Methods
    func configure(with title: String, details: [String]) {
        titleLabel.text = title
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        details.forEach { detailText in
            let containerView = UIView()
            let label = UILabel()
            label.text = detailText
            label.font = UIFont.fontGuide(.MyPageTotalRegistrationKickboardLabel)
            label.textColor = .label
            
            if ["자주 묻는 질문", "1:1 문의하기", "공지사항"].contains(detailText) {
                stackView.addArrangedSubview(label)
            } else {
                let arrowButton = UIButton().then {
                    $0.tintColor = .systemGray
                    $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                    $0.accessibilityLabel = detailText
                    $0.addTarget(self, action: #selector(arrowButtonTapped(_:)), for: .touchUpInside)
                }
                
                containerView.addSubview(label)
                containerView.addSubview(arrowButton)
                
                label.snp.makeConstraints { make in
                    make.leading.centerY.equalToSuperview()
                }
                
                arrowButton.snp.makeConstraints { make in
                    make.trailing.centerY.equalToSuperview()
                    make.leading.greaterThanOrEqualTo(label.snp.trailing).offset(8) // 동적인 텍스트 길이에 대응
                }
                
                stackView.addArrangedSubview(containerView)
                containerView.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalTo(30) // 컨테이너 높이 고정
                }
            }
        }
    }
    
    @objc private func arrowButtonTapped(_ sender: UIButton) {
        guard let text = sender.accessibilityLabel else { return }
        if text == "전체 이용 내역 보기" {
            delegate?.usageHistoryButtonTapped()
        } else if text == "전체 등록 내역 보기" {
            delegate?.registrationHistoryButtonTapped()
        }
    }
}
