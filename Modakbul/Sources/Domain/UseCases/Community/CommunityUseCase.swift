//
//  CommunityUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol CommunityUseCase {
    func createCommunityRecruitingContent(_ content: CommunityRecruitingContent) async throws
    
    func fetchCommunities(with placeId: Int64) async -> [CommunityRecruitingContent]
    /// 모집글 상세 정보 조회
    func readCommunityRecruitingContentDetail(with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent
    
}

// TODO: - UseCase 채택 필요
final class DefaultCommunityUseCase {
    
}
