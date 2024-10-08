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
    ///
    /// 요청목록확인, 모집종료 기능 이용 가능
    case exponent
    
    /// 기참여자
    ///
    /// 채팅하기, 모임 나가기 기능 이용 가능
    case participant
    
    /// 미참여자
    ///
    /// 채팅하기, 참여요청 보내기 기능 이용 가능
    case nonParticipant
}
