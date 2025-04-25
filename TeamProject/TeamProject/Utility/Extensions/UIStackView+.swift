//
//  UIStackView+.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
