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
        case placeId = "cafeId"
    }
}

struct CommunityRecruitingContentEntity: Codable {
    let category: Category
    let recruitCount: Int
    let meetingDate, startTime, endTime, title, content: String
}
