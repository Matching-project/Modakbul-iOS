//
//  PlaceInformationDetailMakingViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import Foundation

final class PlaceInformationDetailMakingViewModel: ObservableObject {
    @Published var location: Location = Location()
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
    
    func submit() {
        // TODO: - id, writer, participants 이전 뷰에서 받도록 처리 필요
        let community = Community(routine: .daily,
                                  category: category,
                                  participants: PreviewHelper.shared.users,
                                  participantsLimit: peopleCount,
                                  meetingDate: date.toString(by: .yyyyMMdd),
                                  startTime: startTime.toString(by: .HHmm),
                                  endTime: endTime.toString(by: .HHmm))
        
        // TODO: - writtenDate가 최초글작성날짜를 의미하는지, 아니면 수정된 날짜를 포함하여 작성된 날짜를 의미하는지?
        let communityRecruitingContent = CommunityRecruitingContent(id: Int64(UUID().hashValue),
                                                                    title: title,
                                                                    content: content,
                                                                    writtenDate: Date().toString(by: .yyyyMMdd),
                                                                    writtenTime: Date().toString(by: .HHmm),
                                                                    writer: PreviewHelper.shared.users.first!,
                                                                    community: community)
        
        // TODO: - 구현 필요
        Task {
//            try? await communityUseCase.write(on: <#T##Location#>, content: communityRecruitingContent)
        }
    }
    
    func initialize() {
        id = Int64(Constants.loggedOutUserId)
        location = Location()
        category = .interview
        peopleCount = 1
        date = .now
        startTime = .now
        endTime = .now
        title = ""
        content = ""
    }
}
