//
//  DependencyRegister.swift
//  Modakbul
//
//  Created by Swain Yun on 5/28/24.
//

import Foundation

protocol DependencyRegister {
    func register<T>(for type: T.Type, _ instance: T)
    func register<T>(for type: T.Type, _ handler: @escaping (DependencyResolver) -> T)
}
