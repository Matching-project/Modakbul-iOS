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
    @Published var isDeleted: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isFull: Bool = false
    @Published var chatRoomConfiguration: ChatRoomConfiguration?
    
    // MARK: Presenting Data
    @Published var imageURLs: [URL?] = []
    @Published var category: String = String()
    @Published var recruitingCount: String = String()
    @Published var meetingDate: String = String()
    @Published var meetingTime: String = String()
    @Published var title: String = String()
    @Published var content: String = String()
    @Published var creationDate: String = String()
    @Published var writer: User = User()
    
    private var matchingId: Int64 = Int64(Constants.loggedOutUserId)
    private var userId: Int64 = Int64(Constants.loggedOutUserId)
    
    private let isDeletedSubject = PassthroughSubject<Bool, Never>()
    private let isCompletedSubject = PassthroughSubject<Bool, Never>()
    private let communityRecruitingContentSubject = PassthroughSubject<CommunityRecruitingContent, Never>()
    private let userRoleSubject = PassthroughSubject<(role: UserRole, matchingId: Int64?, state: MatchState), Never>()
    private let chatRoomConfigurationSubject = PassthroughSubject<ChatRoomConfiguration, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let chatUseCase: ChatUseCase
    private let communityUseCase: CommunityUseCase
    private let matchingUseCase: MatchingUseCase
    private let notificationUseCase: NotificationUseCase
    
    init(
        chatUseCase: ChatUseCase,
        communityUseCase: CommunityUseCase,
        matchingUseCase: MatchingUseCase,
        notificationUseCase: NotificationUseCase
    ) {
        self.chatUseCase = chatUseCase
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
                self?.isDeleted = false
                self?.isCompleted = false
                self?.isFull = content.community.participants.count >= content.community.participantsLimit
            }
            .store(in: &cancellables)
        
        isDeletedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isDeleted = result
            }
            .store(in: &cancellables)
        
        isCompletedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isCompleted = result
            }
            .store(in: &cancellables)

        
        $communityRecruitingContent
            .sink { [weak self] content in
                guard let content = content else { return }
                self?.imageURLs = content.placeImageURLs
                let community = content.community
                self?.category = community.category.description
                self?.recruitingCount = "\(community.participantsCount)/\(community.participantsLimit)"
                let meetingDateComponents = community.meetingDate.split(separator: "-")
                self?.meetingDate = "\(meetingDateComponents[1])월 \(meetingDateComponents[2])일"
                self?.meetingTime = "\(community.startTime.prefix(5))~\n\(community.endTime.prefix(5))"
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
                self?.matchingId = matchingId ?? Int64(Constants.loggedOutUserId)
                self?.matchState = state
            }
            .store(in: &cancellables)
        
        chatRoomConfigurationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chatRoomConfiguration in
                self?.chatRoomConfiguration = chatRoomConfiguration
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces for CommunityUseCase
extension PlaceInformationDetailViewModel {
    func configureView(_ communityRecruitingContentId: Int64, _ userId: Int64) async {
        do {
            self.userId = userId
            
            let communityRecruitingContent = try await communityUseCase.readCommunityRecruitingContentDetail(with: communityRecruitingContentId)
            communityRecruitingContentSubject.send(communityRecruitingContent)
            
            // 모집글 작성자의 id와 사용자의 id가 같으면 role은 exponent, 다르면 사용자 역할 확인 작업 전개
            guard communityRecruitingContent.writer.id != userId else {
                return userRoleSubject.send((.exponent, nil, .cancel))
            }
            
            let (role, matchingId, state) = try await matchingUseCase.checkUserRole(userId: userId, with: communityRecruitingContentId)
            userRoleSubject.send((role, matchingId, state))
        } catch {
            userRoleSubject.send((UserRole.nonParticipant, nil, .cancel))
        }
    }
    
    func completeCommunityRecruiting() {
        guard let id = communityRecruitingContent?.id else { return }
        
        Task {
            do {
                try await communityUseCase.completeCommunityRecruiting(userId: userId, with: id)
                isCompletedSubject.send(true)
            } catch {
                isCompletedSubject.send(false)
                print(error)
            }
        }
    }
    
    func deleteCommunityRecruitingContent(userId: Int64) {
        guard let id = communityRecruitingContent?.id else { return }
        
        Task {
            do {
                try await communityUseCase.deleteCommunityRecruitingContent(userId: userId, id)
                isDeletedSubject.send(true)
            } catch {
                isDeletedSubject.send(false)
                print(error)
            }
        }
    }
    
    func exitCommunity(userNickname: String) {
        guard let content = communityRecruitingContent else { return }
        
        Task {
            do {
                try await matchingUseCase.exitMatch(userId: userId, with: matchingId)
                userRoleSubject.send((role: UserRole.nonParticipant, matchingId: nil, state: MatchState.exit))
                let pushNotification = PushNotificationBuilder
                    .create(type: .exitParticipation)
                    .setTitle(userNickname)
                    .setSubtitle(content.title)
                    .build()
                try await notificationUseCase.send(
                    content.id,
                    from: userId,
                    to: content.writer.id,
                    pushNotification: pushNotification
                )
            } catch {
                print(error)
            }
        }
    }
    
    func requestMatch(userNickname: String) {
        guard let content = communityRecruitingContent else { return }
        
        Task {
            do {
                try await matchingUseCase.requestMatch(userId: userId, with: content.id)
                userRoleSubject.send((role: UserRole.nonParticipant, matchingId: nil, state: MatchState.pending))
                let pushNotification = PushNotificationBuilder
                    .create(type: .requestParticipation(communityRecruitingContentId: content.id))
                    .setTitle(userNickname)
                    .setSubtitle(content.title)
                    .build()
                try await notificationUseCase.send(
                    content.id,
                    from: userId,
                    to: content.writer.id,
                    pushNotification: pushNotification
                )
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Interfaces for ChatUseCase
extension PlaceInformationDetailViewModel {
    /// 해당 게시물과 관련된 채팅방이 있는지 확인한 후 해당 채팅방으로 이동하기 위한 채팅방 ID를 응답으로 받습니다.
    /// - Warning: 게시물과 관련된 채팅방이 존재하지 않을 수 있습니다. 이 경우 새로운 채팅방이 생성되어 그 채팅방 ID를 응답으로 받습니다.
    /// - Parameters:
    ///   - userId: 내 유저 아이디
    ///   - opponentUserId: 상대방 유저 아이디
    func routeToChatRoom(userId: Int64, opponentUserId: Int64) {
        Task {
            guard let communityRecruitingContent = communityRecruitingContent else { return }
            
            do {
                let chatRoomId = try await chatUseCase.createChatRoom(userId: userId, opponentUserId: opponentUserId, with: communityRecruitingContent.id)
                let chatRoomConfigurations = try await chatUseCase.readChatRooms(userId: userId)
                guard let chatRoomConfiguration = chatRoomConfigurations.filter({ $0.id == chatRoomId }).first else { return }
                chatRoomConfigurationSubject.send(chatRoomConfiguration)
            } catch {
                print(error)
            }
        }
    }
}
