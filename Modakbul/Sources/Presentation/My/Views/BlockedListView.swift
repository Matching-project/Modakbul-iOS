//
//  BlockedListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct BlockedListView: View {
    @ObservedObject private var viewModel: BlockedListViewModel
    
    init(_ viewModel: BlockedListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content(viewModel.blockedUser.isEmpty)
            .navigationTitle("차단 목록")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            Text("아직 차단한 사용자가 없어요.")
                .font(.headline)
        } else {
            List {
                ForEach(viewModel.blockedUser, id: \.id) { user in
                    listCell(user)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ user: User) -> some View {
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
                // MARK: 차단 해제
            } label: {
                Text("차단 해제")
                    .font(.footnote.bold())
            }
            .buttonStyle(.capsuledInset)
        }
    }
}

#Preview {
    NavigationStack {
        BlockedListView(BlockedListViewModel())
    }
}
