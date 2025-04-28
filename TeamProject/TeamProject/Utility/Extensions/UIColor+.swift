//
//  UIColor+.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

extension UIColor {
    static func asset(_ asset: Asset) -> UIColor {
        guard let color = UIColor(named: asset.rawValue) else {
            fatalError("Color asset '\(asset.rawValue)' not found in Asset Catalog")
        }
        return color
    }
    enum Asset: String {
        case main = "Main"
        case gray0 = "Gray#0"
        case gray1 = "Gray#1"
        case gray2 = "Gray#2"
        case gray3 = "Gray#3"
        case gray4 = "Gray#4"
    }
}
