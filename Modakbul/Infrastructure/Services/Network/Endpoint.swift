//
//  Endpoint.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation
import CoreLocation

protocol Requestable {
    func asURLRequest() -> URLRequest?
}

enum Endpoint {
    case socialLogin(accessToken: String, refreshToken: String)
    case findPlace(keyword: String)
    case findPlaces(coordinate: CLLocationCoordinate2D)
    case chatRoom(from: UserEntity, to: UserEntity)
}

// MARK: Requestable Conformation
extension Endpoint: Requestable {
    func asURLRequest() -> URLRequest? {
        URLRequest(url: URL(string: "")!)
    }
}
