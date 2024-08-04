//
//  Tokens.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/10/24.
//

import Foundation

protocol TokensProtocol: Codable {
    var accessToken: String { get }
    var refreshToken: String { get }
}

struct TokensEntity: TokensProtocol {
    let accessToken: String
    let refreshToken: String
}
