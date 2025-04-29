//
//  UsageHistory.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//
import Foundation

struct UsageHistory {
    let kickboardId: String
    let usageTime: String
    let distance: Double
    let date: String
    let price: Int
    
    // 기본 초기화 메서드
    init(kickboardId: String, usageTime: String, distance: Double, date: String, price: Int) {
        self.kickboardId = kickboardId
        self.usageTime = usageTime
        self.distance = distance
        self.date = date
        self.price = price
    }
    
    // 시작 시간과 종료 시간을 받아서 usageTime을 자동으로 생성하는 편의 초기화 메서드
    init(kickboardId: String, startTime: String, endTime: String, distance: Double, date: String, price: Int) {
        self.kickboardId = kickboardId
        self.usageTime = "\(startTime) ~ \(endTime)"
        self.distance = distance
        self.date = date
        self.price = price
    }
}

// MARK: - UsageHistory Extensions
extension UsageHistory {
    // 사용 시간을 분으로 계산
    var durationInMinutes: Int? {
        let components = usageTime.components(separatedBy: " ~ ")
        guard components.count == 2 else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let startTime = formatter.date(from: components[0]),
              let endTime = formatter.date(from: components[1]) else { return nil }
        
        return Calendar.current.dateComponents([.minute], from: startTime, to: endTime).minute
    }
    
    // 포맷된 사용 시간 (30분)
    var formattedDuration: String {
        if let minutes = durationInMinutes {
            return "\(minutes)분"
        }
        return "시간 정보 없음"
    }
    
    // 거리 포맷팅
    var formattedDistance: String {
        return String(format: "%.1fkm", distance)
    }
    
    // 가격 포맷팅
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "\(numberFormatter.string(from: NSNumber(value: price)) ?? String(price))원"
    }
    
    // 전체 정보 요약
    var summary: String {
        return """
        킥보드 ID: \(kickboardId)
        이용 시간: \(usageTime) (\(formattedDuration))
        이동 거리: \(formattedDistance)
        이용 요금: \(formattedPrice)
        이용일: \(date)
        """
    }
}
