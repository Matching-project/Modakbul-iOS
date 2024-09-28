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
        id: Int64 = Int64(Constants.loggedOutUserId),
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
    /// 일일모임
    case daily = "ONE"
    
    /// 정기모임
    case regular = "REGULAR"
}

/// 모임의 활성 상태를 나타냅니다.
enum ActiveState: String, Decodable {
    case `continue` = "CONTINUE"
    case completed = "COMPLETED"
    case deleted = "DELETED"
}

/// Match Request의 활성 상태를 나타냅니다.
enum MatchState: String, Decodable {
    /// 참여 요청 중 (참여 요청이 제출된 상태에서 상대방의 수락, 거절 의사를 기다리는 중)
    case pending = "PENDING"
    
    /// 요청 거절됨
    case rejected = "REJECTED"
    
    /// 요청 수락됨
    case accepted = "ACCEPTED"
    
    /// 요청 삭제됨 (pending 상태에서 상대방의 수락, 거절 의사를 대기하지 않고 취소했을 경우 + 아무런 상호작용 없을 때 기본값)
    case cancel = "CANCEL"
    
    /// 모임 탈퇴됨 (accepted 상태에서 모임을 나갈 의사를 제출했을 경우)
    case exit = "EXIT"
}
