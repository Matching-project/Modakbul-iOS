//
//  Endpoint.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol Requestable {
    func asURLRequest() -> URLRequest?
}

enum Endpoint {
    case socialLogin(accessToken: String, refreshToken: String)
}

// MARK: Requestable Confirmation
extension Endpoint: Requestable {
    func asURLRequest() -> URLRequest? {
        URLRequest(url: URL(string: "")!)
    }
}
