//
//  Location.swift
//  Modakbul
//
//  Created by Swain Yun on 6/15/24.
//

import Foundation

/**
 지도에 표시된 지점입니다.
 
 - Note: `Location`은 지도에 표시된 지점에 대한 단순한 정보입니다. 특별히 식별된 장소는 `Place`로 표현합니다.
 */
struct Location {
    let name: String?
    let coordinate: Coordinate?
}
