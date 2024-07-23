//
//  ChatRoomConfiguation.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

struct ChatRoomConfiguation: Identifiable {
    let id: String
    let communityId: String
    let sender: User
    let receiver: User
}
