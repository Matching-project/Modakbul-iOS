//
//  UserRole.swift
//  Modakbul
//
//  Created by Swain Yun on 9/8/24.
//

import Foundation

/// 사용자 역할을 나타냅니다.
enum UserRole {
    /// 대표자, 방장, 모집글 게시자
    case exponent
    
    /// 기참여자
    case participant
    
    /// 미참여자
    case nonParticipant
}
