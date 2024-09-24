//
//  PlaceInformationViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/26/24.
//

import Foundation
import Combine

final class PlaceInformationViewModel: ObservableObject {
    @Published var selectedOpeningHourByDay: OpeningHour? {
        didSet { displaySelectedOpeningHourText() }
    }
    @Published var openingHourText: String = String()
    @Published var communityRecruitingContents: [CommunityRecruitingContent] = [] // 로그인 상태에서만 Fetch
    
    private let communityRecruitingContentSubject = PassthroughSubject<[CommunityRecruitingContent], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let communityUseCase: CommunityUseCase
    
    init(communityUseCase: CommunityUseCase) {
        self.communityUseCase = communityUseCase
        subscribe()
    }
    
    private func subscribe() {
        communityRecruitingContentSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contents in
                self?.communityRecruitingContents = contents
            }
            .store(in: &cancellables)
    }
    
    private func displaySelectedOpeningHourText() {
        if let openingHour = selectedOpeningHourByDay {
            openingHourText = displayOpeningHours(openingHour)
        }
    }
}

// MARK: Interfaces
extension PlaceInformationViewModel {
    func configureView(by place: Place) {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: .now)
        let dayOfWeek = DayOfWeek(weekDay)
        self.selectedOpeningHourByDay = place.openingHours.first(where: {$0.dayOfWeek == dayOfWeek})
    }
    
    func displayOpeningHours(_ openingHour: OpeningHour) -> String {
        let dayOfWeek = openingHour.dayOfWeek.description
        let open = openingHour.open
        let close = openingHour.close
        return "\(dayOfWeek) \(open) - \(close)"
    }
    
    func fetchCommunityRecruitingContents(userId: Int64, with placeId: Int64) async {
        do {
            let contents = try await communityUseCase.readCommunityRecruitingContents(userId: userId, placeId: placeId)
            communityRecruitingContentSubject.send(contents)
        } catch {
            print(error)
        }
    }
}
