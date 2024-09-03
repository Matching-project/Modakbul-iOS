//
//  ResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

protocol ResponseEntity: Decodable {
    var status: Bool { get }
    var code: Int { get }
    var message: String { get }
}
