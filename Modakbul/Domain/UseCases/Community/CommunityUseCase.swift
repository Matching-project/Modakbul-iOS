//
//  CommunityUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol CommunityUseCase {
    func fetchCommunities(_ location: Location) async -> [CommunityRecruitingContent]
    // TODO: 네이밍 수정 될 여지가 있음
    func fetchCommunities(by userId: String, asWriter: Bool, included: Bool) async -> [CommunityRecruitingContent]
    func fetchCommunity(on chatRoomId: String, with communityId: String) async -> CommunityRecruitingContent
    
    // 요청자 유즈케이스
    func participate(_ communityId: String, _ userId: String) async
    // TODO: 취소랑 나가는 상황에 모두 대비 가능한지 확인해볼 필요 있음
    func cancel(_ communityId: String, _ userId: String) async
    
    // 게시자 유즈케이스
    func fetchParticipantsList(_ communityId: String) async -> [User]
    func startReqruiting() async
    func stopReqruiting() async
    func accept() async
    func reject() async
    
    func write(on location: Location, content: CommunityRecruitingContent) async throws
}
