//
//  HomeView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI
import MapKit

final class HomeViewModel: NSObject, ObservableObject, LocationServiceDelegate {
    private lazy var locationService: LocationService = DefaultLocationService(delegate: self)
    
    @Published var locations: [CLLocation] = []
    @Published var region = MKCoordinateRegion()
    
    func didUpdateLocations(locations: [CLLocation]) {
        
    }
    
    func didFailWithError(error: LocationServiceError) {
        
    }
    
    func connect() {
        locationService.start()
    }
}

struct HomeView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var homeViewModel: HomeViewModel
    @State private var textFieldText: String = ""
    @State private var isMapAppeared: Bool = true
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        VStack {
            SearchBar(textFieldText: $textFieldText)
                .padding()
            
            Map {
                Marker(coordinate: homeViewModel.region.center) {
                    Text("Here")
                }
            }
            .onAppear {
                homeViewModel.connect()
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
