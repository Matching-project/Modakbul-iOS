//
//  MapArea.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI
import MapKit

struct MapArea<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: HomeViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            localMapArea
            
            hoveringButtonsArea
        }
        .task {
            viewModel.updateLocationOnceIfNeeded()
            await viewModel.fetchUnreadNotificationCount(userId: userId)
        }
    }
    
    private var localMapArea: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
            
            ForEach(viewModel.places, id: \.id) { place in
                let name = place.location.name
                let coordinate = place.location.coordinate
                let count = place.communityRecruitingContents.count
                
                Annotation(coordinate: coordinate) {
                    mapAnnotation(count)
                        .onTapGesture {
                            router.route(to: .placeInformationView(place: place, displayMode: .full))
                        }
                } label: {
                    //
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder private func mapAnnotation(_ count: Int) -> some View {
        switch count {
        case 0:
            Image(systemName: "circle.fill")
                .tint(.accentColor)
                .frame(width: 20, height: 20)
        case 1:
            Image(.marker)
                .frame(width: 30, height: 30)
        case 2:
            Image(.marker)
                .frame(width: 60, height: 60)
        default:
            Image(.marker)
                .frame(width: 80, height: 80)
        }
    }
    
    private var hoveringButtonsArea: some View {
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
            
            Spacer()
            
            HStack(alignment: .bottom) {
                StrokedButton(.circle) {
                    Image(systemName: "list.bullet")
                        .padding(.horizontal, 4)
                } action: {
                    viewModel.isMapShowing.toggle()
                }
                
                Spacer()
                
                VStack {
                    StrokedButton(.circle) {
                        Image(systemName: "arrow.clockwise")
                    } action: {
                        viewModel.findPlaces()
                    }
                    
                    StrokedButton(.circle) {
                        Image(systemName: "location.fill")
                    } action: {
                        withAnimation(.easeInOut) {
                            viewModel.cameraPosition = .userLocation(fallback: .automatic)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct HomeView_Preview2: PreviewProvider {
    static var previews: some View {
        router.view(to: .contentView)
    }
}
