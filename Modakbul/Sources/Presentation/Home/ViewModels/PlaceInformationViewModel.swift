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
