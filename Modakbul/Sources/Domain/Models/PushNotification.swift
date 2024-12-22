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
        case requestParticipation(communityRecruitingContentId: Int64)
        case acceptParticipation(communityRecruitingContentId: Int64)
        case newChat
        case exitParticipation
        case chat
        case unknown
        
        init(from type: String, communityRecruitingContentId: Int64) {
            switch type {
            case "requestParticipation": self = .requestParticipation(communityRecruitingContentId: communityRecruitingContentId)
            case "acceptParticipation": self = .acceptParticipation(communityRecruitingContentId: communityRecruitingContentId)
            case "newChat": self = .newChat
            case "exit": self = .exitParticipation
            case "chat": self = .chat
            default: self = .unknown
            }
        }
        
        private var baseMessages: (title: String, subtitle: String) {
            switch self {
            case .requestParticipation:
                return ("님의 참여 요청", " 카페모임에 참여 요청이 왔어요.")
            case .acceptParticipation:
                return ("님의 참여 요청 수락", " 카페모임 참여 요청이 수락되었어요.")
            case .newChat:
                return ("님의 새로운 채팅", "님이 보낸 새로운 채팅을 확인하세요.")
            case .exitParticipation:
                return ("님 참여 종료", " 카페모임을 나갔어요.")
            case .chat:
                return ("", "")
            case .unknown:
                return ("알 수 없음", "알 수 없는 에러입니다.")
            }
        }
        
        var titlePostfix: String { baseMessages.title }
        
        var subtitlePostfix: String { baseMessages.subtitle }
        
        var description: String {
            switch self {
            case .requestParticipation: "requestParticipation"
            case .acceptParticipation: "acceptParticipation"
            case .newChat: "newChat"
            case .exitParticipation: "exitParticipation"
            case .chat: "chat"
            case .unknown: "unknown"
            }
        }
        
        var route: Route? {
            switch self {
//                            case .requestParticipation(let communityRecruitingContentId): .placeInformationDetailView(communityRecruitingContentId: <#T##Int64#>, userId: <#T##Int64#>)
                //            case .acceptParticipation(let communityRecruitingContentId): .placeInformationDetailView(communityRecruitingContentId: communityRecruitingContentId)
//            case .newChat: .chatView(chatRoomId: ch)
            default: nil
            }
        }
    }
    
    let id: Int64
    let imageURL: URL?
    let title: String
    let subtitle: String
    let timestamp: String
    var type: ShowingType
    var isRead: Bool
    
    init(id: Int64,
         imageURL: URL? = nil,
         title: String,
         subtitle: String,
         timestamp: String = "",
         type: ShowingType,
         isRead: Bool = false
    ) async {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
        self.timestamp = await timestamp.toDate(by: .serverDateTime2)?.toDateComponent() ?? "방금 전"
        self.type = type
        self.isRead = isRead
    }
}

final class PushNotificationBuilder {
    private var title: String = ""
    private var subtitle: String = ""
    private var boardId: Int64 = Constants.temporalId
    private var type: PushNotification.ShowingType = .unknown
    
    static func create(type: PushNotification.ShowingType) -> PushNotificationBuilder {
        let builder = PushNotificationBuilder()
        builder.type = type
        return builder
    }
    
    func setSubtitle(_ communityRecruitingContentTitle: String) -> PushNotificationBuilder {
        self.subtitle = "\(communityRecruitingContentTitle)\(type.subtitlePostfix)"
        return self
    }
    
    func setTitle(_ senderNickname: String) -> PushNotificationBuilder {
        self.title = "\(senderNickname)\(type.titlePostfix)"
        return self
    }
    
    func build() async -> PushNotification {
        await .init(id: Constants.temporalId, title: title, subtitle: subtitle, type: type)
    }
}
