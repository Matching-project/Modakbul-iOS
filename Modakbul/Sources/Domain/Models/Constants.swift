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
}

// MARK: - userId를 관리하는 용도입니다.
extension Constants {
    static let loggedOutUserId: Int = -1
    static let temporalId: Int64 = -1
}

// MARK: - 기본 폰트를 지정하는 용도입니다.
extension Constants {
    struct Font {
        static let modakbulRegular = "NotoSansKR-Regular"
        static let modakbulBold = "NotoSansKR-Bold"
    }
}
