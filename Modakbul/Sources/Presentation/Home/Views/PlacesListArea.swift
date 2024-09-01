//
//  PlacesListArea.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlacesListArea<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: HomeViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        listArea
    }
    
    private var listArea: some View {
        VStack {
            HStack {
                SearchBar("카페 이름으로 검색", text: $viewModel.searchingText)
                    .frame(alignment: .top)
                
                // TODO: PushNotification Button (WIP)
                Button {
                    isLoggedIn ? router.route(to: .notificationView) : router.loginAlert()
                } label: {
                    Image(systemName: "bell")
                        .font(.headline)
                        .padding(10)
                }
                
                Button {
                    viewModel.isMapShowing.toggle()
                } label: {
                    Image(systemName: "map")
                }
            }
            .padding()
            
            List(viewModel.places, id: \.id) { place in
                router.view(to: .placeInformationView(place: place))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

struct PlacesListArea_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .placesListArea)
    }
}
