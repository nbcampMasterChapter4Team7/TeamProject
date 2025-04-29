//
//  RegisterKickboardAlertViewController.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import UIKit

import SnapKit

protocol RegisterKickboardAlertDelegate: AnyObject {
    func didCancelRegister()
}

class RegisterKickboardAlertViewController: UIViewController {
    
    private let viewmodel = KickBoardRecordViewModel.shared
    
    weak var delegate: RegisterKickboardAlertDelegate?
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var recognitionNumber: UUID = UUID()
    
    // MARK: - UI Components
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let basicChargeTextField = UITextField()
    private let hourlyChargeTextField = UITextField()
    private let cancelButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
        
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Container
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        view.addSubview(containerView)
        
        // Title
        titleLabel.text = "현재 위치에 등록"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // Info
        infoLabel.text = """
        위도: \(latitude) 경도: \(longitude)
        킥보드 인식번호: \(recognitionNumber)
        """
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.textColor = .secondaryLabel
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        containerView.addSubview(infoLabel)
        
        // TextFields
        [basicChargeTextField, hourlyChargeTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.backgroundColor = UIColor.systemGray6
            containerView.addSubview($0)
        }
        
        basicChargeTextField.placeholder = "기본 이용 요금"
        basicChargeTextField.keyboardType = .decimalPad
        
        hourlyChargeTextField.placeholder = "시간당 요금"
        hourlyChargeTextField.keyboardType = .decimalPad
        
        // Buttons
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .systemGray3
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        
        registerButton.setTitle("등록", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = UIColor.systemMint
        registerButton.layer.cornerRadius = 8
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        containerView.addSubview(cancelButton)
        containerView.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
        }
        
        basicChargeTextField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
            make.height.equalTo(40)
        }
        
        hourlyChargeTextField.snp.makeConstraints { make in
            make.top.equalTo(basicChargeTextField.snp.bottom).offset(12)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(hourlyChargeTextField.snp.bottom).offset(20)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.centerX).offset(-8)
            make.height.equalTo(44)
            make.bottom.equalTo(containerView.snp.bottom).inset(20)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(hourlyChargeTextField.snp.bottom).offset(20)
            make.leading.equalTo(containerView.snp.centerX).offset(8)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapCancel() {
        delegate?.didCancelRegister()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRegister() {
        let basicCharge = basicChargeTextField.text ?? ""
        let hourlyCharge = hourlyChargeTextField.text ?? ""
        
        print("위도: \(latitude)")
        print("경도: \(longitude)")
        print("킥보드 인식번호: \(recognitionNumber)")
        print("기본 요금: \(basicCharge)")
        print("시간당 요금: \(hourlyCharge)")
        
        viewmodel.saveKickBoardRecord(KickBoardRecord(latitude: latitude, longitude: longitude, kickboardIdentifier: recognitionNumber, basicCharge: Int(basicCharge) ?? 0, hourlyCharge: Int(hourlyCharge) ?? 0))
        
        dismiss(animated: true, completion: nil)
    }

}
