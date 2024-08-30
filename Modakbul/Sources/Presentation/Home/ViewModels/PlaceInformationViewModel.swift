//
//  PlaceInformationViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/26/24.
//

import Foundation

final class PlaceInformationViewModel: ObservableObject {
    @Published var selectedOpeningHourByDay: OpeningHour? {
        didSet { displaySelectedOpeningHourText() }
    }
    @Published var openingHourText: String = String()
    @Published var communityRecruitingContents: [CommunityRecruitingContent] = []
    
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
}
