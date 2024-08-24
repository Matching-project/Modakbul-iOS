//
//  ConfirmationContent.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import Foundation

protocol ConfirmationContent {
    var title: String? { get }
    var message: String? { get }
    var actions: [ConfirmationAction?] { get }
}

// MARK: Alerts
struct Alert: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}

// MARK: ConfirmationDialogs
struct Dialog: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}
