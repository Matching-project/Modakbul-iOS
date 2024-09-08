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
    
    private let userId: Int64
    
    init(
        _ viewModel: BlockedListViewModel,
        userId: Int64
    ) {
        self.viewModel = viewModel
        self.userId = userId
    }
    
    var body: some View {
        content(viewModel.blockedUsers.isEmpty)
            .navigationTitle("차단 목록")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.configureView(userId: userId)
            }
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            Text("아직 차단한 사용자가 없어요.")
                .font(.headline)
        } else {
            List {
                ForEach(viewModel.blockedUsers, id: \.blockId) { (blockedId, user) in
                    listCell(user, blockedId)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ user: User, _ blockedId: Int64) -> some View {
        HStack {
            AsyncImageView(url: user.imageURL)
                .frame(maxWidth: 64, maxHeight: 64)
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(user.nickname)
                    .font(.headline)
                
                Text("\(user.categoriesOfInterest.first!.description) | \(user.job.description)")
                    .font(.subheadline)
                    .foregroundStyle(.accent)
            }
            .lineLimit(1)
            
            Spacer()
            
            Button {
                viewModel.cancelBlock(userId: userId, blockId: blockedId)
            } label: {
                Text("차단 해제")
                    .font(.footnote.bold())
            }
            .buttonStyle(.capsuledInset)
        }
    }
}
