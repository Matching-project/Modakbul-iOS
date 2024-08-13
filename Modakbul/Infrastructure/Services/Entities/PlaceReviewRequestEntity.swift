//
//  PlaceReviewRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct PlaceReviewRequestEntity: Encodable {
    let powerSocketState: PowerSocketStateEntity
    let groupSeatingState: GroupSeatingStateEntity
    
    enum CodingKeys: String, CodingKey {
        case powerSocketState = "outlet"
        case groupSeatingState = "groupSeat"
    }
}
