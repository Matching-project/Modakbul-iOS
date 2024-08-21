//
//  Assembly.swift
//  Modakbul
//
//  Created by Swain Yun on 5/29/24.
//

import Foundation

protocol Assembly {
    func assemble(container: DependencyContainer)
    func loaded(resolver: DependencyResolver)
}
