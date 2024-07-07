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
struct WarningBeforeSaveAlert: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}

struct ParticipationRequestSuccessAlert: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}

struct AllChatsDeleteAlert: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}

struct ReportUserConfirmAlert: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}

struct BlockUserConfirmAlert: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}

// MARK: ConfirmationDialogs
struct UserReportOrBlockConfirmationDialog: ConfirmationContent {
    var title: String?
    var message: String?
    var actions: [ConfirmationAction?]
}
