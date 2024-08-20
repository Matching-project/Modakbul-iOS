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
    @ObservedObject private var homeViewModel: HomeViewModel
    
    @State private var region: MKCoordinateRegion
    
    init(_ homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                         span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
    var body: some View {
        ZStack {
            localMapArea
            
            hoveringButtonsArea
        }
    }
    
    private var localMapArea: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: homeViewModel.places) { place in
            MapAnnotation(coordinate: place.location.coordinate) {
                // TODO: 맵 마커 이미지 필요함
                Image(systemName: "heart.fill")
                    .foregroundStyle(.accent)
                    .onTapGesture {
                        router.route(to: .placeInformationView(place: place))
                    }
            }
        }
        .onAppear {
            homeViewModel.updateLocationOnceIfNeeded()
        }
        .onReceive(homeViewModel.$currentCoordinate) { coordinate in
            region.center = coordinate
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private var hoveringButtonsArea: some View {
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
                        .foregroundStyle(.accent)
                }
            }
            
            Spacer()
            
            HStack(alignment: .bottom) {
                StrokedButton(.circle) {
                    Image(systemName: "list.bullet")
                        .padding(.horizontal, 4)
                } action: {
                    homeViewModel.isMapShowing.toggle()
                }
                
                Spacer()
                
                VStack {
                    StrokedButton(.circle) {
                        Image(systemName: "arrow.clockwise")
                    } action: {
                        homeViewModel.findPlaces(on: region.center)
                    }
                    
                    StrokedButton(.circle) {
                        Image(systemName: "location.fill")
                    } action: {
                        homeViewModel.updateLocationOnce()
                    }
                }
            }
        }
        .padding()
    }
}
