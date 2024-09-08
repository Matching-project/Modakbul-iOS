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
    private let notificationUseCase: NotificationUseCase
    
    init(
//        chatUseCase: ChatUseCase,
        communityUseCase: CommunityUseCase,
        notificationUseCase: NotificationUseCase
    ) {
//        self.chatUseCase = chatUseCase
        self.communityUseCase = communityUseCase
        self.notificationUseCase = notificationUseCase
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

// MARK: Interface for CommunityUseCase
extension PlaceInformationDetailViewModel {
    func configureView(_ communityRecruitingContentId: Int64) async throws {
        let communityRecruitingContent = try await communityUseCase.readCommunityRecruitingContentDetail(with: communityRecruitingContentId)
        communityRecruitingContentSubject.send(communityRecruitingContent)
    }
}

// MARK: - Interface for NotificationUseCase
extension PlaceInformationDetailViewModel {
    @MainActor
    func send(_ communityRecruitingContentId: Int64,
              from userId: Int64,
              to opponentUserId: Int64,
              type: PushNotification.ShowingType) {
        Task {
            do {
                try await notificationUseCase.send(communityRecruitingContentId, from: userId, to: opponentUserId, type: type)
            } catch {
                print(error)
            }
        }
    }
}
