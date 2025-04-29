//
//  RegistrationHistory.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//

import Foundation

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

extension RegistrationHistory {
    // 기본 이용료 포맷팅
    var formattedBasicFee: String {
        return "\(basicFee.formatted())원"
    }
    
    // 시간당 요금 포맷팅
    var formattedHourlyFee: String {
        return "\(hourlyFee.formatted())원"
    }
    
    // 날짜 포맷팅 (필요한 경우)
    var formattedDate: String {
        return date
    }
    
    // 전체 정보 요약
    var summary: String {
        return """
        킥보드 ID: \(kickboardId)
        기본 이용료: \(formattedBasicFee)
        시간당 요금: \(formattedHourlyFee)
        등록일: \(formattedDate)
        """
    }
}
