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

    private let kickboardImage = UIImageView().then { make in
        let img = ImageLiterals.kickboard
        make.contentMode = .scaleAspectFit
        make.image = img
    }

    private let kickboardID = UILabel().then { make in
        make.font = UIFont.fontGuide(.RentKickboardID)
        make.textColor = .label
        make.textAlignment = .left
        make.text = "MK111"
    }

    private let basicChargeTitle = UILabel().then { make in
        make.font = UIFont.fontGuide(.RentBasicCharge)
        make.textColor = UIColor.asset(.gray3)
        make.textAlignment = .left
        make.text = "기본 이용료:"
    }
    private let basicCharge = UILabel().then { make in
        make.font = UIFont.fontGuide(.RentBasicCharge)
        make.textColor = UIColor.asset(.gray3)
        make.textAlignment = .left
        make.text = "1,000원"
    }

    private let hourlyChargeTitle = UILabel().then { make in
        make.font = UIFont.fontGuide(.RentHourlyCharge)
        make.textColor = UIColor.asset(.gray3)
        make.textAlignment = .left
        make.text = "시간당 요금:"
    }

    private let hourlyCharge = UILabel().then { make in
        make.font = UIFont.fontGuide(.RentHourlyCharge)
        make.textColor = UIColor.asset(.gray3)
        make.textAlignment = .left
        make.text = "200원"
    }

    private let rentButton = UIButton().then { make in
        make.setTitle("대여하기", for: .normal)
        make.setTitleColor(.white, for: .normal)
        make.backgroundColor = UIColor.asset(.main)
        make.titleLabel?.font = UIFont.fontGuide(.RentButtonText)
        make.layer.cornerRadius = 8
    }

    private let buttonStackView = UIStackView().then { make in
        make.axis = .horizontal
        make.spacing = 16
        make.distribution = .fillEqually
        make.alignment = .center
        make.isHidden = true
    }

    private let pauseButton = UIButton().then { make in
        make.setTitle("일시정지", for: .normal)
        make.setTitleColor(.white, for: .normal)
        make.backgroundColor = UIColor.asset(.gray1)
        make.titleLabel?.font = UIFont.fontGuide(.RentButtonText)
        make.layer.cornerRadius = 8
    }


    private let returnButton = UIButton().then { make in
        make.setTitle("반납하기", for: .normal)
        make.setTitleColor(.white, for: .normal)
        make.backgroundColor = UIColor.asset(.main)
        make.titleLabel?.font = UIFont.fontGuide(.RentButtonText)
        make.layer.cornerRadius = 8
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
