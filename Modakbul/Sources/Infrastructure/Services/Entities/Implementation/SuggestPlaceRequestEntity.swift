//
//  SuggestPlaceRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/1/24.
//

import Foundation

/// 카페 제보 요청
struct SuggestPlaceRequestEntity: Encodable {
    let name: String
    let location: LocationEntity
    let powerSocketState: PowerSocketState
    let groupSeatingState: GroupSeatingState
    
    init(
        name: String,
        location: LocationEntity,
        powerSocketState: PowerSocketState,
        groupSeatingState: GroupSeatingState
    ) {
        self.name = name
        self.location = location
        self.powerSocketState = powerSocketState
        self.groupSeatingState = groupSeatingState
    }
    
    init(place: Place) {
        let location = place.location
        self.name = location.name
        self.location = LocationEntity(latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude,
                                       address: location.address)
        self.powerSocketState = place.powerSocketState
        self.groupSeatingState = place.groupSeatingState
    }
    
    enum CodingKeys: String, CodingKey {
        case name, location
        case powerSocketState = "outlet"
        case groupSeatingState = "groupSeat"
    }
}
