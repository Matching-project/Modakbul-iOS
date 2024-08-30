//
//  PlaceInformationDetailViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

final class PlaceInformationDetailViewModel: ObservableObject {
    @Published var communityRecruitingContent: CommunityRecruitingContent?
    
    private let chatUseCase: ChatUseCase
    private let communityUseCase: CommunityUseCase
    
    init(
        chatUseCase: ChatUseCase,
        communityUseCase: CommunityUseCase
    ) {
        self.chatUseCase = chatUseCase
        self.communityUseCase = communityUseCase
    }
}

// MARK: Interfaces
extension PlaceInformationDetailViewModel {
    func configureView(_ communityRecruitingContentId: Int64) async {
        
    }
}
