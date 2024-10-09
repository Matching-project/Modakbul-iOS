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
        let locationName, communityRecruitingContentTitle: String
        let category: Category
        
        enum CodingKeys: String, CodingKey {
            case contents, sendTimes
            case locationName = "cafeName"
            case communityRecruitingContentTitle = "boardTitle"
            case category = "categoryName"
        }
    }
    
    func toDTO() -> ChatHistory {
        let messages = zip(result.contents, result.sendTimes).map { ($0.0, $0.1.toDate(by: .serverDateTime1) ?? .now) }
        
        return .init(
            locationName: result.locationName,
            communityRecruitingContentTitle: result.communityRecruitingContentTitle,
            category: result.category,
            messages: messages
        )
    }
}
