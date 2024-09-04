//
//  Report.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

// TODO: - Selectable로 하는건?
enum ReportType: CaseIterable, Hashable, CustomStringConvertible {
    case disparagement
    case pornography
    case commercialAdvertisement
    case fishing
    case religiousPropaganda
    case other
    
    var description: String {
        switch self {
        case .disparagement: "욕설/비하"
        case .pornography: "음란물/불건전한 만남 및 대화"
        case .commercialAdvertisement: "상업적 광고 및 판매"
        case .fishing: "유출/사칭/사기"
        case .religiousPropaganda: "과도한 종교 활동"
        case .other: "기타"
        }
    }
}

/// 신고 또는 문의에 대한 처리 상태를 표현합니다.
enum InquiryStatusType: String, Decodable {
    case completed = "COMPLETED"
    case waiting = "WAITING"
    case deleted = "DELETED"
}

/// 신고 내용을 표현합니다.
/// - Note: `ReportType`에 따라 내용을 구성해야 합니다.
///
/// * ReportType.other 의 경우, "기타: \(사용자가 작성한 내용)" 으로 내용을 구성합니다.
struct Report: Encodable {
    let content: String
}
