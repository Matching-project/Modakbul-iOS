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
    
    private let communityRecruitingContent: CommunityRecruitingContent
    
    init(
        participationRequestListViewModel: ParticipationRequestListViewModel,
        communityRecruitingContent: CommunityRecruitingContent
    ) {
        self.viewModel = participationRequestListViewModel
        self.communityRecruitingContent = communityRecruitingContent
    }
    
    var body: some View {
        List(viewModel.participationRequests) { participatedRequest in
            HStack {
                Cell(participatedRequest.participatedUser, communityRecruitingContent.community.category)
                
                Spacer()
                
                HStack {
                    Button {
                        // TODO: 채팅 화면으로 이동
                    } label: {
                        Text("채팅")
                            .font(.footnote.bold())
                    }
                    .buttonStyle(CapsuledInsetButton())
                }
                .layoutPriority(1)
            }
            .listRowSeparator(.hidden)
            .swipeActions(edge: .trailing) {
                Button {
                    // TODO: 참여 요청 수락
                } label: {
                    Text("수락")
                }
                
                Button(role: .destructive) {
                    // TODO: 참여 요청 목록에서 삭제 및 거절
                } label: {
                    Text("거절")
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("참여 요청 목록")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchParticipationRequests(by: communityRecruitingContent.id)
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
            AsyncImageView(url: participatedUser.imageURL)
                .frame(maxWidth: 64, maxHeight: 64)
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(participatedUser.nickname)
                    .font(.headline)
                
                Text("\(selectMajorCategory().description) | \(participatedUser.job.description)")
                    .font(.subheadline)
                    .foregroundStyle(.accent)
            }
            .lineLimit(1)
        }
        
        private func selectMajorCategory() -> Category {
            let candidates = participatedUser.categoriesOfInterest
            return candidates.contains(majorCategory) ? majorCategory : candidates.randomElement() ?? .other
        }
    }
}

struct ParticipationRequestListView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .participationRequestListView(communityRecruitingContent: previewHelper.communityRecruitingContents.first!))
    }
}
