//
//  RegisterKickboardAlertViewController.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import UIKit

import SnapKit
import Then

protocol RegisterKickboardAlertDelegate: AnyObject {
    func didCancelRegister()
}

class RegisterKickboardAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewmodel = KickBoardRecordViewModel.shared
    
    weak var delegate: RegisterKickboardAlertDelegate?
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var recognitionNumber: UUID = UUID()
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "현재 위치에 등록"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textAlignment = .center
    }
    
    private lazy var infoLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var basicChargeTextField = UITextField().then {
        $0.placeholder = "기본 이용 요금"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = UIColor.systemGray6
        $0.keyboardType = .decimalPad
    }
    
    private lazy var hourlyChargeTextField = UITextField().then {
        $0.placeholder = "시간당 요금"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = UIColor.systemGray6
        $0.keyboardType = .decimalPad
    }
    
    private lazy var cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemGray3
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }
    
    private lazy var registerButton = UIButton(type: .system).then {
        $0.setTitle("등록", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.systemMint
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
        
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Layout Helper
    
    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        
        [titleLabel, infoLabel, basicChargeTextField, hourlyChargeTextField, cancelButton, registerButton].forEach {
            containerView.addSubview($0)
        }
        
        updateInfoLabel()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        basicChargeTextField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        hourlyChargeTextField.snp.makeConstraints { make in
            make.top.equalTo(basicChargeTextField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(hourlyChargeTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(containerView.snp.centerX).offset(-8)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(hourlyChargeTextField.snp.bottom).offset(20)
            make.leading.equalTo(containerView.snp.centerX).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Methods
    
    private func updateInfoLabel() {
        infoLabel.text = """
        위도: \(latitude) 경도: \(longitude)
        킥보드 인식번호: \(recognitionNumber)
        """
    }
    
    // MARK: - @objc Methods
    
    @objc private func didTapCancel() {
        delegate?.didCancelRegister()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRegister() {
        guard let basicCharge = Int(basicChargeTextField.text ?? ""),
              let hourlyCharge = Int(hourlyChargeTextField.text ?? "") else { return }
        
        print("위도: \(latitude)")
        print("경도: \(longitude)")
        print("킥보드 인식번호: \(recognitionNumber)")
        print("기본 요금: \(basicCharge)")
        print("시간당 요금: \(hourlyCharge)")
        
        viewmodel.saveKickBoardRecord(KickBoardRecord(
            latitude: latitude,
            longitude: longitude,
            kickboardIdentifier: recognitionNumber,
            basicCharge: basicCharge,
            hourlyCharge: hourlyCharge
        ))
        
        dismiss(animated: true, completion: nil)
    }
}
