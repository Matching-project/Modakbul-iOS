//
//  PreviewHelper.swift
//  Modakbul
//
//  Created by Swain Yun on 7/22/24.
//

import SwiftUI

extension PreviewProvider {
    static var previewHelper: PreviewHelper { PreviewHelper.shared }
    static var router: DefaultAppRouter { previewHelper.router }
}

final class PreviewHelper {
    static let shared = PreviewHelper()
    
    let router = DefaultAppRouter(by: InfrastructureAssembly(),
                                 DataAssembly(),
                                 DomainAssembly(),
                                 PresentationAssembly())
    
    var resolver: DependencyResolver { router.resolver }
    
    private init() {}
}
