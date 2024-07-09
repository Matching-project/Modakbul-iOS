//
//  MyView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/25/24.
//

import SwiftUI

struct MyView<Router: AppRouter>: View where Router.Destination == Route {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        Button {
            router.route(to: .placeShowcaseView)
        } label: {
            Text("카페 제보하기")
        }
    }
}
