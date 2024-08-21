//
//  CommunityRecruitingContentListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/12/24.
//

import Foundation

/// 모집글 목록 조회 응답
struct CommunityRecruitingContentListResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let place: Place
        let communityRecruitingContents: [CommunityRecruitingContent]
        
        struct Place: Decodable {
            let name, address: String
            let imageURL: URL?
            let openingHour: [OpeningHour]
            let powerSocketState: PowerSocketState
            let noiseLevel: NoiseLevel
            let groupSeatingState: GroupSeatingState
            
            enum CodingKeys: String, CodingKey {
                case name, address, openingHour
                case imageURL = "image"
                case powerSocketState = "outlet"
                case noiseLevel = "congestion"
                case groupSeatingState = "groupSeat"
            }
        }
        
        struct CommunityRecruitingContent: Decodable {
            let id, writerId: Int64
            let recruitCount, currentCount: Int
            let title, meetingDate, startTime, endTime: String
            let category: Category
        }
    }
    
    func toDTO() -> [CommunityRecruitingContent] {
        result.communityRecruitingContents.map {
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
                writer: .init(id: $0.writerId),
                community: community
            )
        }
    }
}
