//
//  PlaceShowcaseView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/8/24.
//

import SwiftUI

struct PlaceShowcaseView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var placeShowcaseViewModel: PlaceShowcaseViewModel
    
    init(placeShowcaseViewModel: PlaceShowcaseViewModel) {
        self.placeShowcaseViewModel = placeShowcaseViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("카페명")
                .font(.title)
            
            HStack(spacing: 10) {
                SearchBar("카페를 검색해주세요.", text: $placeShowcaseViewModel.searchingText)
                
                Button {
                    placeShowcaseViewModel.searchLocation()
                } label: {
                    Text("검색")
                }
                .buttonStyle(BorderedButtonStyle())
            }
            
            List(placeShowcaseViewModel.suggestedResults, id: \.id) { result in
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.title)
                        .font(.headline)
                    
                    Text(result.subtitle)
                        .font(.caption)
                }
                .onTapGesture {
                    placeShowcaseViewModel.searchingText = result.title
                    placeShowcaseViewModel.searchLocation()
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: placeShowcaseViewModel.suggestedResults.isEmpty ? 0 : 300)
            
            List(placeShowcaseViewModel.searchedLocations, id: \.id) { location in
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                    
                    Text(location.address)
                        .font(.caption)
                }
                .onTapGesture {
                    placeShowcaseViewModel.selectedLocation = location
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: placeShowcaseViewModel.searchedLocations.isEmpty ? 0 : 300)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("선택한 장소")
                Text(placeShowcaseViewModel.selectedLocation?.name ?? String())
                    .font(.headline)
                
                Text(placeShowcaseViewModel.selectedLocation?.address ?? String())
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            placeShowcaseViewModel.startSuggestion()
        }
        .onDisappear {
            placeShowcaseViewModel.stopSuggestion()
        }
    }
}
