//
//  CommunityRecruitingContentEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/3/24.
//

import Foundation

struct CommunityRecruitingContentEntity: Codable {
    let id, placeName, address, category, meetingDate, start, end, title, content: String
    let recruitCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, address, recruitCount, meetingDate, start, end, title, content
        case placeName = "cafe_name"
        case category = "category_name"
    }
}
