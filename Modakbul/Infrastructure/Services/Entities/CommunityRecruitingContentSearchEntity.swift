//
//  CommunityRecruitingContentSearchEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct CommunityRecruitingContentSearchEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let placeName, address: String
        let communityRecruitingContent: CommunityRecruitingContentEntity
        
        enum CodingKeys: String, CodingKey {
            case address
            case placeName = "cafe_name"
            case communityRecruitingContent = "board"
        }
    }
}

struct CommunityRecruitingContentSearchDetailEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let imageURLs: [String]
        let user: User
        let communityRecruitingContentDetail: CommunityRecruitingContentDetail
        
        enum CodingKeys: String, CodingKey {
            case user
            case imageURLs = "images"
            case communityRecruitingContentDetail = "board"
        }
    }
    
    struct User: Decodable {
        let nickname: String
        let imageURL: URL?
        
        enum CodingKeys: String, CodingKey {
            case nickname
            case imageURL = "image"
        }
    }
    
    struct CommunityRecruitingContentDetail: Decodable {
        let title, content, category, createdDate, createdTime, meetingDate, startTime, endTime: String
        let recruitCount, currentCount: Int
        
        enum CodingKeys: String, CodingKey {
            case title, content, category
            case createdDate = "created_date"
            case createdTime = "created_time"
            case meetingDate = "meeting_date"
            case startTime = "startTime"
            case endTime = "endTime"
            case recruitCount = "recruit_count"
            case currentCount = "current_count"
        }
    }
}
