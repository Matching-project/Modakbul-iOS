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
    private let arr = [0, 1, 2, 3, 4]
    
    @State private var isExpanded: Bool = false
    
    init(
//        placeInformationDetailViewModel: PlaceInformationDetailViewModel,
        communityRecruitingContentId: String
    ) {
//        self.placeInformationDetailViewModel = placeInformationDetailViewModel
        self.communityRecruitingContentId = communityRecruitingContentId
    }
    
    var body: some View {
        // TODO: Connect to data source
        VStack {
            GeometryReader { proxy in
                ScrollView(.vertical) {
                    imageCarouselArea(proxy.size)
                    
                    header
                    
                    HStack(spacing: 10) {
                        tagArea("카테고리", "디자인")
                        tagArea("모집인원", "4/6")
                        tagArea("요일", "수요일")
                        tagArea("진행시간", "16:00~22:00")
                    }
                    .padding(.horizontal)
                    
                    Text("글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, 글 내용, ")
                        .padding()
                }
                .scrollIndicators(.hidden)
            }
            
            // TODO: 사용자 종류에 따라 버튼 라벨 달라져야 함
            HStack {
                FlatButton("채팅하기") {
                    //
                }
                
                FlatButton("모집종료") {
                    //
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder private func imageCarouselArea(_ size: CGSize) -> some View {
        TabView(selection: $index) {
            ForEach(arr, id: \.self) { num in
                Text("사진 \(num)")
                    .tag(num)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: size.width, height: size.height / 3)
        .overlay(alignment: .bottom) {
            CustomPageControl(currentPageIndex: $index, pageCountLimit: arr.count)
                .alignmentGuide(.bottom) { dimension in
                    dimension.height + 30
                }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("UIUX 디자인 스터디 모임")
                .font(.title2.bold())
            
            HStack {
                Image(systemName: "heart.fill")
                
                VStack(alignment: .leading) {
                    Text("작성자")
                    Text("디자인마스터")
                }
                .font(.headline)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder private func tagArea(_ title: String, _ subtitle: String) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.white)
                .background(.accent, in: .rect(cornerRadius: 14))
            
            Text(subtitle)
                .padding(.bottom)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.accent)
        }
        .font(.caption.bold())
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.accent)
        )
    }
}

struct PlaceInformationDetailView_Preview: PreviewProvider {
    static var previews: some View {
        PlaceInformationDetailView<DefaultAppRouter>(communityRecruitingContentId: previewHelper.places.first!.communities.first!.id)
    }
}
