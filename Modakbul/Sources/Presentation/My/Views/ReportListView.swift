//
//  ReportListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct ReportListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: ReportListViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = -1
    
    init(_ viewModel: ReportListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content(viewModel.reportedUsers.isEmpty)
            .navigationTitle("신고 목록")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.configureView(userId: Int64(userId))
            }
    }
    
    @ViewBuilder private func content(_ condition: Bool) -> some View {
        if condition {
            Text("아직 신고한 사용자가 없어요.")
                .font(.headline)
        } else {
            List {
                ForEach(viewModel.reportedUsers, id: \.user.id) { (user, status) in
                    listCell(user, status)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func listCell(_ user: User, _ status: InquiryStatusType) -> some View {
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
            .onTapGesture {
                router.route(to: .profileDetailView(opponentUserId: user.id))
            }
            
            Spacer()
            
            Button {
                //
            } label: {
                inquiryStatus(status)
                    .font(.footnote.bold())
            }
            .buttonStyle(.capsuledInset)
            .disabled(true)
        }
    }
    
    @ViewBuilder private func inquiryStatus(_ status: InquiryStatusType) -> some View {
        switch status {
        case .completed, .deleted:
            Text("처리 완료")
        case .waiting:
            Text("처리 중")
        }
    }
}
