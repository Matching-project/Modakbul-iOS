//
//  HomeView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI

struct HomeView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        if homeViewModel.isMapShowing {
            router.view(to: .mapArea)
        } else {
            router.view(to: .placesListArea)
        }
    }
}
