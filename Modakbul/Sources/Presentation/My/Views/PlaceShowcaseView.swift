//
//  PlaceShowcaseView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct PlaceShowcaseView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: PlaceShowcaseViewModel
    
    private let userId: Int64
    
    init(
        _ viewModel: PlaceShowcaseViewModel,
        userId: Int64
    ) {
        self.viewModel = viewModel
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            content(viewModel.places.isEmpty)
            
            Spacer()
            
            FlatButton("다른 카페 제보하기") {
                router.route(to: .placeReviewView(place: nil, userId: userId))
            }
        }
        .padding()
        .navigationModifier(title: "카페 제보/리뷰") {
            router.dismiss()
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchPlaces(userId: userId)
        }
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            Text("아직 방문한 카페가 없어요.")
                .font(.Modakbul.headline)
        } else {
            List {
                ForEach(viewModel.places, id: \.id) { place in
                    listCell(place)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ place: Place) -> some View {
        HStack {
            if let url = place.imageURLs.first {
                AsyncImageView(url: url, contentMode: .fill, clipShape: .rect(cornerRadius: 8))
            } else {
                Image(.modakbulMainReverse)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 64, maxHeight: 64)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(place.location.name)
                    .font(.Modakbul.headline)
                
                Text(place.location.address)
                    .font(.Modakbul.caption)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button {
                router.route(to: .placeReviewView(place: place, userId: userId))
            } label: {
                Text("리뷰")
                    .font(.Modakbul.footnote)
                    .bold()
            }
            .buttonStyle(.capsuledInset)
        }
    }
}
