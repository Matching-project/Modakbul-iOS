//
//  CommunityUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol CommunityUseCase {
    /// 모집글 작성
    func createCommunityRecruitingContent(userId: Int64, placeId: Int64, _ content: CommunityRecruitingContent) async throws
    
    /// 모집글 목록 조회
    func readCommunityRecruitingContents(placeId: Int64) async throws -> [CommunityRecruitingContent]
    
    /// 모집글 조회
    func readCommunityRecruitingContent(userId: Int64, with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent
    
    /// 모집글 수정
    func updateCommunityRecruitingContent(userId: Int64, _ content: CommunityRecruitingContent) async throws
    
    /// 모집글 삭제
    func deleteCommunityRecruitingContent(userId: Int64, _ content: CommunityRecruitingContent) async throws
    
    /// 모집글 상세 정보 조회
    func readCommunityRecruitingContentDetail(with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent
    
    /// 모집글 모집 종료
    func completeCommunityRecruiting(userId: Int64, with communityRecruitingContentId: Int64) async throws
    
    /// 사용자와 관련된 모집글 목록 조회
    func readMyCommunityRecruitingContents(userId: Int64) async throws -> [CommunityRecruitingContent]
}

final class DefaultCommunityUseCase {
    private let communityRepository: CommunityRepository
    
    init(communityRepository: CommunityRepository) {
        self.communityRepository = communityRepository
    }
}

// MARK: CommunityUseCase Conformation
extension DefaultCommunityUseCase: CommunityUseCase {
    func createCommunityRecruitingContent(userId: Int64, placeId: Int64, _ content: CommunityRecruitingContent) async throws {
        try await communityRepository.createCommunityRecruitingContent(userId: userId, placeId: placeId, content)
    }
    
    func readCommunityRecruitingContents(placeId: Int64) async throws -> [CommunityRecruitingContent] {
        try await communityRepository.readCommunityRecruitingContents(placeId: placeId)
    }
    
    func readCommunityRecruitingContent(userId: Int64, with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent {
        try await communityRepository.readCommunityRecruitingContent(userId: userId, with: communityRecruitingContentId)
    }
    
    func updateCommunityRecruitingContent(userId: Int64, _ content: CommunityRecruitingContent) async throws {
        try await communityRepository.updateCommunityRecruitingContent(userId: userId, content)
    }
    
    func deleteCommunityRecruitingContent(userId: Int64, _ content: CommunityRecruitingContent) async throws {
        try await communityRepository.deleteCommunityRecruitingContent(userId: userId, content)
    }
    
    func readCommunityRecruitingContentDetail(with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent {
        try await communityRepository.readCommunityRecruitingContentDetail(with: communityRecruitingContentId)
    }
    
    func completeCommunityRecruiting(userId: Int64, with communityRecruitingContentId: Int64) async throws {
        try await communityRepository.completeCommunityRecruiting(userId: userId, with: communityRecruitingContentId)
    }
    
    func readMyCommunityRecruitingContents(userId: Int64) async throws -> [CommunityRecruitingContent] {
        try await communityRepository.readMyCommunityRecruitingContents(userId: userId)
    }
}
