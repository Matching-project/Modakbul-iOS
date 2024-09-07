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
    
    private let userId: Int64
    
    init(_ viewModel: HomeViewModel,
         userId: Int64
    ) {
        self.viewModel = viewModel
        self.userId = userId
    }
    
    var body: some View {
        ZStack {
            listArea
            
            hoveringButtonsArea
        }
        .onAppear {
            viewModel.fetchUnreadNotificationCount(userId: userId)
        }
    }
    
    private var listArea: some View {
        VStack {
            HStack {
                SearchBar("카페 이름으로 검색", text: $viewModel.searchingText)
                    .frame(alignment: .top)
                
                // TODO: PushNotification Button (WIP)
                Button {
                    router.route(to: .notificationView(userId: userId))
                } label: {
                    if viewModel.unreadCount > 0 {
                        NotificationIcon(badge: true)
                            .padding(5)
                    } else {
                        NotificationIcon(badge: false)
                            .padding(10)
                    }
                }
            }
            .padding()
            
            List(viewModel.places, id: \.id) { place in
                router.view(to: .placeInformationView(place: place, displayMode: .summary))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
    
    private var hoveringButtonsArea: some View {
        VStack {
            Spacer()
            
            HStack {
                StrokedButton(.circle) {
                    Image(systemName: "map")
                        .padding(.horizontal, 4)
                } action: {
                    viewModel.isMapShowing.toggle()
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

struct PlaceListArea_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .placesListArea(userId: 0))
    }
}
