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
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    mapControlButton
                }
            }
            .padding()
        }
    }
    
    private var localMapArea: some View {
        Map(position: $homeViewModel.cameraPosition) {
            MapCircle(center: homeViewModel.region.center, radius: 50)
            
            ForEach(homeViewModel.places, id: \.id) { place in
                MapCircle(center: place.coordinate.toCLCoordinate(), radius: 50)
            }
        }
        .onAppear {
            homeViewModel.updateLocationOnce()
        }
    }
    
    private var mapControlButton: some View {
        CurrentPositionButton {
            homeViewModel.moveCameraOnLocation(to: nil)
        }
    }
}
