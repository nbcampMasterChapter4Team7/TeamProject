//
//  Test1.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import Foundation
import UIKit

import SnapKit
import Then

final class Test1:UIViewController {
    lazy var centerLabel = UILabel().then {
          $0.text = "Test1"
      }
      
      override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view.
          
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
