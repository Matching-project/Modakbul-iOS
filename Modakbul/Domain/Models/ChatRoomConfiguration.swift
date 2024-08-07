//
//  ChatRoomConfiguration.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

struct ChatRoomConfiguration: Identifiable {
    let id: String
    let communityReqruitingContent: CommunityReqruitingContent
    let participants: [User]
}
