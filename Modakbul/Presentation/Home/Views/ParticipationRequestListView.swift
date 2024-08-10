//
//  ParticipationRequestListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import SwiftUI

struct ParticipationRequestListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var participationRequestListViewModel: ParticipationRequestListViewModel
    
    private let communityRecruitingContent: CommunityRecruitingContent
    
    init(
        participationRequestListViewModel: ParticipationRequestListViewModel,
        communityRecruitingContent: CommunityRecruitingContent
    ) {
        self.participationRequestListViewModel = participationRequestListViewModel
        self.communityRecruitingContent = communityRecruitingContent
    }
    
    var body: some View {
        List(communityRecruitingContent.community.participants, id: \.email) { user in
            HStack {
                AsyncDynamicSizingImageView(url: user.imageURL, width: 64, height: 64)
                    .clipShape(.circle)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(user.nickname)
                        .font(.headline)
                    
                    Text("\(user.categoriesOfInterest.first!.identifier) | \(user.job.identifier)")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                }
                .lineLimit(1)
                
                Spacer()
                
                HStack {
                    Button {
                        // TODO: 채팅 화면으로 이동
                    } label: {
                        Text("채팅")
                            .font(.footnote.bold())
                    }
                    .buttonStyle(CapsuledInsetButton())
                    
                    Button {
                        // TODO: 참여 요청 수락
                    } label: {
                        Text("수락")
                            .font(.footnote.bold())
                    }
                    .buttonStyle(CapsuledInsetButton())
                }
                .layoutPriority(1)
            }
            .swipeActions {
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
    }
}

struct ParticipationRequestListView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ParticipationRequestListView<DefaultAppRouter>(participationRequestListViewModel: router.resolver.resolve(ParticipationRequestListViewModel.self), communityRecruitingContent: previewHelper.places.first!.communities.first!)
        }
    }
}
