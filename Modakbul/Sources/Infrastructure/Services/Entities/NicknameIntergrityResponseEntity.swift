//
//  NicknameIntergrityResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

/// 닉네임 무결성 확인 응답
struct NicknameIntergrityResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        /// 중복 여부를 나타냅니다.
        let overlapped: Bool
        /// 욕설 등 닉네임으로 사용하기 부적절함을 나타냅니다.
        let abuse: Bool
    }
    
    func toDTO() -> NicknameIntegrityType {
        switch (result.abuse, result.overlapped) {
        case (true, false), (true, true): .abused
        case (false, true): .overlapped
        case (false, false): .normal
        }
    }
}
