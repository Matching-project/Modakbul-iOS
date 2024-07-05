//
//  AlertContent.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import Foundation

protocol AlertContent {
    var title: String { get }
    var message: String? { get }
    var actions: [AlertAction?] { get }
}

struct WarningBeforeSaveAlert: AlertContent {
    var title: String
    var message: String?
    var actions: [AlertAction?]
}

struct ParticipationRequestSuccessAlert: AlertContent {
    var title: String
    var message: String?
    var actions: [AlertAction?]
}

struct AllChatsDeleteAlert: AlertContent {
    var title: String
    var message: String?
    var actions: [AlertAction?]
}
