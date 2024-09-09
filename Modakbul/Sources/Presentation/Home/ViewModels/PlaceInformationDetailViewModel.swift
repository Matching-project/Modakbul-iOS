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
    @Published var matchState: MatchState = .cancel
    
    // MARK: Presenting Data
    @Published var category: String = String()
    @Published var recruitingCount: String = String()
    @Published var meetingDate: String = String()
    @Published var meetingTime: String = String()
    @Published var title: String = String()
    @Published var content: String = String()
    @Published var creationDate: String = String()
    @Published var writer: User = User()
    
    private var matchingId: Int64 = -1
    private var userId: Int64 = -1
    
    private let communityRecruitingContentSubject = PassthroughSubject<CommunityRecruitingContent, Never>()
    private let userRoleSubject = PassthroughSubject<(role: UserRole, matchingId: Int64?, state: MatchState), Never>()
    private var cancellables = Set<AnyCancellable>()
    
//    private let chatUseCase: ChatUseCase
    private let communityUseCase: CommunityUseCase
    private let matchingUseCase: MatchingUseCase
    private let notificationUseCase: NotificationUseCase
    
    init(
//        chatUseCase: ChatUseCase,
        communityUseCase: CommunityUseCase,
        matchingUseCase: MatchingUseCase,
        notificationUseCase: NotificationUseCase
    ) {
//        self.chatUseCase = chatUseCase
        self.communityUseCase = communityUseCase
        self.matchingUseCase = matchingUseCase
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
        
        userRoleSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (role, matchingId, state) in
                self?.role = role
                self?.matchingId = matchingId ?? -1
                self?.matchState = state
            }
            .store(in: &cancellables)
    }
}

// MARK: Interface for CommunityUseCase
extension PlaceInformationDetailViewModel {
    func configureView(_ communityRecruitingContentId: Int64, _ userId: Int64) async throws {
        self.userId = userId
        
        let communityRecruitingContent = try await communityUseCase.readCommunityRecruitingContentDetail(with: communityRecruitingContentId)
        communityRecruitingContentSubject.send(communityRecruitingContent)
        
        // 모집글 작성자의 id와 사용자의 id가 같으면 role은 exponent, 다르면 사용자 역할 확인 작업 전개
        guard communityRecruitingContent.writer.id != userId else {
            return userRoleSubject.send((.exponent, nil, .cancel))
        }
        
        let (role, matchingId, state) = try await matchingUseCase.checkUserRole(userId: userId, with: communityRecruitingContentId)
        userRoleSubject.send((role, matchingId, state))
    }
    
    func completeCommunityRecruiting() {
        guard let id = communityRecruitingContent?.id else { return }
        
        Task {
            do {
                try await communityUseCase.completeCommunityRecruiting(userId: userId, with: id)
            } catch {
                print(error)
            }
        }
    }
    
    func exitCommunity() {
        Task {
            do {
                try await matchingUseCase.exitMatch(userId: userId, with: matchingId)
            } catch {
                print(error)
            }
        }
    }
    
    func requestMatch() {
        guard let id = communityRecruitingContent?.id else { return }
        
        Task {
            do {
                try await matchingUseCase.requestMatch(userId: userId, with: id)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Interface for NotificationUseCase
extension PlaceInformationDetailViewModel {
    @MainActor
    func send(_ communityRecruitingContentId: Int64,
              from userId: Int64,
              to opponentUserId: Int64,
              communityRecruitingContentName: String,
              type: PushNotification.ShowingType) {
        Task {
            do {
                try await notificationUseCase.send(communityRecruitingContentId, from: userId, to: opponentUserId, subtitle: communityRecruitingContentName, type: type)
            } catch {
                print(error)
            }
        }
    }
}
