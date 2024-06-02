//
//  HomeView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI
import MapKit

final class ViewModel: NSObject, ObservableObject,  LocationServiceDelegate {
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

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var textFieldText: String = ""
    @StateObject private var viewModel = ViewModel()
    @State private var isMapAppeared: Bool = true
    
    var body: some View {
        VStack {
            SearchBar(textFieldText: $textFieldText)
                .padding()
            
            // TODO: Filter Options
            Toggle("item", isOn: $isMapAppeared)
                .padding()
            
            // TODO: Map Layer
            if isMapAppeared {
                Map {
                    Marker(coordinate: viewModel.region.center) {
                        Text("Here")
                    }
                }
                .onAppear {
                    viewModel.connect()
                }
            } else {
                List {
                    ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9], id: \.self) { num in
                        Text("\(num)")
                    }
                }
                .listStyle(.plain)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview {
    HomeView()
}
