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
        Map(initialPosition: .region(homeViewModel.region)) {
            ForEach(homeViewModel.places, id: \.self) { place in
                MapCircle(center: place.placemark.coordinate, radius: 500)
            }
        }
        .onAppear {
            homeViewModel.updateLocationOnce()
        }
        .onDisappear {
            homeViewModel.stopUpdatingLocation()
        }
    }
    
    private var mapControlButton: some View {
        Button {
            homeViewModel.updateLocationOnce()
        } label: {
            Text("정위치")
        }
    }
}
