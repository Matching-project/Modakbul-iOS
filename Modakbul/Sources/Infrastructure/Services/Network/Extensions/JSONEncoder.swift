//
//  JSONEncoder.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/9/24.
//

import Foundation

protocol JSONEncodable {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: JSONEncodable {
    
}
