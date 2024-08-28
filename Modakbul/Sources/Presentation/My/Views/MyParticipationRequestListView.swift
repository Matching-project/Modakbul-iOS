//
//  MyParticipationRequestListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct MyParticipationRequestListView: View {
    @ObservedObject private var viewModel: MyParticipationRequestListViewModel
    
    init(_ viewModel: MyParticipationRequestListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content(viewModel.communityRecruitingContents.isEmpty)
            .navigationTitle("나의 참여 요청 목록")
            .navigationBarTitleDisplayMode(.inline)
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
            
            Spacer()
            
            Button {
                // TODO: 요청 취소
            } label: {
                Text("요청 취소")
                    .font(.footnote.bold())
            }
            .buttonStyle(.capsuledInset)
        }
    }
}

struct MyParticipationRequestListView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyParticipationRequestListView(MyParticipationRequestListViewModel())
        }
    }
}
