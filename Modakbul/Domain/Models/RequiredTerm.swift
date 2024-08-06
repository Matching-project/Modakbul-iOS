//
//  RequiredTerm.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/1/24.
//

import Foundation

enum RequiredTerm: Selectable {
    case service
    case location
    case privacy

    var description: String {
        switch self {
        case .service: return "서비스 이용약관 (필수)"
        case .location: return "위치기반 서비스 이용약관 (필수)"
        case .privacy: return "개인정보 처리방침 (필수)"
        }
    }
}
