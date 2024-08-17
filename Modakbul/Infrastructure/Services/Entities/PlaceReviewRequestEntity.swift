//
//  PlaceReviewRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 카페 제보 요청
struct PlaceReviewRequestEntity: Encodable {
    let powerSocketState: PowerSocketState
    let groupSeatingState: GroupSeatingState
    
    enum CodingKeys: String, CodingKey {
        case powerSocketState = "outlet"
        case groupSeatingState = "groupSeat"
    }
}
