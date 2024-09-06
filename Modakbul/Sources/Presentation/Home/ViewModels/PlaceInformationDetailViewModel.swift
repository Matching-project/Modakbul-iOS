//
//  PlaceInformationDetailViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation
import Combine

/// 사용자 역할을 나타냅니다.
enum UserRole {
    /// 대표자, 방장, 모집글 게시자
    case exponent
    
    /// 기참여자
    case participant
    
    /// 미참여자
    case nonParticipant
}

final class PlaceInformationDetailViewModel: ObservableObject {
    @Published var communityRecruitingContent: CommunityRecruitingContent?
    @Published var role: UserRole = .participant
    
    // MARK: Presenting Data
    @Published var category: String = String()
    @Published var recruitingCount: String = String()
    @Published var meetingDate: String = String()
    @Published var meetingTime: String = String()
    @Published var title: String = String()
    @Published var content: String = String()
    @Published var creationDate: String = String()
    @Published var writer: User = User()
    
    private let communityRecruitingContentSubject = PassthroughSubject<CommunityRecruitingContent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
//    private let chatUseCase: ChatUseCase
    private let communityUseCase: CommunityUseCase
    
    init(
//        chatUseCase: ChatUseCase,
        communityUseCase: CommunityUseCase
    ) {
//        self.chatUseCase = chatUseCase
        self.communityUseCase = communityUseCase
        subscribe()
    }
    
    private func subscribe() {
        communityRecruitingContentSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] content in
                self?.communityRecruitingContent = content
            }
            .store(in: &cancellables)
        
        $communityRecruitingContent
            .sink { [weak self] content in
                guard let content = content else { return }
                let community = content.community
                self?.category = community.category.description
                self?.recruitingCount = "\(community.participantsCount)/\(community.participantsLimit)"
                let meetingDateComponents = community.meetingDate.split(separator: "-")
                self?.meetingDate = "\(meetingDateComponents[1])월 \(meetingDateComponents[2])일"
                self?.meetingTime = "\(community.startTime)~\(community.endTime)"
                if let creationDateComponents = content.writtenDate?.split(separator: "-") {
                    self?.creationDate = creationDateComponents.joined(separator: ". ")
                }
                self?.title = content.title
                self?.content = content.content
                self?.writer = content.writer
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension PlaceInformationDetailViewModel {
    func configureView(_ communityRecruitingContentId: Int64) async throws {
        let communityRecruitingContent = try await communityUseCase.readCommunityRecruitingContentDetail(with: communityRecruitingContentId)
        communityRecruitingContentSubject.send(communityRecruitingContent)
    }
}
