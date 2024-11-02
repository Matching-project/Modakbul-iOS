//
//  ChatRoomListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 10/8/24.
//

import Foundation
import Combine
import SwiftData

protocol ChatRoomListPerformable: AnyObject {
    /// 채팅방 나가기 또는 신고 후 나가기 후 처리결과를 전달합니다.
    func performDeletion(model: ChatViewModel, result: Bool, chatRoomId: Int64)
}

final class ChatRoomListViewModel: ObservableObject {
    @Published var configurations: [ChatRoomConfiguration] = []
    @Published var presentedAlert: AlertType?
    
    private let chatRoomsSubject = PassthroughSubject<[ChatRoomConfiguration], Never>()
    private let alertSubject = PassthroughSubject<AlertType, Never>()
    let deletionSubject = PassthroughSubject<Int64, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let chatUseCase: ChatUseCase
    
    init(chatUseCase: ChatUseCase) {
        self.chatUseCase = chatUseCase
        subscribe()
    }
    
    private func subscribe() {
        chatRoomsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] configurations in
                self?.configurations = configurations
            }
            .store(in: &cancellables)
        
        deletionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chatRoomId in
                guard let index = self?.configurations.firstIndex(where: { $0.id == chatRoomId }) else { return }
                self?.configurations.remove(at: index)
            }
            .store(in: &cancellables)
        
        alertSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.presentedAlert = alert
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension ChatRoomListViewModel {
    func readChatRooms(userId: Int64) {
        Task {
            do {
                let configurations = try await chatUseCase.readChatRooms(userId: userId)
                chatRoomsSubject.send(configurations)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func deleteChatRoom(_ chatRoomId: Int64, on userId: Int64) {
        Task {
            do {
                try await chatUseCase.exitChatRoom(userId: userId, on: chatRoomId)
                deletionSubject.send(chatRoomId)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func routeToChatRoom(userId: Int64, on chatRoomId: Int64, completion: @escaping () -> Void) {
        Task {
            do {
                guard try await chatUseCase.isConnectionAvailable(userId: userId, on: chatRoomId) else {
                    alertSubject.send(.alreadyExistingChatRoom)
                    return
                }
                completion()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: ChatRoomListPerformable Conformation
extension ChatRoomListViewModel: ChatRoomListPerformable {
    func performDeletion(model: ChatViewModel, result: Bool, chatRoomId: Int64) {
        guard result else { return }
        deletionSubject.send(chatRoomId)
    }
}
