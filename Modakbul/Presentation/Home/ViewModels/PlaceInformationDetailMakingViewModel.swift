//
//  PlaceInformationDetailMakingViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import Foundation

final class PlaceInformationDetailMakingViewModel: ObservableObject {
    @Published var location: String
    @Published var category: Category
    @Published var peopleCount: String
    @Published var date: Date
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var title: String
    @Published var content: String
    
    // TODO: - communityUseCase: CommunityUseCase로 변경해야함
    private let communityUseCase: DefaultCommunityUseCase // : CommunityUseCase
    
    init(location: String = "스타벅스 성수역점",
         category: Category = .interview,
         peopleCount: String = "",
         date: Date = .now,
         startTime: Date = .now,
         endTime: Date = .now,
         title: String = "",
         content: String = "",
         communityUseCase: DefaultCommunityUseCase = DefaultCommunityUseCase()
    ) {
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
    
    func afterNow(_ date: Date) -> PartialRangeFrom<Date> {
        Calendar.current.isDate(date, inSameDayAs: Date.now) ? Date.now... : Date.distantPast...
    }
    
    func afterStartTime(_ startTime: Date) -> PartialRangeFrom<Date> {
        Calendar.current.isDate(startTime, inSameDayAs: Date.now) ? startTime... : Date.distantPast...
    }
    
    func submit() {
        // TODO: - id, writer, participants 이전 뷰에서 받도록 처리 필요
        let community = Community(routine: .daily,
                                  category: category,
                                  participants: PreviewHelper.shared.users,
                                  participantsLimit: Int(peopleCount)!,
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
        location = ""
        category = .interview
        peopleCount = ""
        date = .now
        startTime = .now
        endTime = .now
        title = ""
        content = ""
    }
}
