//
//  CommunityRecruitingContentSearchEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/12/24.
//

import Foundation

struct CommunityRecruitingContentMakingRequestEntity: Encodable {
    let placeId: Int64
    let communityRecruitingContent: CommunityRecruitingContentEntity
    
    enum CodingKeys: String, CodingKey {
        case placeId = "cafe_id"
    }
}

struct CommunityRecruitingContentEntity: Codable {
    let category: Category
    let recruitCount: Int
    let meetingDate, startTime, endTime, title, content: String
    
    enum CodingKeys: String, CodingKey {
        case category, title, content
        case recruitCount = "recruit_count"
        case meetingDate = "meeting_date"
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
