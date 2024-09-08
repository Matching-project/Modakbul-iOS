//
//  ReportListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

final class ReportListViewModel: ObservableObject {
    @Published var reportedUsers: [(user: User, status: InquiryStatusType)] = []
    
    private let reportedUsersSubject = PassthroughSubject<[(user: User, status: InquiryStatusType)], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userBusinessUseCase: UserBusinessUseCase
    
    init(userBusinessUseCase: UserBusinessUseCase) {
        self.userBusinessUseCase = userBusinessUseCase
        subscribe()
    }
    
    private func subscribe() {
        reportedUsersSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.reportedUsers = users
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension ReportListViewModel {
    func configureView(userId: Int64) async {
        do {
            let blockedUsers = try await userBusinessUseCase.readReports(userId: userId)
            reportedUsersSubject.send(blockedUsers)
        } catch {
            print(error)
        }
    }
}
