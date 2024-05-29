//
//  DependencyContainer.swift
//  Modakbul
//
//  Created by Swain Yun on 5/27/24.
//

import Foundation

typealias DependencyContainer = DependencyRegister & DependencyResolver

final class DefaultDependencyContainer {
    private var dependencies: [String: Any] = [:]
    
    private func key<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    
    private func _register<T>(for type: T.Type, _ item: Any) {
        let key = key(for: type)
        dependencies[key] = item
    }
    
    private func _resolve<T>(_ type: T.Type) -> T {
        let key = key(for: type)
        if let instance = dependencies[key] as? T {
            return instance
        } else if let closure = dependencies[key] as? (DependencyResolver) -> T {
            return closure(self)
        } else {
            fatalError("의존성 객체를 찾을 수 없음.")
        }
    }
}

// MARK: DependencyContainer Confirmation
extension DefaultDependencyContainer: DependencyContainer {
    func register<T>(for type: T.Type, _ instance: T) {
        _register(for: type, instance)
    }
    
    func register<T>(for type: T.Type, _ handler: @escaping (any DependencyResolver) -> T) {
        _register(for: type, handler)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        _resolve(type)
    }
}
