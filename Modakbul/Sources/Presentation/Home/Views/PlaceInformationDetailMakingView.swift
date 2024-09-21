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
    private let place: Place
    private let communityRecruitingContent: CommunityRecruitingContent?
    
    init(
        _ vm: PlaceInformationDetailMakingViewModel,
        place: Place,
        communityRecruitingContent: CommunityRecruitingContent?
    ) {
        self.vm = vm
        self.place = place
        self.communityRecruitingContent = communityRecruitingContent
        UIDatePicker.appearance().minuteInterval = 10
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    cell(title: "장소") {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accent)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .opacity(0.1)
                                }

                            Text(vm.place?.location.name ?? "")
                                .padding()
                        }
                    }
                    
                    cell(title: "카테고리") {
                        MenuPicker.Default(selection: $vm.category)
                            .roundedRectangleStyle()
                    }
                    
                    cell(title: "모집인원") {
                        MenuPicker.Range(selection: $vm.peopleCount, range: 1...10)
                            .roundedRectangleStyle()
                    }
                    
                    cell(title: "날짜") {
                        ZStack(alignment: .leading) {
                            Text(vm.date.toString(by: .yyyyMMdd))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                            
                            DatePicker(
                                "",
                                selection: $vm.date,
                                in: Date.now...,
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .transformEffect(.init(scaleX: 2, y: 1))
                            .opacity(0.02)
                        }
                        .padding(-8)
                        .roundedRectangleStyle()
                    }
                    
                    cell(title: "진행시간") {
                        HStack {
                            ZStack(alignment: .leading) {
                                Text(vm.startTime.toString(by: .HHmm))
                                    .padding(.leading, 4)
                                
                                DatePicker(
                                    "",
                                    selection: $vm.startTime,
                                    in: vm.after(vm.date),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .transformEffect(.init(scaleX: 0.5, y: 1))
                                .labelsHidden()
                                .opacity(0.02)
                            }
                            
                            Text("-")
                                .padding(.leading, -25)
                            
                            ZStack(alignment: .leading) {
                                Text(vm.endTime.toString(by: .HHmm))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onChange(of: vm.startTime) { newStartTime in
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
                                .labelsHidden()
                                .opacity(0.02)
                            }
                            .padding(.leading, -20)
                        }
                        .padding(-10)
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
            .padding(.horizontal, Constants.horizontal)
            .padding(.vertical, 5)
            
        }
        .navigationModifier(title: communityRecruitingContent == nil ? "모집글 작성" : "모집글 수정") {
            vm.initialize()
            router.dismiss()
        }
        .onAppear {
            vm.place = place
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

struct PlaceInformationDetailMakingView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .placeInformationDetailMakingView(place: Place(location: Location()), communityRecruitingContent: nil))
    }
}
