//
//  NetworkService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol Requestable {
    func asURLRequest() -> URLRequest?
}

fileprivate enum NetworkServiceError: Error {
    case badResponse(statusCode: Int)
    case notConnectedToInternet
    case invalidURL
    case decodingError(type: String)
}

protocol NetworkService {
    func request<Response: Decodable>(endpoint: Requestable, for type: Response.Type) async throws -> Response
}

final class DefaultNetworkService {
    private let sessionManager: NetworkSessionManager
    private let decoder: JSONDecodable
    
    init(
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        decoder: JSONDecodable = JSONDecoder()
    ) {
        self.sessionManager = sessionManager
        self.decoder = decoder
    }
}
