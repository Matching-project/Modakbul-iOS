//
//  PlaceReviewView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

final class PlaceReviewViewModel: ObservableObject {
    @Published var powerSocketState: PowerSocketState = .moderate
    @Published var groupSeatingState: GroupSeatingState = .yes
    @Published var place: Place? = nil
    @Published var searchingText: String = String() {
        willSet {
            if newValue.isEmpty {
                searchedLocations = []
                suggestedResults = []
            } else {
                provideSuggestions(newValue)
            }
        }
    }
    @Published var selectedLocation: Location?
    @Published var searchedLocations: [Location] = []
    @Published var suggestedResults: [SuggestedResult] = []
    
    let groupSeatingStateSelection: [GroupSeatingState] = [.yes, .no]
    let powerSocketStateSelection: [PowerSocketState] = PowerSocketState.allCases

    private var updateSuggestedResultsTask: Task<Void, Never>?

//    private let placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase

//    init(placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase) {
//        self.placeShowcaseAndReviewUseCase = placeShowcaseAndReviewUseCase
//    }

    private func provideSuggestions(_ keyword: String) {
//        placeShowcaseAndReviewUseCase.provideSuggestions(by: keyword)
    }
}

// MARK: Interfaces
extension PlaceReviewViewModel {
    @MainActor func searchLocation() {
        guard searchingText.isEmpty == false else { return }
        suggestedResults = []

        Task {
//            do {
//                searchedLocations = try await placeShowcaseAndReviewUseCase.fetchLocations(with: searchingText)
//            } catch {
//                searchedLocations = []
//            }
        }
    }

    func startSuggestion() {
//        let suggestedResultsStream = AsyncStream<[SuggestedResult]>.makeStream()
//        placeShowcaseAndReviewUseCase.startSuggestion(with: suggestedResultsStream.continuation)
//        updateSuggestedResultsTask = updateSuggestedResultsTask ?? Task { @MainActor in
//            for await suggestedResults in suggestedResultsStream.stream {
//                self.suggestedResults = suggestedResults
//            }
//        }
    }

    func stopSuggestion() {
//        placeShowcaseAndReviewUseCase.stopSuggestion()
//        searchingText.removeAll()
//        searchedLocations = []
//        suggestedResults = []
//        updateSuggestedResultsTask?.cancel()
//        updateSuggestedResultsTask = nil
        powerSocketState = .moderate
        groupSeatingState = .yes
        place = nil
    }
}

struct PlaceReviewView: View {
    @ObservedObject private var viewModel: PlaceReviewViewModel
    
    private let place: Place?
    
    init(
        _ viewModel: PlaceReviewViewModel,
        place: Place?
    ) {
        self.viewModel = viewModel
        self.place = place
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            header(viewModel.place)
                .padding()
            
            statesArea
            
            Spacer()
            
            FlatButton("등록하기") {
                // TODO: 카페제보/리뷰 등록하기
            }
        }
        .padding()
        .navigationTitle(viewModel.place == nil ? "카페 제보" : "카페 리뷰")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.place = place
            viewModel.startSuggestion()
        }
        .onDisappear {
            viewModel.stopSuggestion()
        }
    }
    
    @ViewBuilder private func header(_ place: Place?) -> some View {
        if let place = place {
            placeInfo(place)
        } else {
            searchBarSection
        }
    }
    
    private var searchBarSection: some View {
        VStack(alignment: .leading) {
            Text("카페명")
                .font(.title.bold())
            
            HStack {
                RoundedTextField("카페를 검색하세요.", text: $viewModel.searchingText)
                
                RoundedButton {
                    //
                } label: {
                    Text("검색")
                }
            }
            
            if viewModel.suggestedResults.isEmpty == false {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.suggestedResults, id: \.id) { result in
                            VStack {
                                Text(result.title)
                                    .font(.headline)
                                
                                Text(result.subtitle)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func placeInfo(_ place: Place) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(place.location.name)
                .font(.title.bold())
            
            Text(place.location.address)
                .font(.caption)
        }
    }
    
    private var statesArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("콘센트")
                    .font(.title2.bold())
                
                HStack {
                    ForEach(viewModel.powerSocketStateSelection) { state in
                        StrokedButton(.capsule, .all, 14) {
                            Text(state.shortDescription)
                        } action: {
                            viewModel.powerSocketState = state
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("단체석 여부 (6인 이상)")
                    .font(.title2.bold())
                
                HStack {
                    ForEach(viewModel.groupSeatingStateSelection) { state in
                        StrokedButton(.capsule, .all, 14) {
                            Text(state.shortDescription)
                        } action: {
                            viewModel.groupSeatingState = state
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding(.vertical)
        }
        .padding()
    }
}

struct PlaceReviewView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                PlaceReviewView(PlaceReviewViewModel(), place: nil)
            }
            
            NavigationStack {
                PlaceReviewView(PlaceReviewViewModel(), place: previewHelper.places.first!)
            }
        }
    }
}
