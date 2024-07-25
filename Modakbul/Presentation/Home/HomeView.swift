//
//  HomeView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI
import MapKit

struct HomeView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var homeViewModel: HomeViewModel
    
    @State private var region: MKCoordinateRegion
    @State private var isMapShowing: Bool = true
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                         span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
    var body: some View {
        ZStack {
            if isMapShowing {
                localMapArea
            } else {
                placesListArea
            }
            
            controllableArea
        }
    }
    
    private var controllableArea: some View {
        VStack {
            HStack {
                SearchBar("카페 이름으로 검색", text: $homeViewModel.searchingText)
                    .frame(alignment: .top)
                
                // TODO: Notification Button (WIP)
                Image(systemName: "bell")
                    .font(.headline)
                    .padding(10)
            }
            .frame(alignment: .top)
            
            Spacer()
            
            HStack {
                StrokedButton(.capsule) {
                    Text("리스트")
                        .padding(.horizontal, 4)
                } action: {
                    isMapShowing.toggle()
                }
                
                Spacer()
                
                StrokedButton(.circle) {
                    Image(systemName: "location.fill")
                } action: {
                    homeViewModel.moveCameraOnLocation(to: nil)
                }
            }
            .frame(alignment: .bottom)
        }
        .padding()
    }
    
    private var localMapArea: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: homeViewModel.places) { place in
            MapMarker(coordinate: place.location.coordinate, tint: .primary)
        }
        .onAppear {
            homeViewModel.updateLocationOnce()
        }
        .onReceive(homeViewModel.$currentCoordinate) { coordinate in
            region.center = coordinate
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private var placesListArea: some View {
        List(homeViewModel.places) { place in
            Text(place.location.name)
        }
    }
}
