//
//  PlaceInformationDetailMakingViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import Foundation

final class PlaceInformationDetailMakingViewModel: ObservableObject {
    private var id: Int64
    @Published var location: Location
    @Published var category: Category
    @Published var peopleCount: Int
    @Published var date: Date
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var title: String
    @Published var content: String
    
    // TODO: - communityUseCase: CommunityUseCase로 변경해야함
    private let communityUseCase: DefaultCommunityUseCase // : CommunityUseCase
    
    init(id: Int64 = 1,
         location: Location = Location(),
         category: Category = .interview,
         peopleCount: Int = 1,
         date: Date = .now,
         startTime: Date = .now.unitizeToTenMinutes(),
         endTime: Date = .now.unitizeToTenMinutes(),
         title: String = "",
         content: String = "",
         communityUseCase: DefaultCommunityUseCase = DefaultCommunityUseCase()
    ) {
        self.id = id
        self.location = location
        self.category = category
        self.peopleCount = peopleCount
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.content = content
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
        id = -1
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
