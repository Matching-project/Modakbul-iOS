//
//  MyCommunityRecruitingContentListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct MyCommunityRecruitingContentListResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let boardId: Int64
        let title, startTime, endTime: String
        let dayOfWeek: DayOfWeekEntity
        let category: Category
        let recruitCount, currentCount: Int
        let meetingDate: String?
        let boardStatus: BoardStatusEntity
    }
}

enum BoardStatusEntity: String, Decodable {
    case `continue` = "CONTINUE"
    case completed = "COMPLETED"
    case deleted = "DELETED"
}
