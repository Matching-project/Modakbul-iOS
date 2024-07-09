//
//  HomeView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI
import MapKit

struct HomeView<Router: AppRouter>: View where Router.Destination == Route {
    @EnvironmentObject private var router: Router
    @ObservedObject private var homeViewModel: HomeViewModel
    
    @State private var region: MKCoordinateRegion
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                         span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
    var body: some View {
        ZStack {
            localMapArea
            
            controllableArea
        }
    }
    
    private var controllableArea: some View {
        VStack {
            SearchBar("카페 이름으로 검색", text: $homeViewModel.searchingText)
                .frame(alignment: .top)
            
            Spacer()
            
            HStack {
                Spacer()
                
                currentPositionButtonArea
            }
        }
        .padding()
    }
    
    private var localMapArea: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: homeViewModel.places) { place in
            MapMarker(coordinate: place.coordinate.toCLCoordinate(), tint: .primary)
        }
        .onAppear {
            homeViewModel.updateLocationOnce()
        }
        .onReceive(homeViewModel.$currentCoordinate) { coordinate in
            self.region = coordinate.toRegion(span: region.span)
        }
    }
    
    private var currentPositionButtonArea: some View {
        CurrentPositionButton {
            homeViewModel.moveCameraOnLocation(to: nil)
        }
    }
}
