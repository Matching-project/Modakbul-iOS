//
//  ReportsResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/1/24.
//

import Foundation

/// 신고 목록 조회 응답
struct ReportsResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let messages: String
    let result: [Result]
    
    struct Result: Decodable {
        let imageURL: URL?
        let nickname: String
        let category: Set<Category>
        let job: Job
        let inquiryStatus: InquiryStatusType
        
        enum CodingKeys: String, CodingKey {
            case nickname, job
            case imageURL = "image"
            case category = "categoryName"
            case inquiryStatus = "status"
        }
    }
    
    func toDTO() -> [(user: User, status: InquiryStatusType)] {
        result.map {
            let user = User(
                nickname: $0.nickname,
                job: $0.job,
                categoriesOfInterest: $0.category,
                imageURL: $0.imageURL
            )
            
            return (user, $0.inquiryStatus)
        }
    }
}
