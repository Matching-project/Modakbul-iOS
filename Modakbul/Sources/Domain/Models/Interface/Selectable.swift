//
//  Selectable.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

protocol Selectable: CaseIterable, CustomStringConvertible, Hashable, Identifiable {}

extension Selectable {
    var id: Int { self.hashValue }
}
