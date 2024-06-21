//
//  URLSession.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse)
    func webSocketTask(with urlRequest: URLRequest) -> URLSessionWebSocketTask
}

extension URLSession: URLSessionProtocol {
    
}
