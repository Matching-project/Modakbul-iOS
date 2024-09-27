//
//  PlaceReviewView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

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
                viewModel.submit(on: place)
            }
            .disabled(viewModel.selectedLocation == nil)
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
                .font(.Modakbul.title)
                .bold()
            
            HStack {
                RoundedTextField("카페를 검색하세요.", text: $viewModel.searchingText)
                
                RoundedButton {
                    viewModel.searchLocation()
                } label: {
                    Text("검색")
                }
            }
            
            if viewModel.suggestedResults.isEmpty == false {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.suggestedResults, id: \.id) { result in
                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .font(.Modakbul.headline)
                                
                                Text(result.subtitle)
                                    .font(.Modakbul.caption)
                            }
                            .contentShape(.rect)
                            .onTapGesture {
                                viewModel.selectSuggestion(result)
                            }
                        }
                    }
                }
            } else {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.searchedLocations, id: \.id) { location in
                            VStack(alignment: .leading) {
                                Text(location.name)
                                    .font(.Modakbul.headline)
                                
                                Text(location.address)
                                    .font(.Modakbul.caption)
                            }
                            .contentShape(.rect)
                            .onTapGesture {
                                viewModel.selectedLocation = location
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
                .font(.Modakbul.title)
                .bold()
            
            Text(place.location.address)
                .font(.Modakbul.caption)
        }
    }
    
    private var statesArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("콘센트")
                    .font(.Modakbul.title2)
                    .bold()
                
                HStack {
                    ForEach(viewModel.powerSocketStateSelection) { state in
                        if state == viewModel.powerSocketState {
                            StrokedFilledButton(.capsule, .all, 14) {
                                Text(state.shortDescription)
                            } action: {
                                //
                            }
                            .padding(.horizontal, 4)
                        } else {
                            StrokedButton(.capsule, .all, 14) {
                                Text(state.shortDescription)
                            } action: {
                                withAnimation(.easeInOut) {
                                    viewModel.powerSocketState = state
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("단체석 여부 (6인 이상)")
                    .font(.Modakbul.title2)
                    .bold()
                
                HStack {
                    ForEach(viewModel.groupSeatingStateSelection) { state in
                        if state == viewModel.groupSeatingState {
                            StrokedFilledButton(.capsule, .all, 14) {
                                Text(state.shortDescription)
                            } action: {
                                //
                            }
                            .padding(.horizontal, 4)
                        } else {
                            StrokedButton(.capsule, .all, 14) {
                                Text(state.shortDescription)
                            } action: {
                                withAnimation(.easeInOut) {
                                    viewModel.groupSeatingState = state
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .padding()
    }
}
