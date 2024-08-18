//
//  CommunityRecruitingContentSearchEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/12/24.
//

import Foundation

/// 모집글 작성, 수정 요청
struct CommunityRecruitingContentMakingRequestEntity: Encodable {
    let category: Category
    let recruitCount: Int
    let meetingDate, startTime, endTime, title, content: String
}

struct CommunityRecruitingContentEntity: Codable {
    let id: Int64
    let category: Category
    let recruitCount: Int
    let meetingDate, startTime, endTime, title, content: String
    
    func toDTO() -> CommunityRecruitingContent {
        let community = Community(
            routine: .daily,
            category: category,
            participantsLimit: recruitCount,
            meetingDate: meetingDate,
            startTime: startTime,
            endTime: endTime
        )
        
        return .init(id: id, title: title, content: content, community: community)
    }
}
