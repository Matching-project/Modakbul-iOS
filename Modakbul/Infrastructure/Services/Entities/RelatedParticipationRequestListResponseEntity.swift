//
//  RelatedParticipationRequestListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct RelatedParticipationRequestListResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let title, startTime, endTime: String
        let boardId: Int64
        let category: Category
        let recruitCount, currentCount: Int
        let meetingDate: String?
        let dayOfWeek: DayOfWeekEntity
        let boardStatus: BoardStatusEntity
    }
}
