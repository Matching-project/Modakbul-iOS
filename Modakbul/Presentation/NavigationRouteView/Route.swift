//
//  Route.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

protocol Routable: Hashable, Identifiable {
    var presentingType: PresentingType { get }
}

extension Routable {
    var id: Self { self }
}

enum PresentingType {
    case push
    case sheet(detent: PresentationDetent)
    case fullScreenCover
}

enum Route: Routable {
    case loginView
    case homeView
    case myView
    
    var presentingType: PresentingType {
        switch self {
        case .loginView: .fullScreenCover
        case .homeView: .push
        case .myView: .push
        }
    }
}
