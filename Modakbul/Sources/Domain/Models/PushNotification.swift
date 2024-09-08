//
//  PushNotification.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation
import SwiftUI

struct PushNotification: Identifiable {
    enum ShowingType: CustomStringConvertible {
        case request(communityRecruitingContentId: Int64)
        case accept(communityRecruitingContentId: Int64)
        case newChat
        case exit
        case unknown
        
        init(from type: String, communityRecruitingContentId: Int64) {
            switch type {
            case "request": self = .request(communityRecruitingContentId: communityRecruitingContentId)
            case "accept": self = .accept(communityRecruitingContentId: communityRecruitingContentId)
            case "newChat": self = .newChat
            case "exit": self = .exit
            default: self = .unknown
            }
        }
        
        var titlePostfix: String {
            switch self {
            case .request: "님의 참여 요청"
            case .accept: "님의 참여 요청 수락"
            case .newChat: "님의 새로운 채팅"
            case .exit: "님 모임 참여 종료"
            default: "알 수 없는 에러입니다"
            }
        }
        
        var subtitlePostfix: String {
            switch self {
            case .request: " 카페모임에 참여 요청이 왔어요."
            case .accept: " 카페모임 참여 요청이 수락되었어요."
            case .newChat: "님이 보낸 새로운 채팅을 확인하세요."
            case .exit: " 카페모임을 나갔어요."
            default: "알 수 없는 에러입니다"
            }
        }
        
        var description: String {
            switch self {
            case .request: "request"
            case .accept: "accept"
            case .newChat: "newChat"
            case .exit: "exit"
            case .unknown: "unknown"
            }
        }
        
        var route: Route? {
            switch self {
            case .request(let communityRecruitingContentId): .placeInformationDetailView(communityRecruitingContentId: communityRecruitingContentId)
            case .accept(let communityRecruitingContentId): .placeInformationDetailView(communityRecruitingContentId: communityRecruitingContentId)
            case .newChat: .chatView
            default: nil
            }
        }
    }
    
    let id: Int64
    let imageURL: URL?
    let title: String
    let titlePostfix: String
    let subtitle: String
    let timestamp: String
    var type: ShowingType
    var isRead: Bool
    
    init(id: Int64,
         imageURL: URL? = nil,
         title: String,
         subtitle: String,
         timestamp: String,
         type: ShowingType,
         isRead: Bool = false
    ) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.titlePostfix = type.titlePostfix
        self.subtitle = subtitle + type.subtitlePostfix
        // TODO: - 초/분/시간 전 표시하기
        self.timestamp = timestamp
        self.type = type
        self.isRead = isRead
    }
}
