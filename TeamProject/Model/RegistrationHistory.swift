//
//  RegistrationHistory.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//

import Foundation

// MARK: Properties

struct RegistrationHistory {
    let kickboardId: String
    let basicFee: Int
    let hourlyFee: Int
    let date: String
    
    // 편의를 위한 초기화 메서드
    init(kickboardId: String, basicFee: Int, hourlyFee: Int, date: String) {
        self.kickboardId = kickboardId
        self.basicFee = basicFee
        self.hourlyFee = hourlyFee
        self.date = date
    }
}
