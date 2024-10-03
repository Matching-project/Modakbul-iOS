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
    
    enum DisplayMode {
        /// 날짜, 시간만 표시
        case fullFilled
        
        /// 카테고리, 모집인원, 날짜, 시간 모두 표시
        case summary
    }
    
    private let items: [CommunityRelationship]
    private let selection: [(state: ActiveState, title: String)]
    private let filteringOption: (CommunityRelationship) -> Bool
    private let onSelectCell: (CommunityRelationship) -> Void
    private let displayMode: DisplayMode
    
    init(
        selectedTab: Binding<ActiveState>,
        _ selection: [(state: ActiveState, title: String)],
        _ items: [CommunityRelationship],
        _ displayMode: DisplayMode,
        _ filteringOption: @escaping (CommunityRelationship) -> Bool,
        onSelectCell: @escaping (CommunityRelationship) -> Void
    ) {
        self._selectedTab = selectedTab
        self.selection = selection
        self.items = items
        self.filteringOption = filteringOption
        self.displayMode = displayMode
        self.onSelectCell = onSelectCell
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(selection, id: \.state) { (state, title) in
                    tab((state, title))
                }
            }
            
            List(items.filter(filteringOption), id: \.communityRecruitingContent.id) { relationship in
                listCell(relationship)
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
                    .font(.Modakbul.headline)
                    .frame(maxWidth: .infinity)
                
                if selectedTab == selection.state {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(height: 4)
                        .matchedGeometryEffect(id: "bar", in: namespace)
                }
            }
        }
    }
    
    @ViewBuilder private func listCell(_ relationship: CommunityRelationship) -> some View {
        let content = relationship.communityRecruitingContent
        
        VStack(alignment: .leading, spacing: 10) {
            Text(content.title)
                .font(.Modakbul.headline)
            
            tagArea(relationship.communityRecruitingContent)
        }
        .listRowSeparator(.hidden)
        .padding(.vertical, 4)
        .contentShape(.rect)
        .onTapGesture {
            onSelectCell(relationship)
        }
    }
    
    @ViewBuilder private func tagArea(_ content: CommunityRecruitingContent) -> some View {
        let category = content.community.category.description
        let participants = "\(content.community.participantsCount)/\(content.community.participantsLimit)명"
        let meetingDateComponents = content.community.meetingDate.split(separator: "-")
        let startTimeComponents = content.community.startTime.split(separator: ":")
        let endTimeComponents = content.community.endTime.split(separator: ":")
        
        switch displayMode {
        case .fullFilled:
            HStack(spacing: 10) {
                Text(category)
                
                Text(participants)
                
                Text("\(meetingDateComponents[1])월 \(meetingDateComponents[2])일")
                
                Text("\(startTimeComponents[0]):\(startTimeComponents[1])~\(endTimeComponents[0]):\(endTimeComponents[1])")
            }
            .font(.Modakbul.caption)
        case .summary:
            HStack(spacing: 10) {
                Text("\(meetingDateComponents[1])월 \(meetingDateComponents[2])일")
                
                Text("\(startTimeComponents[0]):\(startTimeComponents[1])~\(endTimeComponents[0]):\(endTimeComponents[1])")
            }
            .font(.Modakbul.caption)
        }
    }
}
