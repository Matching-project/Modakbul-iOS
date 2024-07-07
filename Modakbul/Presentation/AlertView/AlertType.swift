//
//  AlertType.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import Foundation

enum AlertType {
    case warningBeforeSaveAlert
    case participationRequestSuccessAlert
    case allChatsDeleteAlert
    case reportUserConfirmationAlert(user: String)
    case blockUserConfirmationAlert(user: String)
    
    func alert(_ actions: [ConfirmationAction]) -> ConfirmationContent {
        switch self {
        case .warningBeforeSaveAlert:
            WarningBeforeSaveAlert(title: "저장되지 않아요!", message: "이전 화면으로 돌아가면 내용이 저장되지 않아요.\n정말 나가시겠어요?", actions: actions)
        case .participationRequestSuccessAlert:
            ParticipationRequestSuccessAlert(title: "참여 요청 완료!", message: "상대방이 수락하면 참여할 수 있어요.\n수락을 기다려주세요!", actions: actions)
        case .allChatsDeleteAlert:
            AllChatsDeleteAlert(title: "모든 채팅 삭제", message: "모든 채팅방에서 나갈까요?", actions: actions)
        case .reportUserConfirmationAlert(let user):
            ReportUserConfirmAlert(title: "\(user)을(를) 신고하려고 합니다.", message: "정말 신고하시겠어요?", actions: actions)
        case .blockUserConfirmationAlert(let user):
            BlockUserConfirmAlert(title: "\(user)을(를) 차단하려고 합니다.", message: "정말 차단하시겠어요?", actions: actions)
        }
    }
}
