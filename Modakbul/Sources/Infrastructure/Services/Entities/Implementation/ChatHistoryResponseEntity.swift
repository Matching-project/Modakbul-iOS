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
    
    func toDTO() async -> ChatHistory {
        let messages = await withTaskGroup(of: (String, Date).self) { group in
            for (content, sendTime) in zip(result.contents, result.sendTimes) {
                group.addTask {
                    let date = await sendTime.toDate(by: .serverDateTime1) ?? .now
                    return (content, date)
                }
            }
            return await group.reduce(into: []) { $0.append($1) }
        }
        
        return .init(
            locationName: result.locationName,
            communityRecruitingContentTitle: result.communityRecruitingContentTitle,
            category: result.category,
            messages: messages
        )
    }
}
