//
//  PlaceReviewView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct PlaceReviewView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: PlaceReviewViewModel
    
    private let place: Place?
    private let userId: Int64
    
    init(
        _ viewModel: PlaceReviewViewModel,
        place: Place?,
        userId: Int64
    ) {
        self.viewModel = viewModel
        self.place = place
        self.userId = userId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical) {
                header(place)
                    .padding()
                
                StatesArea(viewModel: viewModel)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            .scrollDismissesKeyboard(.immediately)
            .scrollIndicators(.hidden)
            
            FlatButton("등록하기") {
                viewModel.submit(userId: userId, on: place)
            }
            .disabled(viewModel.isSubmitButtonDisabled)
            .padding()
            .safeAreaPadding(.bottom, 10)
        }
        .navigationModifier(title: viewModel.place == nil ? "카페 제보" : "카페 리뷰") {
            router.dismiss()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.place = place
            viewModel.startSuggestion()
        }
        .onDisappear {
            viewModel.stopSuggestion()
        }
        .onReceive(viewModel.$submitCompletion) { result in
            if result {
                router.alert(for: .showcaseAndReviewSuccess, actions: [ConfirmationAction.defaultAction("확인", action: {router.dismiss()})])
            }
        }
    }
    
    @ViewBuilder private func header(_ place: Place?) -> some View {
        if let place = place {
            PlaceInfo(place)
        } else {
            SearchBarArea(viewModel: viewModel)
        }
    }
}

extension PlaceReviewView {
    private struct PlaceInfo: View {
        private let place: Place
        
        init(_ place: Place) {
            self.place = place
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(place.location.name)
                    .font(.Modakbul.title.bold())
                
                Text(place.location.address)
                    .font(.Modakbul.caption)
            }
        }
    }
    
    private struct SearchBarArea: View {
        @ObservedObject var viewModel: PlaceReviewViewModel
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("카페명")
                    .font(.Modakbul.title.bold())
                
                RoundedTextField("카페를 검색하세요.", text: $viewModel.searchingText)
                
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
                                .padding()
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        viewModel.selectSuggestion(result)
                                    }
                                }
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                    )
                }
            }
        }
    }
    
    private struct StatesArea: View {
        @ObservedObject var viewModel: PlaceReviewViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("콘센트")
                        .font(.Modakbul.title2.bold())
                    
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
        }
    }
}
