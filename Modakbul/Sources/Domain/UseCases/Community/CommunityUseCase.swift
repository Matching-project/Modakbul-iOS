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
    
}
