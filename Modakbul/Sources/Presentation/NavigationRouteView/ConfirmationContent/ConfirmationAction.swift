//
//  AlertAction.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import Foundation

enum ConfirmationAction: Identifiable {
    case defaultAction(_ title: String, action: (() -> Void))
    case cancelAction(_ title: String, action: (() -> Void))
    case destructiveAction(_ title: String, action: (() -> Void))
    
    var id: String {
        switch self {
        case .defaultAction(let title, _): return title
        case .cancelAction(let title, _): return title
        case .destructiveAction(let title, _): return title
        }
    }
}
