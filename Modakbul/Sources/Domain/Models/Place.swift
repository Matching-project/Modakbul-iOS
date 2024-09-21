//
//  Place.swift
//  Modakbul
//
//  Created by Swain Yun on 5/30/24.
//

import Foundation

struct Place: Identifiable {
    let id: Int64
    let location: Location
    let openingHours: [OpeningHour]
    let powerSocketState: PowerSocketState
    let noiseLevel: NoiseLevel
    let groupSeatingState: GroupSeatingState
    let communityRecruitingContents: [CommunityRecruitingContent]
    let meetingCount: Int
    let imageURLs: [URL?]
    
    init(
        id: Int64 = Int64(Constants.loggedOutUserId),
        location: Location,
        openingHours: [OpeningHour] = [],
        powerSocketState: PowerSocketState = .moderate,
        noiseLevel: NoiseLevel = .moderate,
        groupSeatingState: GroupSeatingState = .unknown,
        communityRecruitingContents: [CommunityRecruitingContent] = [],
        meetingCount: Int = 0,
        imageURLs: [URL?] = []
    ) {
        self.id = id
        self.location = location
        self.openingHours = openingHours
        self.powerSocketState = powerSocketState
        self.noiseLevel = noiseLevel
        self.groupSeatingState = groupSeatingState
        self.communityRecruitingContents = communityRecruitingContents
        self.meetingCount = meetingCount
        self.imageURLs = imageURLs
    }
}
