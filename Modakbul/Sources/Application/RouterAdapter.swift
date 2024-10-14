//
//  RouterAdaptor.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/6/24.
//

import Foundation

final class RouterAdapter {
    typealias Destination = Route
    
    @Published var destionation: Destination?
    static let shared = RouterAdapter()
    
    private init () {}
}
