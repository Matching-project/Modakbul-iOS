//
//  MatchingUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 9/2/24.
//

import Foundation

protocol MatchingUseCase {
    /// 모임 참여 요청 목록 조회
    func readMatches(userId: Int64, with communityRecruitingContentId: Int64) async throws -> [ParticipationRequest]
    
    /// 모임 참여 요청
    func requestMatch(userId: Int64, with communityRecruitingContentId: Int64) async throws
    
    /// 모임 참여 요청 수락
    func acceptMatchRequest(userId: Int64, with matchingId: Int64) async throws
    
    /// 모임 참여 요청 거절
    func rejectMatchRequest(userId: Int64, with matchingId: Int64) async throws
    
    /// 모임 탈퇴
    func exitMatch(userId: Int64, with matchingId: Int64) async throws
    
    /// 모임 참여 요청 취소
    func cancelMatchRequest(userId: Int64, with matchingId: Int64) async throws
    
    /// 사용자와 관련된 참여 모임 목록 조회
    func readMyMatches(userId: Int64) async throws -> [CommunityRecruitingContent]
    
    /// 사용자가 참여 요청을 제출한 모임 목록 조회
    func readMyRequestMatches(userId: Int64) async throws -> [CommunityRecruitingContent]
}

final class DefaultMatchingUseCase {
    
}

// MARK: MatchingUseCase Conformation
extension DefaultMatchingUseCase {
    
}
