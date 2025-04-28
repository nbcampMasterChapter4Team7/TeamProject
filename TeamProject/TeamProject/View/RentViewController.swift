//
//  RentViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class RentViewController: UIViewController {
    
    let centerLabel = UILabel().then {
        $0.text = "Test1"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAttribute()
    }

    func setUI() {
        self.view.backgroundColor = .red
        self.view.addSubview(centerLabel)
    }

    func setAttribute() {

        centerLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

