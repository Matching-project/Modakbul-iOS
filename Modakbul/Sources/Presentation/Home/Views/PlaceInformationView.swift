//
//  PlaceInformationView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlaceInformationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var viewModel: PlaceInformationViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    private let place: Place
    private let displayMode: DisplayMode
    
    init(
        _ viewModel: PlaceInformationViewModel,
        place: Place,
        displayMode: DisplayMode
    ) {
        self.viewModel = viewModel
        self.place = place
        self.displayMode = displayMode
    }
    
    var body: some View {
        VStack {
            HStack {
                if let url = place.imageURLs.first {
                    AsyncImageView(url: url, minWidth: 100, minHeight: 100)
                } else {
                    Image(colorScheme == .light ? .modakbulMainLight : .modakbulMainDark)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 100, height: 100)
                }
                
                informationArea
                
                Spacer()
            }
            .overlay(alignment: .topTrailing) {
                communityRecruitingContentEditButton
            }
            
            Spacer()
            
            if viewModel.communityRecruitingContents.isEmpty {
                Text("아직 모집 중인 모임이 없어요.")
                    .font(.Modakbul.footnote)
            } else {
                communityRecruitingContentListArea(displayMode)
            }
            
            Spacer()
        }
        .task {
            viewModel.configureView(by: place)
            await viewModel.fetchCommunityRecruitingContents(with: place.id)
        }
    }
    
    private var informationArea: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.location.name)
                    .font(.Modakbul.title3)
                    .bold()
                
                Text(place.location.address)
                    .font(.Modakbul.caption)
            }
            .padding(.top)
            
            HStack {
                Text("운영시간 ")
                
                Menu {
                    ForEach(place.openingHours, id: \.dayOfWeek) { openingHour in
                        Button {
                            viewModel.selectedOpeningHourByDay = openingHour
                        } label: {
                            Text(viewModel.displayOpeningHours(openingHour))
                        }
                    }
                } label: {
                    Text(viewModel.openingHourText)
                    Image(systemName: "chevron.down")
                }
            }
            
            HStack {
                CapsuleTag(place.powerSocketState.description, .Modakbul.caption)
                CapsuleTag(place.groupSeatingState.description, .Modakbul.caption)
            }
        }
        .font(.Modakbul.caption)
    }
    
    private var communityRecruitingContentEditButton: some View {
        Button {
            router.route(to: .placeInformationDetailMakingView(place: place, communityRecruitingContent: nil))
        } label: {
            Image(.photoUploadSelection)
                .resizable()
                .scaledToFit()
        }
        .frame(width: 30, height: 30)
        // MARK: - https://stackoverflow.com/q/56561064
        .buttonStyle(BorderlessButtonStyle())
        .shadow(color: .gray.opacity(0.3), radius: 4, y: 4)
    }
    
    @ViewBuilder private func communityRecruitingContentListArea(_ displayMode: DisplayMode) -> some View {
        switch displayMode {
        case .summary:
            HStack(spacing: 20) {
                Image(.marker)
                
                Text("모임 \(viewModel.communityRecruitingContents.count)개 진행 중")
            }
        case .full:
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.communityRecruitingContents, id: \.id) { communityRecruitingContent in
                        Cell(communityRecruitingContent)
                            .contentShape(.rect)
                            .onTapGesture {
                                router.dismiss()
                                if userId == Constants.loggedOutUserId {
                                    router.route(to: .loginView)
                                } else {
                                    router.route(to: .placeInformationDetailView(communityRecruitingContentId: communityRecruitingContent.id, userId: Int64(userId)))
                                }
                            }
                    }
                }
            }
            .padding(.top)
        }
    }
}

extension PlaceInformationView {
    struct Cell: View {
        private let communityRecruitingContent: CommunityRecruitingContent
        
        private var community: Community { communityRecruitingContent.community }
        
        init(_ communityRecruitingContent: CommunityRecruitingContent) {
            self.communityRecruitingContent = communityRecruitingContent
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(communityRecruitingContent.title)
                    .font(.Modakbul.headline)
                
                HStack {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("\(community.participants.count)/\(community.participantsLimit)")
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("\(community.startTime)~\(community.endTime)")
                    }
                    
                    Text(community.category.description)
                }
                .font(.Modakbul.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(.accent)
            )
        }
    }
}

extension PlaceInformationView {
    enum DisplayMode {
        /// 모집글 목록 축약 표시
        ///
        /// 진행 중인 모임의 개수만 표시합니다.
        case summary
        
        /// 모집글 목록 전부 표시
        ///
        /// 모집글 목록을 모두 표시합니다.
        case full
    }
}

struct PlaceInformationSheet_Preview: PreviewProvider {
    static let listUp: Bool = true
    
    static var previews: some View {
        Group {
            if listUp {
                List(previewHelper.places, id: \.id) {
                    router.view(to: .placeInformationView(place: $0, displayMode: .full))
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            } else {
                router.view(to: .placeInformationView(place: previewHelper.places.first!, displayMode: .summary))
            }
        }
    }
}
