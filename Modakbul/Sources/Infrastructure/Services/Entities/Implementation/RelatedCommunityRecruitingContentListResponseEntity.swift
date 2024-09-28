//
//  RelatedCommunityRecruitingContentListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 사용자와 관련된 모집글 목록 조회 응답
struct RelatedCommunityRecruitingContentListResponseEntity: ResponseEntity {
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
        let placeId: Int64
        let locationName: String
        
        enum CodingKeys: String, CodingKey {
            case title, startTime, endTime, dayOfWeek, category, recruitCount, currentCount, meetingDate
            case id = "boardId"
            case activeState = "boardStatus"
            case placeId = "cafeId"
            case locationName = "cafeName"
        }
    }
    
    func toDTO() -> [CommunityRelationship] {
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
            
            let communityRecruitingContent: CommunityRecruitingContent = .init(
                id: $0.id,
                title: $0.title,
                content: String(),
                community: community,
                activeState: $0.activeState
            )
            
            return .init(placeId: $0.placeId, locationName: $0.locationName, communityRecruitingContent: communityRecruitingContent)
        }
    }
}
