//
//  UIFont+.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

extension UIFont {
    static func fontGuide(_ font: FontLiterals) -> UIFont {
        return .systemFont(ofSize: font.size, weight: font.weight)
    }
}
