//
//  Community.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

struct Community {
    /// 모임의 성격을 나타냅니다.
    enum Routine {
        case daily
        case regular
    }
    
    /// 모임이 진행되기에 약속된 날짜와 시간을 나타냅니다.
    struct PromiseDate {
        let date: Date
        let startTime: Date
        let endTime: Date
    }
    
    let routine: Routine
    let category: Category
    let participants: [User]
    let participantsLimit: Int
    let promiseDate: PromiseDate
}

struct CommunityRecruitingContent {
    let id: String
    let title: String
    let content: String
    let writtenDate: Date
    let writer: User
    let community: Community
}
