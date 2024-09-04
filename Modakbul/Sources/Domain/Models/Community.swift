//
//  Community.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

struct Community {
    let routine: Routine
    let category: Category
    let participants: [User]
    let participantsCount: Int
    let participantsLimit: Int
    let meetingDate: String
    let startTime: String
    let endTime: String
    
    init(
        routine: Routine,
        category: Category,
        participants: [User] = [],
        participantsCount: Int? = nil,
        participantsLimit: Int,
        meetingDate: String,
        startTime: String,
        endTime: String
    ) {
        self.routine = routine
        self.category = category
        self.participants = participants
        self.participantsCount = participantsCount ?? participants.count
        self.participantsLimit = participantsLimit
        self.meetingDate = meetingDate
        self.startTime = startTime
        self.endTime = endTime
    }
}

struct CommunityRecruitingContent {
    let id: Int64
    let placeImageURLs: [URL?]
    let title: String
    let content: String
    let writtenDate: String?
    let writtenTime: String?
    let writer: User
    let community: Community
    let activeState: ActiveState
    
    init(
        id: Int64 = -1,
        placeImageURLs: [URL?] = [],
        title: String,
        content: String,
        writtenDate: String? = nil,
        writtenTime: String? = nil,
        writer: User? = nil,
        community: Community,
        activeState: ActiveState = .continue
    ) {
        self.id = id
        self.placeImageURLs = placeImageURLs
        self.title = title
        self.content = content
        self.writtenDate = writtenDate
        self.writtenTime = writtenTime
        self.writer = writer ?? User(id: id)
        self.community = community
        self.activeState = activeState
    }
}

/// 모임의 성격을 나타냅니다.
enum Routine: String, Codable {
    case daily = "ONE"
    case regular = "REGULAR"
}

/// 모임의 활성 상태를 나타냅니다.
enum ActiveState: String, Decodable {
    case `continue` = "CONTINUE"
    case completed = "COMPLETED"
    case deleted = "DELETED"
}
