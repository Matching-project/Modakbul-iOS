//
//  PlaceInformationDetailView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import SwiftUI

struct PlaceInformationDetailView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
//    @ObservedObject private var placeInformationDetailViewModel: PlaceInformationDetailViewModel
    
    private let communityRecruitingContentId: String
    
    @State private var index: Int = 0
    private let arr = [0, 1, 2, 3, 4, 5]
    
    init(
//        placeInformationDetailViewModel: PlaceInformationDetailViewModel,
        communityRecruitingContentId: String
    ) {
//        self.placeInformationDetailViewModel = placeInformationDetailViewModel
        self.communityRecruitingContentId = communityRecruitingContentId
    }
    
    var body: some View {
        // TODO: Connect to data source
        GeometryReader { proxy in
            ScrollView(.vertical) {
                TabView(selection: $index) {
                    ForEach(arr, id: \.self) { num in
                        Text("\(num)")
                            .tag(num)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(.gray)
                .frame(width: proxy.size.width, height: proxy.size.height / 3)
                .overlay(alignment: .bottom) {
                    CustomPageControl(currentPageIndex: $index, pageCountLimit: arr.count)
                        .alignmentGuide(.bottom) { dimension in
                            dimension.height + 30
                        }
                }
            }
        }
    }
}

struct PlaceInformationDetailView_Preview: PreviewProvider {
    static var previews: some View {
        PlaceInformationDetailView<DefaultAppRouter>(communityRecruitingContentId: previewHelper.places.first!.communities.first!.id)
    }
}
