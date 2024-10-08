//
//  RelatedPlaceListSearchResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 사용자가 이용했던 장소 목록 조회 응답
///
/// 카페 제보/리뷰 목록 조회
struct RelatedPlaceListSearchResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let id: Int64
        let imageURL: URL?
        let name, address: String
        
        enum CodingKeys: String, CodingKey {
            case id, name, address
            case imageURL = "image"
        }
    }
    
    func toDTO() -> [Place] {
        result.map {
            .init(
                id: $0.id,
                location: .init(name: $0.name, address: $0.address),
                imageURLs: [$0.imageURL]
            )
        }
    }
}
