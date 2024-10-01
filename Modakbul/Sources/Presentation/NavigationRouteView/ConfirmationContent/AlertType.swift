//
//  AlertType.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import Foundation

enum AlertType {
    /// 저장 전 경고 알림입니다.
    case warningBeforeSave
    /// 참여 요청 완료 알림입니다.
    case participationRequestSuccess
    /// 모든 채팅 삭제 알림입니다.
    case allChatsDelete
    /// 신고화면으로 이동 전 경고 알림입니다.
    case reportUser
    /// 신고 완료 알림입니다.
    case reportUserConfirmation
    /// 사용자 차단 알림입니다.
    case blockUserConfirmation
    /// 로그인 의사를 물어보는 알림입니다.
    case login
    /// 로그아웃 알림입니다.
    case logout
    /// 제보/리뷰 완료 알림입니다.
    case showcaseAndReviewSuccess
    
    func alert(_ actions: [ConfirmationAction]) -> ConfirmationContent {
        switch self {
        case .warningBeforeSave:
            Alert(title: "저장되지 않아요!", message: "이전 화면으로 돌아가면 내용이 저장되지 않아요.\n정말 나가시겠어요?", actions: actions)
        case .participationRequestSuccess:
            Alert(title: "참여 요청 완료!", message: "상대방이 수락하면 참여할 수 있어요.\n수락을 기다려주세요!", actions: actions)
        case .allChatsDelete:
            Alert(title: "모든 채팅 삭제", message: "모든 채팅방에서 나갈까요?", actions: actions)
        case .reportUser:
            Alert(title: "정말 신고하시겠어요?", message: "허위 신고 적발 시 계정 사용이 중지됩니다.", actions: actions)
        case .reportUserConfirmation:
            Alert(title: "신고 완료", message: "관리자가 검토하기까지 2~3일 정도 소요됩니다. 마이페이지 - 나의 신고내역에서 상태를 확인할 수 있어요.", actions: actions)
        case .blockUserConfirmation:
            Alert(title: "정말 차단하시겠어요?", message: "차단하면 서로의 게시글이 보이지 않고, 채팅을 주고받을 수 없어요.\n또한, 상대방은 차단 여부를 알 수 없어요.", actions: actions)
        case .login:
            Alert(message: "로그인이 필요한 서비스입니다.\n로그인하시겠어요?", actions: actions)
        case .logout:
            Alert(message: "정말 로그아웃하시겠어요?", actions: actions)
        case .showcaseAndReviewSuccess:
            Alert(title: "카페 제보/리뷰 완료!", message: "관리자가 검토한 후 반영됩니다.", actions: actions)
        }
    }
}
