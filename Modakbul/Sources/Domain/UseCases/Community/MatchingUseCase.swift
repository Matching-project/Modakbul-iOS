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
    func readMyMatches(userId: Int64) async throws -> [CommunityRelationship]
    
    /// 사용자가 참여 요청을 제출한 모임 목록 조회
    func readMyRequestMatches(userId: Int64) async throws -> [(relationship: CommunityRelationship, matchingId: Int64, matchState: MatchState)]
    
    /// 해당 모임에서 사용자의 역할을 확인합니다.
    /// - Returns: 기참여자, 미참여자 중 하나
    func checkUserRole(userId: Int64, with communityRecruitingContentId: Int64) async throws -> (role: UserRole, matchingId: Int64?, state: MatchState)
}

final class DefaultMatchingUseCase {
    private let matchingRepository: MatchingRepository
    
    init(matchingRepository: MatchingRepository) {
        self.matchingRepository = matchingRepository
    }
}

// MARK: MatchingUseCase Conformation
extension DefaultMatchingUseCase: MatchingUseCase {
    func readMatches(userId: Int64, with communityRecruitingContentId: Int64) async throws -> [ParticipationRequest] {
        try await matchingRepository.readMatches(userId: userId, with: communityRecruitingContentId)
    }
    
    func requestMatch(userId: Int64, with communityRecruitingContentId: Int64) async throws {
        try await matchingRepository.requestMatch(userId: userId, with: communityRecruitingContentId)
    }
    
    func acceptMatchRequest(userId: Int64, with matchingId: Int64) async throws {
        try await matchingRepository.acceptMatchRequest(userId: userId, with: matchingId)
    }
    
    func rejectMatchRequest(userId: Int64, with matchingId: Int64) async throws {
        try await matchingRepository.rejectMatchRequest(userId: userId, with: matchingId)
    }
    
    func exitMatch(userId: Int64, with matchingId: Int64) async throws {
        try await matchingRepository.exitMatch(userId: userId, with: matchingId)
    }
    
    func cancelMatchRequest(userId: Int64, with matchingId: Int64) async throws {
        try await matchingRepository.cancelMatchRequest(userId: userId, with: matchingId)
    }
    
    func readMyMatches(userId: Int64) async throws -> [CommunityRelationship] {
        try await matchingRepository.readMyMatches(userId: userId)
    }
    
    func readMyRequestMatches(userId: Int64) async throws -> [(relationship: CommunityRelationship, matchingId: Int64, matchState: MatchState)] {
        try await matchingRepository.readMyRequestMatches(userId: userId)
    }
    
    func checkUserRole(userId: Int64, with communityRecruitingContentId: Int64) async throws -> (role: UserRole, matchingId: Int64?, state: MatchState) {
        let matchRequests = try await matchingRepository.readMyRequestMatches(userId: userId)
        guard let request = matchRequests.first(where: { $0.relationship.communityRecruitingContent.id == communityRecruitingContentId }) else {
            return (UserRole.nonParticipant, nil, MatchState.cancel)
        }
        
        guard request.matchState == .accepted else {
            return (UserRole.nonParticipant, request.matchingId, request.matchState)
        }
        
        return (UserRole.participant, request.matchingId, request.matchState)
    }
}
