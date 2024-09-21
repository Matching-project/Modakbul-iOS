//
//  PlacesSortOption.swift
//  Modakbul
//
//  Created by Swain Yun on 8/18/24.
//

import Foundation

/// 카페 정렬 기준
enum PlaceSortCriteria: Selectable {
    case distance
    case matchesCount
    
    var description: String {
        switch self {
        case .distance: "거리순"
        case .matchesCount: "모임 많은순"
        }
    }
}
