//
//  NetworkServiceError.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 6/27/24.
//

enum NetworkServiceError: Error {
    case badResponse(statusCode: Int)
    case notConnectedToInternet
    case invalidURL
    case decodingError(type: String)
    case generic(type: String)
    case requestFailed
}
