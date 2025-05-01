//
//  Int+.swift
//  TeamProject
//
//  Created by yimkeul on 4/29/25.
//

import Foundation

extension Int {
    var formattedCharge: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
