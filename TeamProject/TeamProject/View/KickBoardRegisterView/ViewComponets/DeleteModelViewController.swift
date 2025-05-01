//
//  DeleteModelViewController.swift
//  TeamProject
//
//  Created by tlswo on 4/29/25.
//

import UIKit

import SnapKit
import Then

final class DeleteModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewmodel = KickBoardRecordViewModel.shared

    private var kickboardIDText: String
    private var basicChargeText: String
    private var hourlyChargeText: String
    private var kickBoardIdentifier: UUID
    private var kickboardTypeText: String
    
    // MARK: - Initializer
    
    init(kickboardID: UUID, basicCharge: Int, hourlyCharge: Int, kickboardType: String) {
        self.kickBoardIdentifier = kickboardID
        self.kickboardIDText = kickboardID.uuidString
        self.basicChargeText = basicCharge.formattedCharge
        self.hourlyChargeText = hourlyCharge.formattedCharge
        self.kickboardTypeText = kickboardType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components
    
    private let kickboardImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let kickboardID = UILabel().then {
        $0.font = UIFont.fontGuide(.RentKickboardID)
        $0.textColor = .label
        $0.textAlignment = .left
    }
    
    private let kickboardType = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .left
    }

    private let basicChargeTitle = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.text = "기본 이용료:"
    }

    private let basicCharge = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = UIColor.asset(.gray3)
    }

    private let hourlyChargeTitle = UILabel().then {
        $0.font = UIFont.fontGuide(.RentHourlyCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.text = "시간당 요금:"
    }

    private let hourlyCharge = UILabel().then {
        $0.font = UIFont.fontGuide(.RentHourlyCharge)
        $0.textColor = UIColor.asset(.gray3)
    }

    private let deleteButton = UIButton().then {
        $0.setTitle("삭제하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.systemRed
        $0.titleLabel?.font = UIFont.fontGuide(.RentButtonText)
        $0.layer.cornerRadius = 8
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }

    // MARK: - Layout Helper
    
    private func setStyle() {
        view.backgroundColor = .systemBackground
        kickboardID.text = String(kickboardIDText.prefix(6))
        basicCharge.text = basicChargeText + "원"
        hourlyCharge.text = hourlyChargeText + "원"
        kickboardType.text = "타입: " + kickboardTypeText
        kickboardImage.image = UIImage(named: "kickboard_\(self.kickboardTypeText)")
    }

    private func setLayout() {
        view.addSubviews(kickboardImage, kickboardID, kickboardType,
                         basicChargeTitle, basicCharge,
                         hourlyChargeTitle, hourlyCharge,
                         deleteButton)

        kickboardImage.snp.makeConstraints {
            $0.width.height.equalTo(112)
            $0.leading.equalToSuperview().inset(50)
            $0.top.equalToSuperview().offset(38)
        }

        kickboardID.snp.makeConstraints {
            $0.top.equalTo(kickboardImage)
            $0.leading.equalTo(kickboardImage.snp.trailing).offset(17)
        }
        
        kickboardType.snp.makeConstraints {
            $0.top.equalTo(kickboardID.snp.bottom).offset(8)
            $0.leading.equalTo(kickboardID.snp.leading)
        }

        basicChargeTitle.snp.makeConstraints {
            $0.top.equalTo(kickboardType.snp.bottom).offset(14)
            $0.leading.equalTo(kickboardID.snp.leading)
        }

        basicCharge.snp.makeConstraints {
            $0.top.equalTo(basicChargeTitle.snp.top)
            $0.leading.equalTo(basicChargeTitle.snp.trailing).offset(10)
        }

        hourlyChargeTitle.snp.makeConstraints {
            $0.top.equalTo(basicChargeTitle.snp.bottom).offset(10)
            $0.leading.equalTo(kickboardID.snp.leading)
        }

        hourlyCharge.snp.makeConstraints {
            $0.top.equalTo(hourlyChargeTitle.snp.top)
            $0.leading.equalTo(hourlyChargeTitle.snp.trailing).offset(10)
        }

        deleteButton.snp.makeConstraints {
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 333 / 402)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 45 / 874)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-39)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    @objc private func didTapDeleteButton() {
        viewmodel.deleteKickBoardRecord(kickBoardIdentifier)
        dismiss(animated: true)
    }
}
