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
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            listArea
            
            hoveringButtonsArea
        }
        .task {
            await viewModel.fetchUnreadNotificationCount(userId: userId)
        }
    }
    
    private var listArea: some View {
        VStack {
            HStack {
                SearchBar("카페 이름으로 검색", text: $viewModel.searchingText)
                    .frame(alignment: .top)
                
                Button {
                    if userId == Constants.loggedOutUserId {
                        router.route(to: .loginView)
                    } else {
                        router.route(to: .notificationView(userId: Int64(userId)))
                    }
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
