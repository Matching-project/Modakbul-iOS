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
    
    private let labelWidth: CGFloat = 80
    
    init(_ placeInformationDetailMakingViewModel: PlaceInformationDetailMakingViewModel) {
        self.vm = placeInformationDetailMakingViewModel
        UIDatePicker.appearance().minuteInterval = 10
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    makeRow(title: "장소") {
                        RoundedTextField("", text: $vm.location, disabled: true)
                    }
                    
                    makeRow(title: "카테고리") {
                        MenuPicker.Default(selection: $vm.category)
                            .roundedRectangleStyle()
                    }
                    
                    makeRow(title: "모집인원") {
                        MenuPicker.Range(selection: $vm.peopleCount, range: 1...10)
                            .roundedRectangleStyle()
                    }
                    
                    makeRow(title: "날짜") {
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
                    
                    makeRow(title: "진행시간") {
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
                                .padding(.horizontal, -46)
                            
                            ZStack(alignment: .leading) {
                                Text(vm.endTime.toString(by: .HHmm))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onChange(of: vm.startTime) { newStartTime in
                                        if vm.endTime < newStartTime {
                                            vm.endTime = newStartTime
                                        }
                                    }
                                    .padding(.horizontal, -47)
                                
                                DatePicker(
                                    "",
                                    selection: $vm.endTime,
                                    in: vm.after(vm.startTime),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .padding(.horizontal, -27)
                                .transformEffect(.init(scaleX: 1.8, y: 1))
                                .labelsHidden()
                                .opacity(0.02)
                            }
                        }
                        .padding(-9)
                        .roundedRectangleStyle()
                    }
                    
                    RoundedTextField("제목", text: $vm.title)
                        .padding(.top)
                    
                    RoundedTextField("내용", text: $vm.content, axis: .vertical, lineLimit: (10, 10))
                }
                .padding(.horizontal, Constants.horizontal + 2)
                .padding(.bottom, 10)
            }
            
            // TODO: - 최초 게시 여부에 따라 게시하기 / 수정하기로 분기 필요
            // TODO: - padding 값 설정 필요
            FlatButton("게시하기") {
                vm.submit()
                vm.initialize()
                router.dismiss()
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.vertical, 5)
            
        }
        // TODO: - 최초 게시 여부에 따라 모집글 작성 / 모집글 수정으로 분기 필요
        .navigationModifier(title: "모집글 작성") {
            vm.initialize()
            router.dismiss()
        }
    }
    
    private func makeRow(title: String, @ViewBuilder content: () -> some View) -> some View {
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
        router.view(to: .placeInformationDetailMakingView)
    }
}
