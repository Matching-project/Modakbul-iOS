//
//  FcmManager.swift
//  Modakbul
//
//  Created by Swain Yun on 9/10/24.
//

import Foundation

final class FcmManager: ObservableObject {
    @Published var fcmToken: String?
    
    static let instance = FcmManager()
    
    private init() {}
}

// MARK: Interfaces
extension FcmManager {
    func updateToken(_ fcmToken: String) {
        self.fcmToken = fcmToken
    }
}
