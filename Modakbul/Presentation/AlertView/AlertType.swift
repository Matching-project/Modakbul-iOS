//
//  AlertType.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import SwiftUI

enum AlertType {
    case warningBeforeSaveAlert
    
    var title: String {
        switch self {
        case .warningBeforeSaveAlert: return "정말 나가시겠어요?"
        }
    }
    
    var message: String? {
        switch self {
        case .warningBeforeSaveAlert: return "뒤로 가면 내용이 저장되지 않습니다."
        }
    }
    
    func alert(_ actions: [AlertAction]) -> AlertContent {
        switch self {
        case .warningBeforeSaveAlert:
            WarningBeforeSaveAlert(title: title, message: message, actions: actions)
        }
    }
}
