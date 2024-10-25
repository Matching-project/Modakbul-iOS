//
//  ReportViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation

final class ReportViewModel: ObservableObject {
    @Published var reportType: ReportType? = nil
    @Published var description: String = ""

    private let chatUseCase: ChatUseCase
    private let userBusinessUseCase: UserBusinessUseCase
    
    init(
        userBusinessUseCase: UserBusinessUseCase,
        chatUseCase: ChatUseCase
    ) {
        self.userBusinessUseCase = userBusinessUseCase
        self.chatUseCase = chatUseCase
    }
    
    func initialize() {
        reportType = nil
        description = ""
    }
    
    @MainActor
    func report(userId: Int64, opponentUserId: Int64, chatRoomId: Int64?) {
        guard let reportType = reportType else { return }
        
        Task {
            let report = Report(content: reportType.description + " " + description)
            
            do {
                if let chatRoomId = chatRoomId {
                    try await chatUseCase.reportAndExitChatRoom(userId: userId,
                                                                opponentUserId: opponentUserId,
                                                                chatRoomId: chatRoomId,
                                                                report: report)
                } else {
                    try await userBusinessUseCase.report(userId: userId,
                                                         opponentUserId: opponentUserId,
                                                         report: report)
                }
                
                initialize()
            } catch {
                print(error)
            }
        }
    }
}
