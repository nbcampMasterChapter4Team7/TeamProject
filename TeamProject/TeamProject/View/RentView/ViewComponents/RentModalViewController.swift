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
    
    private let viewModel = RentModalViewModel.shared
    private var kickboardId: UUID
    private var kickBoardRecord: KickBoardRecord?
    private var timer: Timer?
    private var rentStartDate: Date?
    
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
    
    private let kickboardTypeTitle = UILabel().then { make in
        make.font = UIFont.fontGuide(.RentBasicCharge)
        make.textColor = UIColor.asset(.gray3)
        make.textAlignment = .left
        make.text = "타입:"
    }
    
    private let kickboardType = UILabel().then { make in
        make.font = UIFont.fontGuide(.RentBasicCharge)
        make.textColor = UIColor.asset(.gray3)
        make.textAlignment = .left
        make.text = "A"
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
    
    private let timerLabel = UILabel().then {
        $0.font = UIFont.fontGuide(.RentBasicCharge)
        $0.textColor = UIColor.asset(.gray3)
        $0.textAlignment = .left
        $0.text = "00:00:00"
    }
    
    // MARK: Initializer
    
    init(kickboardId: UUID) {
        self.kickboardId = kickboardId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
        setAction()
        kickBoardRecord = viewModel.fetchKickBoardRecord(with: kickboardId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let kickBoardRecord = kickBoardRecord {
            configure(with: kickBoardRecord)
        }
        
        if UserDefaultsManager.shared.isRent(),
           let start = viewModel.rentStartDate {
            startTimer(from: start)
        }
    }
    
    // MARK: - Style Helper
    
    private func setStyle() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        buttonStackView.addArrangedSubviews(pauseButton, returnButton)
        
        view.addSubviews(kickboardImage, kickboardID,
                         kickboardTypeTitle, kickboardType,
                         basicChargeTitle, hourlyChargeTitle,
                         basicCharge, hourlyCharge, rentButton, buttonStackView,timerLabel)
        
        kickboardImage.snp.makeConstraints {
            $0.width.height.equalTo(112)
            $0.leading.equalToSuperview().inset(50)
            $0.top.equalToSuperview().offset(38)
        }
        
        kickboardID.snp.makeConstraints {
            $0.top.equalTo(kickboardImage)
            $0.leading.equalTo(kickboardImage.snp.trailing).offset(17)
        }
        
        timerLabel.snp.makeConstraints {
            $0.leading.equalTo(kickboardID.snp.trailing).offset(8)
            $0.bottom.equalTo(kickboardID.snp.bottom)
        }
        
        kickboardTypeTitle.snp.makeConstraints {
            $0.top.equalTo(kickboardID.snp.bottom).offset(14)
            $0.leading.equalTo(kickboardID.snp.leading)
        }
        
        kickboardType.snp.makeConstraints {
            $0.top.equalTo(kickboardTypeTitle.snp.top)
            $0.leading.equalTo(kickboardTypeTitle.snp.trailing).offset(10)
        }
        
        basicChargeTitle.snp.makeConstraints {
            $0.top.equalTo(kickboardTypeTitle.snp.bottom).offset(10)
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
    
    // MARK: - Action Helper
    
    private func setAction() {
        rentButton.addTarget(self, action: #selector(didTapRentButton), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    func configure(with kickBoardRecord: KickBoardRecord) {
        kickboardID.text = String(kickBoardRecord.kickboardIdentifier.uuidString.prefix(6))
        basicCharge.text = kickBoardRecord.basicCharge.formattedCharge + "원"
        hourlyCharge.text = kickBoardRecord.hourlyCharge.formattedCharge + "원"
        kickboardType.text = kickBoardRecord.type
        kickboardImage.image = UIImage(named: "kickboard_\(kickBoardRecord.type)")
        
        if UserDefaultsManager.shared.isRent() {
            rentButton.isHidden = true
            buttonStackView.isHidden = false
        } else {
            rentButton.isHidden = false
            buttonStackView.isHidden = true
        }
    }
    
    private func startTimer(from start: Date) {
        timer?.invalidate()
        rentStartDate = start
        timerLabel.text = "00:00:00"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(start)
            let h = Int(elapsed) / 3600
            let m = (Int(elapsed) % 3600) / 60
            let s = Int(elapsed) % 60
            self.timerLabel.text = String(format: "%02d:%02d:%02d", h, m, s)
        }
    }
    
    // MARK: - @objc Methods
    
    @objc private func didTapRentButton() {
        rentButton.isHidden = true
        buttonStackView.isHidden = false
        showAlert(title: "알림", message: "대여를 시작합니다.") { _ in
            self.dismiss(animated: true)
        }
        let start = Date()
        viewModel.rentStartDate = start
        startTimer(from: start)
        
        UserDefaultsManager.shared.saveKickboardID(kickboardID: self.kickboardId.uuidString)
        UserDefaultsManager.shared.setRentStatus(isRent: true)
        
        guard let kickboardRecord = kickBoardRecord else {
            fatalError("이용 기록 저장 실패")
        }
        viewModel.saveUsageHistory(with: kickboardRecord)
    }
    
    @objc private func didTapReturnButton() {
        rentButton.isHidden = false
        buttonStackView.isHidden = true
        
        timer?.invalidate()
        viewModel.rentStartDate = nil
        
        UserDefaultsManager.shared.saveKickboardID(kickboardID: "")
        UserDefaultsManager.shared.setRentStatus(isRent: false)
        guard let entity = viewModel.updateUsageHistory(with: kickboardId) else {
            return
        }
        let diff = Date.minutesBetween(entity.startTime, and: entity.finishTime!)
        showAlert(title: "알림", message: "반납이 완료되었습니다.\n \(diff)분 사용 - \(entity.charge)원 청구") { _ in
            self.dismiss(animated: true)
        }
        
        
    }
    
}
