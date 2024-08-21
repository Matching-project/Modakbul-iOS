//
//  DependencyResolver.swift
//  Modakbul
//
//  Created by Swain Yun on 5/28/24.
//

import Foundation

protocol DependencyResolver {
    func resolve<T>(_ type: T.Type) -> T
}
