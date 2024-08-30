//
//  SelectionTab.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

/// 선택된 조건에 따라 탭을 나눈 리스트 컴포넌트 입니다.
///
/// '나의 모집글' 화면을 참고 바랍니다.
struct SelectionTab: View {
    @Binding var selectedTab: ActiveState
    @Namespace private var namespace
    
    private let items: [CommunityRecruitingContent]
    private let selection: [(state: ActiveState, title: String)]
    private let filteringOption: (CommunityRecruitingContent) -> Bool
    private let onSelectCell: (CommunityRecruitingContent) -> Void
    
    init(
        selectedTab: Binding<ActiveState>,
        _ selection: [(state: ActiveState, title: String)],
        _ items: [CommunityRecruitingContent],
        _ filteringOption: @escaping (CommunityRecruitingContent) -> Bool,
        onSelectCell: @escaping (CommunityRecruitingContent) -> Void
    ) {
        self._selectedTab = selectedTab
        self.selection = selection
        self.items = items
        self.filteringOption = filteringOption
        self.onSelectCell = onSelectCell
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(selection, id: \.state) { (state, title) in
                    tab((state, title))
                }
            }
            
            List(items.filter(filteringOption), id: \.id) { content in
                listCell(content)
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func tab(_ selection: (state: ActiveState, title: String)) -> some View {
        Button {
            withAnimation {
                selectedTab = selection.state
            }
        } label: {
            VStack {
                Text(selection.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                
                if selectedTab == selection.state {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(height: 4)
                        .matchedGeometryEffect(id: "bar", in: namespace)
                }
            }
        }
    }
    
    @ViewBuilder private func listCell(_ content: CommunityRecruitingContent) -> some View {
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
            onSelectCell(content)
        }
    }
}
