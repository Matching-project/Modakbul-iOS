//
//  CommunityRecruitingContentListEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/12/24.
//

import Foundation

struct CommunityRecruitingContentListEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let place: Place
        let communityRecruitingContents: [CommunityRecruitingContent]
    }
    
    struct Place: Decodable {
        let name, address: String
        let imageURL: URL?
        let openingHour: [OpeningHourEntity]
        let powerSocketState: PowerSocketStateEntity
        let noiseLevel: NoiseLevelEntity
        let groupSeatingState: GroupSeatingStateEntity
        
        enum CodingKeys: String, CodingKey {
            case name, address
            case imageURL = "image"
            case openingHour = "opening_hour"
            case powerSocketState = "outlet"
            case noiseLevel = "congestion"
            case groupSeatingState = "groupSeat"
        }
    }
    
    struct CommunityRecruitingContent: Decodable {
        let writerId, id, recruitCount, currentCount: Int
        let title, category, meetingDate, startTime, endTime: String
        
        enum CodingKeys: String, CodingKey {
            case id, title, category
            case writerId = "writer_id"
            case recruitCount = "recruit_count"
            case currentCount = "current_count"
            case meetingDate = "meeting_date"
            case startTime = "start_time"
            case endTime = "end_time"
        }
    }
}
