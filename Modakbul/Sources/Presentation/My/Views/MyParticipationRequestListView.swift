//
//  MyParticipationRequestListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct MyParticipationRequestListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: MyParticipationRequestListViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = -1
    
    init(_ viewModel: MyParticipationRequestListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content(viewModel.communityRecruitingContents.isEmpty)
            .navigationTitle("나의 참여 요청 목록")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.configureView(userId: Int64(userId))
            }
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            Text("아직 참여를 요청한 모임이 없어요.")
                .font(.headline)
        } else {
            List {
                ForEach(viewModel.communityRecruitingContents, id: \.id) { content in
                    listCell(content)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ content: CommunityRecruitingContent) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(content.title)
                    .font(.headline)
                
                HStack(spacing: 10) {
                    Text(content.community.category.description)
                    
                    Text("\(content.community.participantsCount)/\(content.community.participantsLimit)명")
                    
                    Text(content.community.meetingDate)
                    
                    Text("\(content.community.startTime)~\(content.community.endTime)")
                }
                .font(.caption)
            }
            .listRowSeparator(.hidden)
            .padding(.vertical, 4)
            .contentShape(.rect)
            .onTapGesture {
                router.route(to: .placeInformationDetailView(communityRecruitingContentId: content.id, userId: Int64(userId)))
            }
            
            Spacer()
            
            Button {
                viewModel.cancelParticipationRequest(userId: Int64(userId), with: content.id)
            } label: {
                Text("요청 취소")
                    .font(.footnote.bold())
            }
            .buttonStyle(.capsuledInset)
        }
    }
}
