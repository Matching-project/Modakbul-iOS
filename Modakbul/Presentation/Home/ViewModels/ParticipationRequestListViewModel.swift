//
//  ParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import Foundation

final class ParticipationRequestListViewModel: ObservableObject {
    @Published var participationRequests: [ParticipationRequest] = []
}
