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
    
    // MARK: - UI Components
    
    private let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    private let kickboardImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
    }
    
    private let kickboardIdLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.UsageHistoryKickboardID)
        $0.textColor = .label
    }
    
    private let basicFeeLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.RegistrationHistoryBasicCharge)
        $0.textColor = .secondaryLabel
    }
    
    private let hourlyFeeLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.RegistrationHistoryHourlyCharge)
        $0.textColor = .secondaryLabel
    }
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.RegistrationHistoryDate)
        $0.textColor = .label
        $0.textAlignment = .right
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Helper

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
    
    private func setLayout() {
        contentView.snp.makeConstraints { make in
            make.width.equalTo(370)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        kickboardImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
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
    }
    
    // MARK: - Methods
    
    func configure(with model: RegistrationHistory) {
        kickboardIdLabel.text = model.kickboardId
        basicFeeLabel.text = "기본 이용료: \(model.basicFee)원"
        hourlyFeeLabel.text = "시간당 요금: \(model.hourlyFee)원"
        dateLabel.text = model.date
        kickboardImageView.image = UIImage(named: "kickboard_\(model.type)")
    }
}
