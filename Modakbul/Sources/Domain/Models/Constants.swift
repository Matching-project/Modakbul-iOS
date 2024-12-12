//
//  Constants.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/19/24.
//

import Foundation

struct Constants {
    static let horizontal: CGFloat = 30
    static let vertical: CGFloat = 20
    static let cornerRadius: CGFloat = 8
    
    static let tolerance: Double = -0.0001
}

extension TimeInterval {
    static var tolerance: TimeInterval { Constants.tolerance }
}

// MARK: - userId를 관리하는 용도입니다.
extension Constants {
    static let loggedOutUserId: Int = -1
    static let temporalId: Int64 = -1
    static let timestampId: Int64 = -2
    static let systemChat: Int64 = -3
    static let temporalUserNickname: String = "알 수 없는 사용자"
}

// MARK: - 기본 폰트를 지정하는 용도입니다.
extension Constants {
    struct Font {
        static let modakbulRegular = "NotoSansKR-Regular"
        static let modakbulBold = "NotoSansKR-Bold"
    }
}
