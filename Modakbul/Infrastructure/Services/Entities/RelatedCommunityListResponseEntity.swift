//
//  RelatedCommunityListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct RelatedCommunityListResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let title, meetingDate, startTime, endTime, placeName, address: String
        let category: Category
        let boardStatus: BoardStatusEntity
        
        enum CodingKeys: String, CodingKey {
            case title, category, address, meetingDate, startTime, endTime, boardStatus
            case placeName = "cafe_name"
        }
    }
}
