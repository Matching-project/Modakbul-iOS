//
//  PlaceInformationDetailMakingView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/12/24.
//

import SwiftUI

struct PlaceInformationDetailMakingView<Router: AppRouter>: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: PlaceInformationDetailMakingViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    private let labelWidth: CGFloat = 80
    private let placeId: Int64
    private let locationName: String
    private let communityRecruitingContent: CommunityRecruitingContent?
    
    init(
        _ vm: PlaceInformationDetailMakingViewModel,
        placeId: Int64,
        locationName: String,
        communityRecruitingContent: CommunityRecruitingContent?
    ) {
        self.vm = vm
        self.placeId = placeId
        self.locationName = locationName
        self.communityRecruitingContent = communityRecruitingContent
        UIDatePicker.appearance().minuteInterval = 10
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    cell(title: "장소") {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accent)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .opacity(0.1)
                                }
                            
                            Text(vm.locationName ?? "")
                                .padding()
                        }
                    }
                    
                    cell(title: "카테고리") {
                        MenuPicker.Default(selection: $vm.category)
                            .roundedRectangleStyle()
                    }
                    
                    cell(title: "모집인원") {
                        MenuPicker.Range(selection: $vm.peopleCount, range: 2...10)
                            .roundedRectangleStyle()
                    }
                    
                    cell(title: "날짜") {
                        ZStack(alignment: .leading) {
                            Text(vm.date.toString(by: .yyyyMMdd))
                            
                            DatePicker(
                                "",
                                selection: $vm.date,
                                in: Date.now...,
                                displayedComponents: [.date]
                            )
                            .transformEffect(.init(scaleX: 0.85, y: 1))
                            .position(x: 45, y: 16)
                            .labelsHidden()
                            .colorMultiply(.clear)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, -8)
                        .roundedRectangleStyle()
                    }
                    
                    cell(title: "진행시간") {
                        HStack {
                            ZStack {
                                Text(vm.startTime.toString(by: .HHmm))
                                
                                DatePicker(
                                    "",
                                    selection: $vm.startTime,
                                    in: vm.after(vm.date),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .transformEffect(.init(scaleX: 0.7, y: 1))
                                .position(x: 35, y: 16)
                                .labelsHidden()
                                .colorMultiply(.clear)
                            }
                            .frame(maxWidth: 50)

                            Text("-")
                            
                            ZStack {
                                Text(vm.endTime.toString(by: .HHmm))
                                    .onChange(of: vm.startTime) { _, newStartTime in
                                        if vm.endTime < newStartTime {
                                            vm.endTime = newStartTime
                                        }
                                    }
                                
                                DatePicker(
                                    "",
                                    selection: $vm.endTime,
                                    in: vm.after(vm.startTime),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .transformEffect(.init(scaleX: 0.7, y: 1))
                                .position(x: 35, y: 16)
                                .labelsHidden()
                                .colorMultiply(.clear)
                            }
                            .frame(maxWidth: 50)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, -4)
                        .padding(.vertical, -8)
                        .roundedRectangleStyle()
                    }
                    
                    RoundedTextField("제목", text: $vm.title)
                        .padding(.top)
                    
                    RoundedTextField("내용", text: $vm.content, axis: .vertical, lineLimit: (10, 10))
                }
                .padding(.horizontal, Constants.horizontal + 2)
                .padding(.bottom, 10)
            }
            
            // TODO: - padding 값 설정 필요
            FlatButton(communityRecruitingContent == nil ? "게시하기" : "수정하기") {
                vm.submit(communityRecruitingContent?.id, userId: Int64(userId))
                vm.initialize()
                router.dismiss()
            }
            .disabled(vm.title.isEmpty || vm.content.isEmpty)
            .padding(.horizontal, Constants.horizontal)
            .padding(.vertical, 5)
        }
        .navigationModifier(title: communityRecruitingContent == nil ? "모집글 작성" : "모집글 수정") {
            vm.initialize()
            router.dismiss()
        }
        .onAppear {
            vm.placeId = placeId
            vm.locationName = locationName
            vm.configureView(communityRecruitingContent)
        }
    }
    
    private func cell(title: String, @ViewBuilder content: () -> some View) -> some View {
        HStack {
            Text(title)
                .bold()
                .frame(width: labelWidth, alignment: .leading)
            
            content()
        }
    }
}
