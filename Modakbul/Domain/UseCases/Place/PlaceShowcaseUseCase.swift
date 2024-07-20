//
//  PlaceShowcaseUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol PlaceShowcaseUseCase {
    func fetchLocations(with keyword: String) async throws -> [Location]
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String)
    
    // TODO: 제보하기, 이거 구체화 필요
    func showcase()
}
