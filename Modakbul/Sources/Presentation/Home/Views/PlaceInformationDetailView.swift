//
//  PlaceInformationDetailView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import SwiftUI

struct PlaceInformationDetailView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: PlaceInformationDetailViewModel
    @State private var index: Int = 0
    
    private let communityRecruitingContentId: Int64
    private let userId: Int64
    
    init(
        _ viewModel: PlaceInformationDetailViewModel,
        communityRecruitingContentId: Int64,
        userId: Int64
    ) {
        self.viewModel = viewModel
        self.communityRecruitingContentId = communityRecruitingContentId
        self.userId = userId
    }
    
    var body: some View {
        content(viewModel.communityRecruitingContent)
            .task {
                await viewModel.configureView(communityRecruitingContentId, userId)
            }
    }
    
    @ViewBuilder private func content(_ communityRecruitingContent: CommunityRecruitingContent?) -> some View {
        if let communityRecruitingContent = communityRecruitingContent {
            VStack {
                GeometryReader { proxy in
                    ScrollView(.vertical) {
                        imageCarouselArea(proxy.size)
                        
                        header(viewModel.title, viewModel.creationDate, viewModel.writer)
                        
                        HStack(spacing: 10) {
                            tagArea("카테고리", viewModel.category)
                            tagArea("모집인원", viewModel.recruitingCount)
                            tagArea("날짜", viewModel.meetingDate)
                            tagArea("진행시간", viewModel.meetingTime)
                        }
                        .padding(.horizontal)
                        
                        Text(viewModel.content)
                            .padding()
                    }
                    .scrollIndicators(.hidden)
                }
                
                controls()
                    .padding()
            }
        } else {
            ContentUnavailableView("내용을 불러오는 중 입니다.", image: "Marker")
        }
    }
    
    @ViewBuilder private func controls() -> some View {
        switch viewModel.role {
        case .exponent:
            HStack {
                FlatButton("요청목록") {
                    if let communityRecruitingContent = viewModel.communityRecruitingContent {
                        router.route(to: .participationRequestListView(communityRecruitingContent: communityRecruitingContent, userId: userId))
                    }
                }
                
                FlatButton("모집종료") {
                    viewModel.completeCommunityRecruiting()
                }
            }
        case .participant:
            HStack {
                FlatButton("채팅하기") {
                    // TODO: 채팅하기 기능 연결
                }
                
                FlatButton("나가기") {
                    viewModel.exitCommunity()
                }
            }
        case .nonParticipant:
            HStack {
                FlatButton("채팅하기") {
                    // TODO: 채팅하기 기능 연결
                }
                
                MatchRequestButton(viewModel: viewModel)
            }
        }
    }
    
    @ViewBuilder private func imageCarouselArea(_ size: CGSize) -> some View {
        if let imageURLs = viewModel.communityRecruitingContent?.placeImageURLs {
            TabView(selection: $index) {
                ForEach(0..<imageURLs.count, id: \.self) { index in
                    AsyncImageView(url: imageURLs[index])
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: size.width, height: size.height / 3)
            .overlay(alignment: .bottom) {
                CustomPageControl(currentPageIndex: $index, pageCountLimit: imageURLs.count)
                    .alignmentGuide(.bottom) { dimension in
                        dimension.height + 30
                    }
            }
        } else {
            ContentUnavailableView("미리보기 사진이 없어요.", image: "questionmark", description: Text("이 장소의 사진을 제보해주세요!"))
                .frame(width: size.width, height: size.height / 3)
        }
    }
    
    @ViewBuilder private func header(_ title: String, _ date: String, _ user: User) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.Modakbul.title2)
                .bold()
                .lineLimit(1)
            
            HStack {
                AsyncImageView(url: user.imageURL)
                
                VStack(alignment: .leading) {
                    Text("작성자")
                    Text(user.nickname)
                    Text("게시일: \(viewModel.creationDate)")
                        .font(.Modakbul.caption)
                }
                .font(.Modakbul.headline)
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
        .font(.Modakbul.caption)
        .bold()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.accent)
        )
    }
    
    struct MatchRequestButton: View {
        @ObservedObject var viewModel: PlaceInformationDetailViewModel
        
        var body: some View {
            switch viewModel.matchState {
            case .pending:
                FlatButton("요청 중") {
                    //
                }
                .disabled(true)
            case .rejected:
                FlatButton("거절됨") {
                    //
                }
                .disabled(true)
            default:
                FlatButton("참여 요청하기") {
                    viewModel.requestMatch()
                }
            }
        }
    }
}
