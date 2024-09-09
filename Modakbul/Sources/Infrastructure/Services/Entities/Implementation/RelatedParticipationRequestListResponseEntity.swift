//
//  RelatedParticipationRequestListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 사용자가 작성했던 참여 요청 목록 응답
/// - Important: 정확히는 참여 요청을 작성했던 모임에 대한 정보를 받습니다.
struct RelatedParticipationRequestListResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let title, startTime, endTime: String
        let communityRecruitingContentId, matchingId: Int64
        let category: Category
        let recruitCount, currentCount: Int
        let meetingDate: String
        let dayOfWeek: DayOfWeek
        let activeState: ActiveState
        let matchState: MatchState
        
        enum CodingKeys: String, CodingKey {
            case title, startTime, endTime, recruitCount, currentCount, meetingDate, dayOfWeek
            case communityRecruitingContentId = "boardId"
            case category = "categoryName"
            case matchingId = "matchId"
            case activeState = "boardStatus"
            case matchState = "matchStatus"
        }
    }
    
    func toDTO() -> [(communityRecruitingContent: CommunityRecruitingContent, matchingId: Int64, matchState: MatchState)] {
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
                id: $0.communityRecruitingContentId,
                title: $0.title,
                content: String(),
                community: community,
                activeState: $0.activeState
            )
            
            return (communityRecruitingContent, $0.matchingId, $0.matchState)
        }
    }
}
