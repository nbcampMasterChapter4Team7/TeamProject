//
//  SizeLiterals.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import UIKit

struct SizeLiterals {
    struct Screen {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let screenHeight: CGFloat = UIScreen.main.bounds.height
        static let deviceRatio: CGFloat = screenWidth / screenHeight

        static let isSmallDevice: Bool = min(screenWidth, screenHeight) <= 375
    }
}
