//
//  HomeView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI

struct HomeView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.isMapShowing {
            router.view(to: .mapArea)
        } else {
            router.view(to: .placesListArea)
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .homeView)
    }
}
