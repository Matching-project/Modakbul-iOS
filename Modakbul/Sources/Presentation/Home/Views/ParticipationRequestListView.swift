//
//  ParticipationRequestListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import SwiftUI

struct ParticipationRequestListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: ParticipationRequestListViewModel
    @AppStorage(AppStorageKey.userNickname) private var userNickname: String = Constants.temporalUserNickname
    
    private let communityRecruitingContent: CommunityRecruitingContent
    private let userId: Int64
    
    init(
        participationRequestListViewModel: ParticipationRequestListViewModel,
        communityRecruitingContent: CommunityRecruitingContent,
        userId: Int64
    ) {
        self.viewModel = participationRequestListViewModel
        self.communityRecruitingContent = communityRecruitingContent
        self.userId = userId
    }
    
    var body: some View {
        content(viewModel.participationRequests.isEmpty)
            .navigationTitle("참여 요청 목록")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchParticipationRequests(userId: userId, by: communityRecruitingContent)
            }
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            ContentUnavailableView("참여 요청 목록이 비어있어요.", systemImage: "doc.append.fill", description: nil)
        } else {
            List(viewModel.participationRequests) { participatedRequest in
                Cell(
                    participatedRequest.participatedUser,
                    communityRecruitingContent.community.category
                )
                    .swipeActions(edge: .trailing) {
                        Button {
                            viewModel.acceptParticipationRequest(userId, userNickname: userNickname, participationRequest: participatedRequest)
                        } label: {
                            Text("수락")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.rejectParticipationRequest(userId, participationRequest: participatedRequest)
                        } label: {
                            Text("거절")
                        }
                    }
            }
            .listStyle(.plain)
        }
    }
}

extension ParticipationRequestListView {
    struct Cell: View {
        private let participatedUser: User
        private let majorCategory: Category
        
        init(
            _ participatedUser: User,
            _ majorCategory: Category
        ) {
            self.participatedUser = participatedUser
            self.majorCategory = majorCategory
        }
        
        var body: some View {
            HStack {
                AsyncImageView(
                    url: participatedUser.imageURL,
                    contentMode: .fill,
                    maxWidth: 64,
                    maxHeight: 64,
                    clipShape: .circle
                )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(participatedUser.nickname)
                        .font(.Modakbul.headline)
                    
                    Text("\(selectMajorCategory().description) | \(participatedUser.job.description)")
                        .font(.Modakbul.subheadline)
                        .foregroundStyle(.accent)
                }
                .lineLimit(1)
                
                Spacer()
                
                Button {
                    // TODO: 채팅 기능 연결
                } label: {
                    Text("채팅")
                        .font(.Modakbul.footnote)
                        .bold()
                }
                .buttonStyle(.capsuledInset)
                .layoutPriority(1)
            }
        }
        
        private func selectMajorCategory() -> Category {
            let candidates = participatedUser.categoriesOfInterest
            return candidates.contains(majorCategory) ? majorCategory : candidates.randomElement() ?? .other
        }
    }
}
