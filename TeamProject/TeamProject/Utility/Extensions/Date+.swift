//
//  Date_.swift
//  TeamProject
//
//  Created by yimkeul on 4/30/25.
//

import Foundation

extension Date {
    func toString(
        format: String = "yyyy-MM-dd HH:mm:ss",
        locale: Locale = Locale(identifier: "ko_KR"),
        timeZone: TimeZone = .current
    ) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    init?(string: String,
          format: String = "yyyy-MM-dd HH:mm:ss",
          locale: Locale = Locale(identifier: "ko_KR"),
          timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        guard let d = formatter.date(from: string) else { return nil }
        self = d
    }
    
    // 음수 시간 처리 문제로 시간 차이 계산 로직 추가
    static func minutesBetween(_ from: String, and to: String) -> Int {
        // “HH:mm” 포맷으로 파싱
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let startTime = formatter.date(from: from),
              let endTime = formatter.date(from: to) else {
            print("시간 변환 실패: \(from) 또는 \(to)")
            return 0
        }
        
        // 시간 차이 계산
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startTime, to: endTime)
        var minutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
        
        // 종료 시간이 시작 시간보다 이른 경우 (다음날로 넘어간 경우)
        if minutes < 0 {
            minutes += 24 * 60 // 하루(24시간)를 더함
        }
        
        return minutes
    }
}
