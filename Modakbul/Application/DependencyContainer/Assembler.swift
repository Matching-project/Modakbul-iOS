//
//  Assembler.swift
//  Modakbul
//
//  Created by Swain Yun on 5/29/24.
//

import Foundation

final class Assembler {
    private let container: DependencyContainer
    
    var resolver: DependencyResolver { container }
    
    init(container: DependencyContainer = DefaultDependencyContainer()) {
        self.container = container
    }
    
    init(
        container: DependencyContainer = DefaultDependencyContainer(),
        by assemblies: Assembly...
    ) {
        self.container = container
        run(assemblies: assemblies)
    }
    
    private func run(assemblies: [Assembly]) {
        for assembly in assemblies {
            assembly.assemble(container: container)
        }
        
        for assembly in assemblies {
            assembly.loaded(resolver: resolver)
        }
    }
    
    func apply(assemblies: Assembly...) {
        run(assemblies: assemblies)
    }
    
    func apply(assembly: Assembly) {
        run(assemblies: [assembly])
    }
}
