//
//  CommunityRecruitingContentSearchResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 모집글 (수정) 정보 조회
struct CommunityRecruitingContentSearchResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let communityRecruitingContent: CommunityRecruitingContentEntity
        
        enum CodingKeys: String, CodingKey {
            case communityRecruitingContent = "board"
        }
    }
    
    func toDTO() -> CommunityRecruitingContent {
        result.communityRecruitingContent.toDTO()
    }
}

/// 상세 모집글 정보 조회
struct CommunityRecruitingContentSearchDetailResponseEntity: ResponseEntity {
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
        
        struct User: Decodable {
            let id: Int64
            let nickname: String
            let imageURL: URL?
            
            enum CodingKeys: String, CodingKey {
                case id, nickname
                case imageURL = "image"
            }
        }
        
        struct CommunityRecruitingContentDetail: Decodable {
            let id: Int64?
            let title, content, createdDate, createdTime, meetingDate, startTime, endTime: String
            let category: Category
            let recruitCount, currentCount: Int
            
            enum CodingKeys: String, CodingKey {
                case id, title, content, createdDate, createdTime, meetingDate, startTime, endTime, recruitCount, currentCount
                case category = "categoryName"
            }
        }
    }
    
    func toDTO() -> CommunityRecruitingContent {
        let user = User(
            id: result.user.id,
            nickname: result.user.nickname,
            imageURL: result.user.imageURL
        )
        
        let community = Community(
            routine: .daily,
            category: result.communityRecruitingContentDetail.category,
            participants: [user],
            participantsCount: result.communityRecruitingContentDetail.currentCount,
            participantsLimit: result.communityRecruitingContentDetail.recruitCount,
            meetingDate: result.communityRecruitingContentDetail.meetingDate,
            startTime: result.communityRecruitingContentDetail.startTime,
            endTime: result.communityRecruitingContentDetail.endTime
        )
        
        return .init(
            id: result.communityRecruitingContentDetail.id ?? Int64(Constants.loggedOutUserId),
            title: result.communityRecruitingContentDetail.title,
            content: result.communityRecruitingContentDetail.content,
            writtenDate: result.communityRecruitingContentDetail.createdDate,
            writtenTime: result.communityRecruitingContentDetail.createdTime,
            writer: user,
            community: community
        )
    }
}
