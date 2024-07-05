//
//  AlertAction.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import Foundation

enum AlertAction: Identifiable {
    case defaultAction(_ title: String, action: @autoclosure (() -> Void))
    case cancelAction(_ title: String, action: @autoclosure (() -> Void))
    case destructiveAction(_ title: String, action: @autoclosure (() -> Void))
    
    var id: UUID { UUID() }
}
