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
                
                // TODO: Notification Button (WIP)
                Image(systemName: "bell")
                    .font(.headline)
                    .padding(10)
            }
            
            List(homeViewModel.places, id: \.id) { place in
                Cell(place)
            }
            .listStyle(.plain)
        }
        .padding()
    }
}

struct PlacesListArea_Preview: PreviewProvider {
    static var previews: some View {
        PlacesListArea<DefaultAppRouter>(router.resolver.resolve(HomeViewModel.self))
    }
}

extension PlacesListArea {
    struct Cell: View {
        private let place: Place
        
        init(_ place: Place) {
            self.place = place
        }
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(place.location.name)
                        .font(.headline)
                    
                    Text(place.location.address)
                        .font(.caption)
                }
            }
        }
    }
}
