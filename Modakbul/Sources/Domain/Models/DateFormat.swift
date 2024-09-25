//
//  DateFormat.swift
//  Modakbul
//
//  Created by Swain Yun on 7/30/24.
//

import Foundation

/// 날짜, 시간 표현 방식
enum DateFormat: String {
    /// 년.월.일
    case yyyyMMdd = "yyyy.MM.dd"
    
    /// 년-월-일
    case yyyyMMddHyphen = "yyyy-MM-dd"
    
    /// 년월일 (구분자 없음)
    case yyyyMMddRaw
    
    /// 한국어 년월일 (yyyy년 MM월 dd일)
    case yyyyMMddKorean = "yyyy년 MM월 dd일"
    
    /// 한국어 년월일 (yyyy년 M월 d일)
    case yyyyMdKorean = "yyyy년 M월 d일"
    
    /// 한국어 월일 (MM월 dd일)
    case MMddKorean = "MM월 dd일"
    
    /// 년.월
    case yyyyMM = "yyyy.MM"
    
    /// 월.일
    case MMdd = "MM.dd"
    
    /// 년.월.일 시:분:초
    case dateTime = "yyyy.MM.dd HH:mm:ss"
    
    /// 년.월.일 시:분
    case yyyyMMddHHmm = "yyyy.MM.dd HH:mm"
    
    /// 년.월.일 오전/오후 시:분
    case yyyyMMddahhmm = "yyyy.MM.dd a hh:mm"
    
    /// 년.월.일 오전/오후 시(24):분
    case yyyyMMddaHHmm = "yyyy.MM.dd a HH:mm"
    
    /// 시:분:초
    case HHmmss = "HH:mm:ss"
    
    /// 시:분
    case HHmm = "HH:mm"
    
    /// 오전/오후 시:분
    case ahhmm = "a hh:mm"
    
    /// 오전/오후 시:분
    /// - Note: 숫자가 0으로 시작하지 않음
    case ahmm = "a h:mm"
    
    /// 축약 요일 (월, 화)
    case ee = "EE"
    
    /// 서버 날짜, 시간 (년-월-일'시각구분'시:분:초)
    case serverDateTime1 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    
    /// 서버 날짜, 시간 (년-월-일 시:분:초)
    case serverDateTime2 = "yyyy-MM-dd HH:mm:ss"
}

// MARK: DateFormatter 관련
extension DateFormat {
    private static var formatters = [String: DateFormatter]()
    
    /**
     각 DateFormat에 대응되는 DateFormatter
     
     * DateFormatter를 매번 생성하지 않고 재사용 하려는 목적으로 사용
     
     */
    var formatter: DateFormatter {
        Self.cachedFormatter(dateFormat: self.rawValue)
    }
    
    static func cachedFormatter(dateFormat: String) -> DateFormatter {
        if let cached = formatters[dateFormat] {
            return cached
        }
        
        let formatter = createFormatter(with: dateFormat)
        Self.formatters[dateFormat] = formatter
        return formatter
    }
    
    private static func createFormatter(with dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    static func toDate(iso8601String: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: iso8601String)
        return date
    }
}

// MARK: Date+Format
extension Date {
    func toString(by dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
    
    /// DateFormat에서 제공하는 형태와 다른 날짜 형식일 경우 사용
    func toString(by dateFormat: String) -> String {
        let formatter = DateFormat.cachedFormatter(dateFormat: dateFormat)
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(by dateFormat: DateFormat) -> Date? {
        dateFormat.formatter.date(from: dateFormat.rawValue)
    }
}

extension Date {
    func unitizeToTenMinutes() -> Self {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute, .second], from: self)
        
        let minutes = components.minute ?? 0
        let roundedMinutes = Int(ceil(Double(minutes) / 10.0)) * 10 >= 60 ? 0: Int(ceil(Double(minutes) / 10.0)) * 10
        
        components.hour = roundedMinutes == 0 ? (components.hour ?? 0) + 1 : components.hour
        components.minute = roundedMinutes
        components.second = 0
        
        return calendar.date(bySettingHour: components.hour ?? 0,
                             minute: components.minute ?? 0,
                             second: components.second ?? 0,
                             of: self,
                             matchingPolicy: .nextTime) ?? self
    }
    
    func toAge() -> String {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: Date())
            
        if let age = ageComponents.year {
            return "\(age)"
        } else {
            return "나이를 계산할 수 없습니다."
        }
    }
    
    func toDateComponent() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: .now)
        
        if let year = components.year, year > 0 {
            return "\(year)년 전"
        } else if let month = components.month, month > 0 {
            return "\(month)개월 전"
        } else if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else if let second = components.second, second > 0 {
            return "\(second)초 전"
        } else {
            return "방금 전"
        }
    }
}

extension DateComponents {
    func toDate() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.date(from: self)!
    }
}
