//
//  PushNotification.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

struct PushNotification: Identifiable {
    enum `Type` {
        case request
        case accept
        case newChat
        case exit
        
        var title: String {
            switch self {
            case .request: "님의 참여 요청"
            case .accept: "님의 참여 요청 수락"
            case .newChat: "님의 새로운 채팅"
            case .exit: "님 모임 참여 종료"
            }
        }
        
        var subtitle: String {
            switch self {
            case .request: " 카페모임에 참여 요청이 왔어요."
            case .accept: " 카페모임 참여 요청이 수락되었어요."
            case .newChat: "님이 보낸 새로운 채팅을 확인하세요."
            case .exit: " 카페모임을 나갔어요."
            }
        }
    }
    
    let id = UUID()
    let imageURL: URL?
    let title: String
    let titlePostfix: String
    let subtitle: String
    let timestamp: String
    let type: `Type`
    
    init(imageURL: URL?, title: String, subtitle: String, timestamp: String, type: `Type`) {
        self.imageURL = imageURL
        self.title = title
        self.titlePostfix = type.title
        self.subtitle = subtitle + type.subtitle
        // TODO: - 초/분/시간 전 표시하기
        self.timestamp = timestamp
        self.type = type
    }
}