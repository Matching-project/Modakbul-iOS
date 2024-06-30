//
//  JSONEncoder.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

protocol JSONEncodable {
    func encode<T: Encodable>(_ type: T) throws -> Data
}

extension JSONEncoder: JSONEncodable {
    
}
