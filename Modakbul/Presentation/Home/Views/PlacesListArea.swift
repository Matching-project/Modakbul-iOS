//
//  PlacesListArea.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlacesListArea<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var homeViewModel: HomeViewModel
    
    init(_ homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                SearchBar("카페 이름으로 검색", text: $homeViewModel.searchingText)
                    .frame(alignment: .top)
                
                // TODO: PushNotification Button (WIP)
                Button {
                    router.route(to: .notificationView)
                } label: {
                    Image(systemName: "bell")
                        .font(.headline)
                        .padding(10)
                }
            }
            
            List(homeViewModel.places, id: \.id) { place in
                router.view(to: .placeInformationView(place: place))
            }
            .listStyle(.plain)
        }
        .padding()
    }
}
