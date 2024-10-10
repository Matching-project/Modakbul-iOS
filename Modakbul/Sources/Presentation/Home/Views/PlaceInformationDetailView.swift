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
    
    private let placeId: Int64
    private let locationName: String
    private let communityRecruitingContentId: Int64
    private let userId: Int64
    
    init(
        _ viewModel: PlaceInformationDetailViewModel,
        placeId: Int64,
        locationName: String,
        communityRecruitingContentId: Int64,
        userId: Int64
    ) {
        self.viewModel = viewModel
        self.placeId = placeId
        self.locationName = locationName
        self.communityRecruitingContentId = communityRecruitingContentId
        self.userId = userId
    }
    
    var body: some View {
        buildView(viewModel.communityRecruitingContent == nil)
            .task {
                await viewModel.configureView(communityRecruitingContentId, userId)
            }
            .onChange(of: viewModel.isDeleted) { oldValue, newValue in
                // 모집글 삭제 처리 완료 되었으면 dismiss
                if oldValue == false, newValue == true {
                    router.dismiss()
                }
            }
            .onChange(of: viewModel.isCompleted) { oldValue, newValue in
                // 모집글 모집 종료 처리 완료 되었으면 dismiss
                if oldValue == false, newValue == true {
                    router.dismiss()
                }
            }
            .onReceive(viewModel.$chatRoomConfiguration) { chatRoomConfiguration in
                // MARK: - 기존 채팅방이 없는 경우, 임시적으로 채팅방 아이디를 만들어 라우팅
                router.route(to: .chatView(chatRoomId: chatRoomConfiguration?.id ?? Constants.temporalId))
            }
            .navigationModifier {
                router.dismiss()
            }
    }
    
    @ViewBuilder private func buildView(_ isContentEmpty: Bool) -> some View {
        if isContentEmpty {
            VStack {
                ContentUnavailableView("내용을 불러오는 중 입니다.", image: "Marker")
                Button {
                    viewModel.communityRecruitingContent = PreviewHelper.shared.communityRecruitingContents.first
                } label: {
                    Text("슛")
                }
            }
        } else {
            VStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ScrollView(.vertical) {
                        LazyVStack {
                            ImageCaroselArea(size, viewModel.imageURLs)
                            
                            HeaderArea(viewModel.title, viewModel.creationDate, viewModel.writer)
                                .environmentObject(router)
                            
                            TagArea(viewModel.category, viewModel.recruitingCount, viewModel.meetingDate, viewModel.meetingTime)
                            
                            ContentArea(viewModel.content)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                
                controls()
                    .padding()
            }
            .toolbar {
                if viewModel.role == .exponent {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                router.route(to: .placeInformationDetailMakingView(placeId: placeId, locationName: locationName, communityRecruitingContent: viewModel.communityRecruitingContent))
                            } label: {
                                Text("모집글 수정하기")
                            }
                            
                            Button {
                                viewModel.deleteCommunityRecruitingContent(userId: userId)
                            } label: {
                                Text("모집글 삭제하기")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
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
                    viewModel.readChatRoom(userId: userId, opponentUserId: viewModel.writer.id)
                }
                
                FlatButton("나가기") {
                    viewModel.exitCommunity()
                }
            }
        case .nonParticipant:
            HStack {
                FlatButton("채팅하기") {
                    viewModel.readChatRoom(userId: userId, opponentUserId: viewModel.writer.id)
                }
                
                MatchRequestButton(matchState: $viewModel.matchState, isFull: $viewModel.isFull, action: viewModel.requestMatch)
            }
        }
    }
}

extension PlaceInformationDetailView {
    private struct ImageCaroselArea: View {
        @State private var index: Int = 0
        
        let size: CGSize
        let imageURLs: [URL?]
        
        init(
            _ size: CGSize,
            _ imageURLs: [URL?]
        ) {
            self.size = size
            self.imageURLs = imageURLs
        }
        
        var body: some View {
            buildView(imageURLs.isEmpty)
                .containerRelativeFrame(.vertical) { value, axis in
                    value / 3
                }
        }
        
        @ViewBuilder private func buildView(_ isImageURLsEmpty: Bool) -> some View {
            if isImageURLsEmpty {
                ContentUnavailableView("미리보기 사진이 없어요.", image: "questionmark", description: Text("이 장소의 사진을 제보해주세요!"))
            } else {
                TabView(selection: $index) {
                    ForEach(0..<imageURLs.count, id: \.self) { index in
                        AsyncImageView(url: imageURLs[index], maxWidth: size.width, maxHeight: size.height)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(alignment: .bottom) {
                    CustomPageControl(currentPageIndex: $index, pageCountLimit: imageURLs.count)
                        .alignmentGuide(.bottom) { dimension in
                            dimension.height + 15
                        }
                }
                .background(.ultraThinMaterial)
            }
        }
    }
    
    private struct HeaderArea: View {
        @EnvironmentObject private var router: Router
        let title: String
        let date: String
        let user: User
        
        init(
            _ title: String,
            _ date: String,
            _ user: User
        ) {
            self.title = title
            self.date = date
            self.user = user
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.Modakbul.title2.bold())
                    .lineLimit(1)
                
                HStack {
                    AsyncImageView(url: user.imageURL, contentMode: .fill, clipShape: .circle)
                    
                    VStack(alignment: .leading) {
                        Text("작성자")
                            .font(.Modakbul.subheadline)
                        Text(user.nickname)
                            .font(.Modakbul.headline)
                        Text("게시일: \(date)")
                            .font(.Modakbul.caption)
                    }
                }
                .contentShape(.rect)
                .onTapGesture {
                    router.route(to: .profileDetailView(opponentUserId: user.id))
                }
            }
            .padding()
            .containerRelativeFrame(.horizontal, alignment: .leading)
        }
    }
    
    private struct TagArea: View {
        let category: String
        let recruitingCount: String
        let meetingDate: String
        let meetingTime: String
        
        init(
            _ category: String,
            _ recruitingCount: String,
            _ meetingDate: String,
            _ meetingTime: String
        ) {
            self.category = category
            self.recruitingCount = recruitingCount
            self.meetingDate = meetingDate
            self.meetingTime = meetingTime
        }
        
        var body: some View {
            HStack(spacing: 10) {
                tag("카테고리", category)
                tag("모집인원", recruitingCount)
                tag("날짜", meetingDate)
                tag("진행시간", meetingTime)
            }
            .padding(.horizontal)
        }
        
        @ViewBuilder private func tag(_ title: String, _ subtitle: String) -> some View {
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
            .font(.Modakbul.caption2)
            .bold()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.accent)
            )
        }
    }
    
    private struct ContentArea: View {
        let content: String
        
        init(_ content: String) {
            self.content = content
        }
        
        var body: some View {
            Text(content)
                .multilineTextAlignment(.leading)
                .padding()
        }
    }
    
    private struct MatchRequestButton: View {
        @Binding var matchState: MatchState
        @Binding var isFull: Bool
        
        let action: () -> Void
        
        var body: some View {
            switch matchState {
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
                    action()
                }
                .disabled(isFull)
            }
        }
    }
}
