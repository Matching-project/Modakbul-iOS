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
            UserReportOrBlockConfirmationDialog(actions: actions)
        }
    }
}
