//
//  NicknameIntegrityType.swift
//  Modakbul
//
//  Created by Swain Yun on 8/31/24.
//

import Foundation

/// 닉네임 무결성 확인에 대한 결과값을 나타냅니다.
///
enum NicknameIntegrityType {
    /// 정상
    case normal
    
    /// 중복됨
    case overlapped
    
    /// 부적절한 이름
    case abused
}
