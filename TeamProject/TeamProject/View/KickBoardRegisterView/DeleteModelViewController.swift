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
    
    // MARK: - Initializer
    init(kickboardID: UUID, basicCharge: Int, hourlyCharge: Int) {
        self.kickBoardIdentifier = kickboardID
        self.kickboardIDText = kickboardID.uuidString
        self.basicChargeText = String(basicCharge)
        self.hourlyChargeText = String(hourlyCharge)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components
    private let kickboardImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = ImageLiterals.kickboard
    }

    private lazy var kickboardID = UILabel().then {
        $0.font = UIFont.fontGuide(.RentKickboardID)
        $0.textColor = .label
        $0.textAlignment = .left
        $0.text = kickboardIDText
    }

    private lazy var basicChargeTitle = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.text = "기본 이용료:"
    }

    private lazy var basicCharge = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.text = basicChargeText
    }

    private lazy var hourlyChargeTitle = UILabel().then {
        $0.font = UIFont.fontGuide(.RentHourlyCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.text = "시간당 요금:"
    }

    private lazy var hourlyCharge = UILabel().then {
        $0.font = UIFont.fontGuide(.RentHourlyCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.text = hourlyChargeText
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

    // MARK: - Style/Layout
    private func setStyle() {
        view.backgroundColor = .systemBackground
    }

    private func setLayout() {
        view.addSubviews(kickboardImage, kickboardID,
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

        basicChargeTitle.snp.makeConstraints {
            $0.top.equalTo(kickboardID.snp.bottom).offset(14)
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

    // MARK: - Actions
    @objc private func didTapDeleteButton() {
        // 삭제 동작 처리 로직
        print("삭제하기 버튼이 눌렸습니다.")
        viewmodel.deleteKickBoardRecord(kickBoardIdentifier)
        dismiss(animated: true)
    }
}
