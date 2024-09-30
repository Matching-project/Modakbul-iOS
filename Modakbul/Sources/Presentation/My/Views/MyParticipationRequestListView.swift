//
//  MyParticipationRequestListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

typealias MatchRequest = (relationship: CommunityRelationship, matchingId: Int64, matchState: MatchState)

struct MyParticipationRequestListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: MyParticipationRequestListViewModel
    
    private let userId: Int64
    
    init(
        _ viewModel: MyParticipationRequestListViewModel,
        userId: Int64
    ) {
        self.viewModel = viewModel
        self.userId = userId
    }
    
    var body: some View {
        buildView(viewModel.requests.isEmpty)
            .navigationTitle("나의 참여 요청 목록")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.configureView(userId: userId)
            }
    }
    
    @ViewBuilder private func buildView(_ isRequestsEmpty: Bool) -> some View {
        if isRequestsEmpty {
            VStack {
                Text("아직 참여를 요청한 모임이 없어요.")
                    .font(.Modakbul.headline)
            }
        } else {
            List {
                ForEach(viewModel.requests, id: \.relationship.communityRecruitingContent.id) { request in
                    listCell(request)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ match: MatchRequest) -> some View {
        let placeId = match.relationship.placeId
        let locationName = match.relationship.locationName
        let state = match.matchState
        let matchingId = match.matchingId
        let content = match.relationship.communityRecruitingContent
        
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(content.title)
                    .font(.Modakbul.headline)
                
                HStack(spacing: 10) {
                    Text(content.community.category.description)
                    
                    Text("\(content.community.participantsCount)/\(content.community.participantsLimit)명")
                    
                    Text(content.community.meetingDate)
                    
                    Text("\(content.community.startTime.prefix(5))~\(content.community.endTime.prefix(5))")
                }
                .font(.Modakbul.caption)
            }
            .listRowSeparator(.hidden)
            .padding(.vertical, 4)
            .contentShape(.rect)
            .onTapGesture {
                router.route(to: .placeInformationDetailView(placeId: placeId, locationName: locationName, communityRecruitingContentId: content.id, userId: userId))
            }
            
            Spacer()
            
            switch state {
            case .accepted:
                Button {
                    viewModel.exitMatch(userId: userId, with: matchingId)
                } label: {
                    Text("나가기")
                        .font(.Modakbul.footnote)
                        .bold()
                }
                .buttonStyle(.capsuledInset)
            default:
                Button {
                    viewModel.cancelParticipationRequest(userId: userId, with: matchingId)
                } label: {
                    Text("요청 취소")
                        .font(.Modakbul.footnote)
                        .bold()
                }
                .buttonStyle(.capsuledInset)
            }
        }
    }
}
