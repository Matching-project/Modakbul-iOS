//
//  ChatRoomListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 10/8/24.
//

import Foundation
import Combine
import SwiftData

final class ChatRoomListViewModel: ObservableObject {
    @Published var configurations: [ChatRoomConfiguration] = []
    
    private let chatRoomsSubject = PassthroughSubject<[ChatRoomConfiguration], Never>()
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
    
    func deleteChatRoom(_ chatRoomId: Int64, on userId: Int64) {
        Task {
            do {
                try await chatUseCase.deleteChat(userId: userId, on: chatRoomId)
                deletionSubject.send(chatRoomId)
            } catch {
                print(error)
            }
        }
    }
}
