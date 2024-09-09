//
//  PlaceInformationDetailViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation
import Combine

final class PlaceInformationDetailViewModel: ObservableObject {
    @Published var communityRecruitingContent: CommunityRecruitingContent?
    @Published var role: UserRole = .nonParticipant
    
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
    private let matchingUseCase: MatchingUseCase
    
    init(
//        chatUseCase: ChatUseCase,
        communityUseCase: CommunityUseCase,
        matchingUseCase: MatchingUseCase
    ) {
//        self.chatUseCase = chatUseCase
        self.communityUseCase = communityUseCase
        self.matchingUseCase = matchingUseCase
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
    
    func checkUserRole(_ userId: Int64) async throws {
        // TODO: 로직 코드 스멜 있음: 복잡함, 용도에 맞지 않은 API 사용, 백엔드 협조 필요
        guard let communityRecruitingContent = communityRecruitingContent else { return }
        
    }
    
    func completeCommunityRecruiting(userId: Int64, with communityRecruitingContentId: Int64) {
        Task {
            do {
                try await communityUseCase.completeCommunityRecruiting(userId: userId, with: communityRecruitingContentId)
            } catch {
                print(error)
            }
        }
    }
    
    func exitCommunity(userId: Int64) {
        // TODO: 매칭id 필요
        Task {
            do {
                try await matchingUseCase.exitMatch(userId: userId, with: <#matchingId#>)
            } catch {
                print(error)
            }
        }
    }
}
