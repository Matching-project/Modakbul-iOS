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
