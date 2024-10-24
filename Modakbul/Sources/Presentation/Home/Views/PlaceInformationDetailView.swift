//
//  PlaceInformationDetailView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import SwiftUI
import SwiftData

struct PlaceInformationDetailView<Router: AppRouter>: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: PlaceInformationDetailViewModel
    @AppStorage(AppStorageKey.userNickname) private var userNickname: String = Constants.temporalUserNickname
    
    private let placeId: Int64
    private let locationName: String
    private let communityRecruitingContentId: Int64
    private let userId: Int64
    
    init(
        _ vm: PlaceInformationDetailViewModel,
        placeId: Int64,
        locationName: String,
        communityRecruitingContentId: Int64,
        userId: Int64
    ) {
        self.vm = vm
        self.placeId = placeId
        self.locationName = locationName
        self.communityRecruitingContentId = communityRecruitingContentId
        self.userId = userId
    }
    
    var body: some View {
        buildView(vm.communityRecruitingContent == nil)
            .task {
                await vm.configureView(communityRecruitingContentId, userId)
            }
            .onChange(of: vm.isDeleted) { oldValue, newValue in
                // 모집글 삭제 처리 완료 되었으면 dismiss
                if oldValue == false, newValue == true {
                    router.dismiss()
                }
            }
            .onChange(of: vm.isCompleted) { oldValue, newValue in
                // 모집글 모집 종료 처리 완료 되었으면 dismiss
                if oldValue == false, newValue == true {
                    router.dismiss()
                }
            }
            .onChange(of: vm.chatRoomConfiguration) { _, configuration in
                /**
                 https://forums.developer.apple.com/forums/thread/747801
                 
                 * SwiftData Predicate 문법 내에서 객체의 프로퍼티를 직접 참조할 수 없음.
                 클로저 외부에서 `chatRoomId`를 상수 바인딩 후 Predicate 참조 값으로 사용.
                 */
                guard let configuration = configuration else { return }
                let chatRoomId = configuration.id
                
                let descriptor = FetchDescriptor<ChatRoom>(
                    predicate: #Predicate<ChatRoom> { $0.id == chatRoomId }
                )
                
                if let chatRoom = try? modelContext.fetch(descriptor).first {
                    router.route(to: .chatView(chatRoom: chatRoom))
                    return
                }
                
                router.route(to: .chatView(chatRoom: ChatRoom(configuration: configuration)))
            }
            .navigationModifier {
                router.dismiss()
            }
    }
    
    @ViewBuilder private func buildView(_ isContentEmpty: Bool) -> some View {
        if isContentEmpty {
            ContentUnavailableView("내용을 불러오는 중 입니다.", image: "Marker")
        } else {
            VStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ScrollView(.vertical) {
                        LazyVStack {
                            ImageCaroselArea(size, vm.imageURLs)
                            
                            HeaderArea(vm.title, vm.creationDate, vm.writer)
                                .environmentObject(router)
                            
                            TagArea(vm.category, vm.recruitingCount, vm.meetingDate, vm.meetingTime)
                            
                            ContentArea(vm.content)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                
                controls()
                    .padding()
            }
            .toolbar {
                if vm.role == .exponent {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                router.route(to: .placeInformationDetailMakingView(placeId: placeId, locationName: locationName, communityRecruitingContent: vm.communityRecruitingContent))
                            } label: {
                                Text("모집글 수정하기")
                            }
                            
                            Button {
                                vm.deleteCommunityRecruitingContent(userId: userId)
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
        switch vm.role {
        case .exponent:
            HStack {
                FlatButton("요청목록") {
                    if let communityRecruitingContent = vm.communityRecruitingContent {
                        router.route(to: .participationRequestListView(communityRecruitingContent: communityRecruitingContent, userId: userId))
                    }
                }
                
                FlatButton("모집종료") {
                    vm.completeCommunityRecruiting()
                }
            }
        case .participant:
            HStack {
                FlatButton("채팅하기") {
                    vm.routeToChatRoom(userId: userId, opponentUserId: vm.writer.id)
                }
                
                FlatButton("나가기") {
                    vm.exitCommunity(userNickname: userNickname)
                }
            }
        case .nonParticipant:
            HStack {
                FlatButton("채팅하기") {
                    vm.routeToChatRoom(userId: userId, opponentUserId: vm.writer.id)
                }
                
                MatchRequestButton(matchState: $vm.matchState, isFull: $vm.isFull, userNickname: userNickname) { userNickname in
                    vm.requestMatch(userNickname: userNickname)
                }
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
        
        let userNickname: String
        let action: (String) -> Void
        
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
                    action(userNickname)
                }
                .disabled(isFull)
            }
        }
    }
}
