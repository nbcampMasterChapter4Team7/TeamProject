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

    static func minutesBetween(_ from: String, and to: String) -> Int {
        // “HH:mm” 포맷으로 파싱
        guard
            let start = Date(string: from, format: "HH:mm"),
            let end = Date(string: to, format: "HH:mm")
        else {
            return 0
        }
        let interval = end.timeIntervalSince(start)
        return Int(interval / 60)
    }
}

