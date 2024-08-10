//
//  SocketEndpoint.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/11/24.
//

import Foundation
import Alamofire

protocol URLComponentsConvertible {
    var httpMethod: HTTPMethod { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    
    func asURLComponents() -> URLComponents
}

extension URLComponentsConvertible {
    func asURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components
    }
}

protocol Requestable: URLComponentsConvertible {
    var httpHeaders: HTTPHeaders? { get }
    var httpBodies: [Data]? { get }
    
    var encoder: JSONEncodable { get }
}

extension Requestable {
    var encoder: JSONEncodable { JSONEncoder() }
}

enum SocketEndpoint {
    // TODO: - STOMP 공부 후, API 양식 재검토 할 것
    // https://www.notion.so/3014658e52404ef794d399d5e65780e6?pvs=4
//    case sendChatMessage(token: String, chatRoomId: String)
}

// TODO: - 구현 필요
extension SocketEndpoint: Requestable {
    // TODO: - WIP: Requestable 구현
    var httpHeaders: Alamofire.HTTPHeaders?
    
    var httpBodies: [Data]?
    
    var httpMethod: Alamofire.HTTPMethod
    
    var scheme: String
    
    var host: String
    
    var path: String
    
    var queryItems: [URLQueryItem]?
}
