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
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            localMapArea
            
            hoveringButtonsArea
        }
        .onAppear {
            viewModel.updateLocationOnceIfNeeded()
            viewModel.fetchUnreadNotificationCount()
        }
    }
    
    private var localMapArea: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.places) { place in
            MapAnnotation(coordinate: place.location.coordinate) {
                // TODO: 맵 마커 이미지 필요함
                Image(systemName: "heart.fill")
                    .foregroundStyle(.accent)
                    .onTapGesture {
                        router.route(to: .placeInformationView(place: place))
                    }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private var hoveringButtonsArea: some View {
        VStack {
            HStack {
                SearchBar("카페 이름으로 검색", text: $viewModel.searchingText)
                    .frame(alignment: .top)
                
                // TODO: PushNotification Button (WIP)
                Button {
                    router.route(to: .notificationView)
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
                        viewModel.findPlaces(on: viewModel.region.center)
                    }
                    
                    StrokedButton(.circle) {
                        Image(systemName: "location.fill")
                    } action: {
                        viewModel.updateLocationOnce()
                    }
                }
            }
        }
        .padding()
    }
}

struct MapArea_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .mapArea)
    }
}
