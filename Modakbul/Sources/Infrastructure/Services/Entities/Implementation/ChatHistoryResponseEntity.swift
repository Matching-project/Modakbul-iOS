//
//  ChatHistoryResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/12/24.
//

import Foundation

/// 채팅기록 불러오기 응답
struct ChatHistoryResponseEntity: Decodable, ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let contents, sendTimes: [String]
        let placeName, communityRecruitingContentTitle: String
        let category: Category
        
        enum CodingKeys: String, CodingKey {
            case contents, sendTimes
            case placeName = "cafeName"
            case communityRecruitingContentTitle = "boardTitle"
            case category = "categoryName"
        }
    }
}
