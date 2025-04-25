//
//  UIView+.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}

