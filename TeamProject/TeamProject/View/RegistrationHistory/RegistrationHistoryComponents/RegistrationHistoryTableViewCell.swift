//
//  RegistrationHistoryTableViewCell.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//

import UIKit

import SnapKit
import Then

final class RegistrationHistoryTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let RegistrationHistoryCellid = "registrationHistoryCell"
    
    // MARK: UI Components
    
    private let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .center
    }
    
    private let kickboardImageView = UIImageView().then {
        $0.image = ImageLiterals.kickboard
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
    }
    
    private let kickboardIdLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
    }
    
    private let basicFeeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .darkGray
    }
    
    private let hourlyFeeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .darkGray
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        contentView.addSubview(containerStackView)
        contentView.addSubview(dateLabel)
        
        containerStackView.addArrangedSubview(kickboardImageView)
        containerStackView.addArrangedSubview(infoStackView)
        
        [kickboardIdLabel, basicFeeLabel, hourlyFeeLabel].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        kickboardImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
            make.height.equalTo(80)
        }
    }
    
    private func configureUI() {
        // 테스트용 더미 데이터
        kickboardIdLabel.text = "ABCDEF"
        basicFeeLabel.text = "기본 이용료: 1,000원"
        hourlyFeeLabel.text = "시간당 요금: 200원"
        dateLabel.text = "2025.04.30"
    }
    
    func configure(with model: RegistrationHistory) {
        kickboardIdLabel.text = model.kickboardId
        basicFeeLabel.text = "기본 이용료: \(model.basicFee)원"
        hourlyFeeLabel.text = "시간당 요금: \(model.hourlyFee)원"
        dateLabel.text = model.date
    }
}
