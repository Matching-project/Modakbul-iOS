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

    private let userBusinessUseCase: UserBusinessUseCase
    
    init(userBusinessUseCase: UserBusinessUseCase) {
        self.userBusinessUseCase = userBusinessUseCase
    }
    
    func initialize() {
        reportType = nil
        description = ""
    }
    
    @MainActor
    func report(userId: Int64, opponentUserId: Int64) {
        if reportType != .other { description = "" }
        
        Task {
            do {
                try await userBusinessUseCase.report(userId: userId,
                                                     opponentUserId: opponentUserId,
                                                     report: Report(content: description))
            } catch {
                print(error)
            }
        }
    }
}
