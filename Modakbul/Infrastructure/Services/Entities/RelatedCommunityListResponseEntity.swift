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
            case title, category, address
            case meetingDate = "meeting_date"
            case startTime = "start_time"
            case endTime = "end_time"
            case boardStatus = "board_status"
            case placeName = "cafe_name"
        }
    }
}
