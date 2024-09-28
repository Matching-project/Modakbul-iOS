//
//  PlaceInformationDetailMakingViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import Foundation

final class PlaceInformationDetailMakingViewModel: ObservableObject {
    @Published var placeId: Int64?
    @Published var locationName: String?
    @Published var category: Category = .interview
    @Published var peopleCount: Int = 1
    @Published var date: Date = .now
    @Published var startTime: Date = .now.unitizeToTenMinutes()
    @Published var endTime: Date = .now.unitizeToTenMinutes()
    @Published var title: String = ""
    @Published var content: String = ""
    
    private var id: Int64 = Int64(Constants.loggedOutUserId)
    private let communityUseCase: CommunityUseCase
    
    init(communityUseCase: CommunityUseCase) {
        self.communityUseCase = communityUseCase
    }
    
    func after(_ date: Date) -> PartialRangeFrom<Date> {
        Calendar.current.isDate(date, inSameDayAs: Date.now) ? date.unitizeToTenMinutes()... : Date.distantPast...
    }
    
    @MainActor
    func submit(
        _ communityRecruitingContentId: Int64? = nil,
        userId: Int64
    ) {
        guard let placeId = placeId else { return }
        
        let community = Community(routine: .daily,
                                  category: category,
                                  participantsLimit: peopleCount,
                                  meetingDate: date.toString(by: .yyyyMMddHyphen),
                                  startTime: startTime.toString(by: .HHmm),
                                  endTime: endTime.toString(by: .HHmm))
        
        let communityRecruitingContent = CommunityRecruitingContent(
            id: communityRecruitingContentId ?? Constants.temporalId,
            title: title,
            content: content,
            writtenDate: Date().toString(by: .yyyyMMdd),
            writtenTime: Date().toString(by: .HHmm),
            community: community
        )
        
        Task {
            do {
                try await communityUseCase.createCommunityRecruitingContent(userId: userId, placeId: placeId, communityRecruitingContent)
            } catch {
                print(error)
            }
        }
    }
    
    func configureView(_ communityRecruitingContent: CommunityRecruitingContent?) {
        self.category = communityRecruitingContent?.community.category ?? .interview
        self.peopleCount = communityRecruitingContent?.community.participantsCount ?? 1
        // TODO: 이거 모집글 수정일 경우 구현 필요
        self.date = .now
        self.startTime = .now.unitizeToTenMinutes()
        self.endTime = .now.unitizeToTenMinutes()
        self.title = communityRecruitingContent?.title ?? String()
        self.content = communityRecruitingContent?.content ?? String()
    }
    
    func initialize() {
        id = Int64(Constants.loggedOutUserId)
        placeId = nil
        category = .interview
        peopleCount = 1
        date = .now
        startTime = .now
        endTime = .now
        title = ""
        content = ""
    }
}
