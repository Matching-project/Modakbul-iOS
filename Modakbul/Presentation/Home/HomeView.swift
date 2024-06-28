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
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        ZStack {
            localMapArea
            
            controllableArea
        }
    }
    
    private var controllableArea: some View {
        VStack {
            SearchBar(searchingText: $homeViewModel.searchingText)
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
        Map(coordinateRegion: $homeViewModel.region, showsUserLocation: true, annotationItems: homeViewModel.places) { place in
            MapMarker(coordinate: place.coordinate.toCLCoordinate(), tint: .primary)
        }
        .onAppear {
            homeViewModel.updateLocationOnce()
        }
    }
    
    private var currentPositionButtonArea: some View {
        CurrentPositionButton {
            homeViewModel.moveCameraOnLocation(to: nil)
        }
    }
}
