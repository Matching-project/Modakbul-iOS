//
//  MyParticipationRequestListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

fileprivate typealias Match = (communityRecruitingContent: CommunityRecruitingContent, matchingId: Int64, matchState: MatchState)

struct MyParticipationRequestListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: MyParticipationRequestListViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId 
    
    init(_ viewModel: MyParticipationRequestListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content(viewModel.matches.isEmpty)
            .navigationTitle("나의 참여 요청 목록")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.configureView(userId: Int64(userId))
            }
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            Text("아직 참여를 요청한 모임이 없어요.")
                .font(.Modakbul.headline)
        } else {
            List {
                ForEach(viewModel.matches, id: \.communityRecruitingContent.id) { match in
                    listCell(match)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ match: Match) -> some View {
        let state = match.matchState
        let matchingId = match.matchingId
        let content = match.communityRecruitingContent
        
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(content.title)
                    .font(.Modakbul.headline)
                
                HStack(spacing: 10) {
                    Text(content.community.category.description)
                    
                    Text("\(content.community.participantsCount)/\(content.community.participantsLimit)명")
                    
                    Text(content.community.meetingDate)
                    
                    Text("\(content.community.startTime)~\(content.community.endTime)")
                }
                .font(.Modakbul.caption)
            }
            .listRowSeparator(.hidden)
            .padding(.vertical, 4)
            .contentShape(.rect)
            .onTapGesture {
//                router.route(to: .placeInformationDetailView(communityRecruitingContentId: content.id, userId: Int64(userId)))
            }
            
            Spacer()
            
            Button {
                viewModel.cancelParticipationRequest(userId: Int64(userId), with: content.id)
            } label: {
                switch state {
                case .accepted:
                    Text("나가기")
                        .font(.Modakbul.footnote)
                        .bold()
                default:
                    Text("요청 취소")
                        .font(.Modakbul.footnote)
                        .bold()
                }
            }
            .buttonStyle(.capsuledInset)
        }
    }
}
