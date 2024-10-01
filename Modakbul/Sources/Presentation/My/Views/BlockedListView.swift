//
//  BlockedListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct BlockedListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: BlockedListViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    init(_ viewModel: BlockedListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content(viewModel.blockedUsers.isEmpty)
            .navigationTitle("차단 목록")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.configureView(userId: Int64(userId))
            }
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            Text("아직 차단한 사용자가 없어요.")
                .font(.Modakbul.headline)
        } else {
            List {
                ForEach(viewModel.blockedUsers, id: \.blockId) { (blockId, user) in
                    listCell(user, blockId)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ user: User, _ blockId: Int64) -> some View {
        HStack {
            AsyncImageView(
                url: user.imageURL,
                contentMode: .fill,
                maxWidth: 64,
                maxHeight: 64,
                clipShape: .circle
            )
            
            VStack(alignment: .leading, spacing: 10) {
                Text(user.nickname)
                    .font(.Modakbul.headline)
                
                Text("\(user.categoriesOfInterest.first!.description) | \(user.job.description)")
                    .font(.Modakbul.subheadline)
                    .foregroundStyle(.accent)
            }
            .lineLimit(1)
            
            Spacer()
            
            Button {
                viewModel.unblock(userId: Int64(userId), blockId: blockId)
            } label: {
                Text("차단 해제")
                    .font(.Modakbul.footnote)
                    .bold()
            }
            .buttonStyle(.capsuledInset)
        }
    }
}
