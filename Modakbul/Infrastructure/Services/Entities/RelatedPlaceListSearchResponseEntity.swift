//
//  RelatedPlaceListSearchResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct RelatedPlaceListSearchResponseEntity: Decodable {
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
}
