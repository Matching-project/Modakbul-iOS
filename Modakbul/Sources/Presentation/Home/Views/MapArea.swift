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
    @FocusState private var isFocused: Bool
    
    @State private var region: MKCoordinateRegion = .init()
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        viewModel.findPlaces()
    }
    
    var body: some View {
        ZStack {
            localMapArea
            
            hoveringButtonsArea
        }
        .navigationBarHidden(true)
        .task {
            viewModel.updateLocationOnceIfNeeded()
            
            if userId != Constants.loggedOutUserId {
                await viewModel.fetchUnreadNotificationCount(userId: userId)
            }
        }
    }
    
    private var localMapArea: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
            
            ForEach(viewModel.places, id: \.id) { place in
                let name = place.location.name
                let coordinate = place.location.coordinate
                let count = place.meetingCount
                
                Annotation(coordinate: coordinate) {
                    mapAnnotation(count)
                        .onTapGesture {
                            router.route(to: .placeInformationView(place: place))
                        }
                } label: {
                    Text(name)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onMapCameraChange { context in
            viewModel.cameraCenterCoordinate = context.camera.centerCoordinate
            region = context.region
            isFocused = false
        }
    }
    
    private func calculateMarkerSize(_ count: Int, region: MKCoordinateRegion) -> CGFloat {
        let baseSize: CGFloat = 4.0
        
        let longitudeSpan = region.span.longitudeDelta
        let latitudeSpan = region.span.latitudeDelta
        let averageSpan = (longitudeSpan + latitudeSpan) / 2.0
        let zoomLevel = 1 / averageSpan
        
        let size = baseSize + CGFloat(count) * 2.0
        let zoomAdjustedSize = size * CGFloat(zoomLevel * 5)
        
        return max(4, min(20, zoomAdjustedSize))
    }
    
    @ViewBuilder private func mapAnnotation(_ count: Int) -> some View {
        let size = calculateMarkerSize(count, region: region)
        
        if count == 0 {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: size, height: size)
        } else {
            Image(.marker)
                .resizable()
                .frame(width: size, height: size)
        }
    }
    
    private var hoveringButtonsArea: some View {
        VStack {
            HStack {
                SearchBar("카페 이름으로 검색", text: $viewModel.searchingText, $isFocused)
                
                Button {
                    if userId == Constants.loggedOutUserId {
                        router.alert(for: .login, actions: [
                            .cancelAction("취소") {
                                router.dismiss()
                            },
                            .defaultAction("로그인") {
                                router.route(to: .loginView)
                            }
                        ])
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
            
            if viewModel.searchedPlaces.isEmpty == false {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.searchedPlaces, id: \.id) { place in
                            VStack(alignment: .leading) {
                                Text(place.location.name)
                                Text(place.location.address)
                            }
                            .padding()
                            .contentShape(.rect)
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    isFocused = false
                                    viewModel.selectPlace(place)
                                }
                            }
                        }
                    }
                }
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 14))
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
                            viewModel.moveToUserLocation()
                        }
                    }
                }
            }
        }
        .padding()
    }
}
