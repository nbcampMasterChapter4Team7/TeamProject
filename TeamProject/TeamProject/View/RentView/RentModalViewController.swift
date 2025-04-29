//
//  RentModalViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/29/25.
//

import UIKit

import SnapKit
import Then

final class RentModalViewController: UIViewController {

    // MARK: - Properties
    //viewmodel
    
    // MARK: - UI Components

    private let kickboardImage = UIImageView().then {
        let img = ImageLiterals.kickboard
        $0.contentMode = .scaleAspectFit
        $0.image = img
    }

    private let kickboardID = UILabel().then {
        $0.font = UIFont.fontGuide(.RentKickboardID)
        $0.textColor = .label
        $0.textAlignment = .left
        $0.text = "MK111"
    }

    private let basicChargeTitle = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.textAlignment = .left
        $0.text = "기본 이용료:"
    }
    private let basicCharge = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.textAlignment = .left
        $0.text = "1,000원"
    }

    private let hourlyChargeTitle = UILabel().then {
        $0.font = UIFont.fontGuide(.RentHourlyCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.textAlignment = .left
        $0.text = "시간당 요금:"
    }

    private let hourlyCharge = UILabel().then {
        $0.font = UIFont.fontGuide(.RentHourlyCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.textAlignment = .left
        $0.text = "200원"
    }

    private let rentButton = UIButton().then {
        $0.setTitle("대여하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.asset(.main)
        $0.titleLabel?.font = UIFont.fontGuide(.RentButtonText)
        $0.layer.cornerRadius = 8
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.isHidden = true
    }

    private let pauseButton = UIButton().then {
        $0.setTitle("일시정지", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.asset(.gray1)
        $0.titleLabel?.font = UIFont.fontGuide(.RentButtonText)
        $0.layer.cornerRadius = 8
    }


    private let returnButton = UIButton().then {
        $0.setTitle("반납하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.asset(.main)
        $0.titleLabel?.font = UIFont.fontGuide(.RentButtonText)
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
        rentButton.addTarget(self, action: #selector(didTapRentButton), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
    }

    // MARK: - Style Helper
    
    private func setStyle() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Layout Helper

    private func setLayout() {
        buttonStackView.addArrangedSubviews(pauseButton, returnButton)
        
        view.addSubviews(kickboardImage, kickboardID,
            basicChargeTitle, hourlyChargeTitle,
            basicCharge, hourlyCharge, rentButton, buttonStackView)

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

        rentButton.snp.makeConstraints {
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 333 / 402)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 45 / 874)

            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-39)
            $0.centerX.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-39)
        }
        
        pauseButton.snp.makeConstraints {
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 168 / 402)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 45 / 874)
        }
        
        returnButton.snp.makeConstraints {
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 168 / 402)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 45 / 874)
        }
        
    }
    
    // MARK: - Methods

    func configure() {

    }
    
    // MARK: - @objc Methods
    
    @objc private func didTapRentButton() {
        rentButton.isHidden = true
        buttonStackView.isHidden = false
    }
    
    @objc private func didTapPauseButton() {
        
    }
    
    @objc private func didTapReturnButton() {
        rentButton.isHidden = false
        buttonStackView.isHidden = true
    }
    
}
