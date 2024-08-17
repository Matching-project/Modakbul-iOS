//
//  RelatedCommunityRecruitingContentListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 사용자가 작성했던 모집글 목록 조회 응답
struct RelatedCommunityRecruitingContentListResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let id: Int64
        let title, startTime, endTime: String
        let dayOfWeek: DayOfWeek
        let category: Category
        let recruitCount, currentCount: Int
        let meetingDate: String
        let activeState: ActiveState
        
        enum CodingKeys: String, CodingKey {
            case title, startTime, endTime, dayOfWeek, category, recruitCount, currentCount, meetingDate
            case id = "boardId"
            case activeState = "boardStatus"
        }
    }
    
    func toDTO() -> [CommunityRecruitingContent] {
        result.map {
            let community = Community(
                routine: .daily,
                category: $0.category,
                participantsCount: $0.currentCount,
                participantsLimit: $0.recruitCount,
                meetingDate: $0.meetingDate,
                startTime: $0.startTime,
                endTime: $0.endTime
            )
            
            return .init(
                id: $0.id,
                title: $0.title,
                content: String(),
                community: community,
                activeState: $0.activeState
            )
        }
    }
}
