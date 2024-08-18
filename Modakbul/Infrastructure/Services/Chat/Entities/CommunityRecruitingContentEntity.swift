//
//  CommunityRecruitingContentEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/6/24.
//

import Foundation

struct CommunityRecruitingContentEntity: Codable {
    // TODO: - [WIP] 2차 배포시 일일모임 / 정기모임 대응 필요 (meetingType)
    let id, placeName, address, category, meetingDate, start, end, title, content: String
    let recruitCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, address, recruitCount, meetingDate, start, end, title, content
        case placeName = "cafe_name"
        case category = "category_name"
    }
}
