//
//  ChatHistory.swift
//  Modakbul
//
//  Created by Swain Yun on 9/12/24.
//

import Foundation

/// 서버에 누적된 채팅기록과 채팅방 정보입니다.
struct ChatHistory {
    /// 해당 채팅과 연관된 장소의 이름을 나타냅니다.
    let placeName: String
    /// 해당 채팅과 연관된 모집글의 제목을 나타냅니다.
    let communityRecruitingContentTitle: String
    let category: Category
    let messages: [(content: String, timestamp: Date)]
}
