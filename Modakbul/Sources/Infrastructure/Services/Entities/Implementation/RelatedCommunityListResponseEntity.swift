//
//  RelatedCommunityListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/28/24.
//


/// 참여 모임 내역 조회 응답
struct RelatedCommunityListResponseEntity: Decodable, ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let communityRecruitingContentId: Int64
        let title: String
        let category: Category
        let meetingDate: String
        let startTime: String
        let endTime: String
        let activeState: ActiveState
        let placeId: Int64
        let locationName: String
        let address: String
        
        enum CodingKeys: String, CodingKey {
            case title, meetingDate, startTime, endTime
            case communityRecruitingContentId = "boardId"
            case category = "categoryName"
            case activeState = "boardStatus"
            case placeId = "cafeId"
            case locationName = "cafeName"
            case address = "roadName"
        }
    }
    
    func toDTO() -> [CommunityRelationship] {
        result.map {
            let community = Community(
                routine: .daily,
                category: $0.category,
                participantsLimit: 0,
                meetingDate: $0.meetingDate,
                startTime: $0.startTime,
                endTime: $0.endTime
            )
            
            let communityRecruitingContent = CommunityRecruitingContent(
                id: $0.communityRecruitingContentId,
                title: $0.title,
                content: String(),
                community: community,
                activeState: $0.activeState
            )
            
            return .init(
                placeId: $0.placeId,
                locationName: $0.locationName,
                communityRecruitingContent: communityRecruitingContent
            )
        }
    }
}
