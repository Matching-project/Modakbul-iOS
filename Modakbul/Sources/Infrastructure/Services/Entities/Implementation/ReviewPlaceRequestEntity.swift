//
//  ReviewPlaceRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/1/24.
//

import Foundation

/// 카페 리뷰 요청
struct ReviewPlaceRequestEntity: Encodable {
    let powerSocketState: PowerSocketState
    let groupSeatingState: GroupSeatingState
    
    enum CodingKeys: String, CodingKey {
        case powerSocketState = "outlet"
        case groupSeatingState = "groupSeat"
    }
}
