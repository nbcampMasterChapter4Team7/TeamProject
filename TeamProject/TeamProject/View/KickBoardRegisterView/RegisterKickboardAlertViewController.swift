//
//  RegisterKickboardAlertViewController.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import UIKit

protocol RegisterKickboardAlertDelegate: AnyObject {
    func didCancelRegister()
}

class RegisterKickboardAlertViewController: UIViewController {
    
    weak var delegate: RegisterKickboardAlertDelegate?
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var recognitionNumber: String = ""
    
    // MARK: - UI Components
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let basicFareTextField = UITextField()
    private let hourlyFareTextField = UITextField()
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
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Title
        titleLabel.text = "현재 위치에 등록"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(infoLabel)
        
        // TextFields
        [basicFareTextField, hourlyFareTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.backgroundColor = UIColor.systemGray6
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        basicFareTextField.placeholder = "기본 이용 요금"
        basicFareTextField.keyboardType = .decimalPad
        
        hourlyFareTextField.placeholder = "시간당 요금"
        hourlyFareTextField.keyboardType = .decimalPad
        
        // Buttons
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .systemGray3
        cancelButton.layer.cornerRadius = 8
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        
        registerButton.setTitle("등록", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemGreen
        registerButton.layer.cornerRadius = 8
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        containerView.addSubview(cancelButton)
        containerView.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            basicFareTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            basicFareTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            basicFareTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            basicFareTextField.heightAnchor.constraint(equalToConstant: 40),
            
            hourlyFareTextField.topAnchor.constraint(equalTo: basicFareTextField.bottomAnchor, constant: 12),
            hourlyFareTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            hourlyFareTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            hourlyFareTextField.heightAnchor.constraint(equalToConstant: 40),
            
            cancelButton.topAnchor.constraint(equalTo: hourlyFareTextField.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -8),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            registerButton.topAnchor.constraint(equalTo: hourlyFareTextField.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 8),
            registerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapCancel() {
        delegate?.didCancelRegister()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRegister() {
        let basicFare = basicFareTextField.text ?? ""
        let hourlyFare = hourlyFareTextField.text ?? ""
        
        print("위도: \(latitude)")
        print("경도: \(longitude)")
        print("킥보드 인식번호: \(recognitionNumber)")
        print("기본 요금: \(basicFare)")
        print("시간당 요금: \(hourlyFare)")
        
        dismiss(animated: true, completion: nil)
    }

}
