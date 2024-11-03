//
//  PlaceInformationView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlaceInformationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: PlaceInformationViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    private let place: Place
    
    init(
        _ viewModel: PlaceInformationViewModel,
        place: Place
    ) {
        self.viewModel = viewModel
        self.place = place
    }
    
    var body: some View {
        VStack {
            HStack {
                if let url = place.imageURLs.first {
                    AsyncImageView(
                        url: url,
                        contentMode: .fill,
                        maxWidth: 100,
                        maxHeight: 100,
                        clipShape: .rect(cornerRadius: 8)
                    )
                } else {
                    Image(.modakbulMain)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 100, height: 100)
                }
                
                informationArea
                
                Spacer()
            }
            .overlay(alignment: .topTrailing) {
                communityRecruitingContentEditButton
                    .padding([.top, .trailing], 20)
            }
            
            Spacer()
            
            communityRecruitingContentListArea(viewModel.communityRecruitingContents.isEmpty)
            
            Spacer()
        }
        .padding()
        .task {
            viewModel.configureView(by: place)
            if userId == Constants.loggedOutUserId {
                // TODO: 비로그인 상태일 시 로그인 화면 이동할 것인지, 아니면 모집글 목록 그냥 비워둔 채로 카페 정보만 표시할 것인지 결정
                // 일단 후자로 구현
            } else {
                await viewModel.fetchCommunityRecruitingContents(userId: Int64(userId), with: place.id)
            }
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
                    .padding(.trailing, 50)
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
            router.dismiss()
            if userId == Constants.loggedOutUserId {
                router.alert(for: .login, actions: [
                    .cancelAction("취소") {
                        router.dismiss()
                    },
                    .defaultAction("로그인") {
                        router.route(to: .loginView)
                    }
                ])
            } else {
                router.route(to: .placeInformationDetailMakingView(placeId: place.id, locationName: place.location.name, communityRecruitingContent: nil))
            }
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
    
    @ViewBuilder private func communityRecruitingContentListArea(_ condition: Bool) -> some View {
        if condition {
            Text("아직 모집 중인 모임이 없어요.")
                .font(.Modakbul.footnote)
        } else {
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
                                    router.route(to: .placeInformationDetailView(placeId: place.id, locationName: place.location.name, communityRecruitingContentId: communityRecruitingContent.id, userId: Int64(userId)))
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
                        Text("\(community.participantsCount)/\(community.participantsLimit)")
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("\(community.startTime.prefix(5))~\(community.endTime.prefix(5))")
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
