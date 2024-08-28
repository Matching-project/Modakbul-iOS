//
//  BlockedListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation

final class BlockedListViewModel: ObservableObject {
    @Published var blockedUser: [User] = PreviewHelper.shared.users
}

// MARK: Interfaces
extension BlockedListViewModel {
    func cancelBlock() {
        
    }
}
