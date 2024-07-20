//
//  Place.swift
//  Modakbul
//
//  Created by Swain Yun on 5/30/24.
//

import Foundation

// TODO: 네이밍 아이디어 떠오르면 수정 예정
struct Place: Identifiable {
    let id: String
    let location: Location
    let communities: Community
    let images: [String]?
}
