//
//  ReportListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation

final class ReportListViewModel: ObservableObject {
    @Published var reportedUsers: [User] = PreviewHelper.shared.users
}
