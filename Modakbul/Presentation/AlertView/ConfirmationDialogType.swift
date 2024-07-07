//
//  ConfirmationDialogType.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import Foundation

enum ConfirmationDialogType {
    case userReportOrBlockConfirmationDialog
    
    func confirmationDialog(_ actions: [ConfirmationAction]) -> ConfirmationContent {
        switch self {
        case .userReportOrBlockConfirmationDialog:
            UserReportOrBlockConfirmationDialog(title: "컨포메이션 타이틀", message: "컨포메이션 메시지", actions: actions)
        }
    }
}
