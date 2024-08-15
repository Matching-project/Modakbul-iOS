//
//  PlaceInformationDetailMakingView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/12/24.
//

import SwiftUI
import Combine

struct PlaceInformationDetailMakingView<Router: AppRouter>: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: PlaceInformationDetailMakingViewModel
    
    private let labelWidth: CGFloat = 80
    
    init(_ placeInformationDetailMakingViewModel: PlaceInformationDetailMakingViewModel) {
        self.vm = placeInformationDetailMakingViewModel
    }
    
    var body: some View {
            ScrollView {
                LazyVStack(spacing: 20) {
                    makeRow(title: "장소") {
                        RoundedTextField("", text: $vm.location, disabled: true)
                    }
                    
                    makeRow(title: "카테고리") {
                        Menu {
                            Picker(selection: $vm.category) {
                                ForEach(Category.allCases) { category in
                                    Text(category.description)
                                }
                            } label: {}
                        } label: {
                            Text(vm.category.description)
                                .tint(colorScheme == .dark ? .white : .black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.down")
                        }
                        .font(.subheadline)
                        .roundedRectangleStyle()
                    }
                    
                    // TODO: - 몇명까지 모집할 수 있도록 제한해야함. 반례로, 10000명 모집한다고 입력할 수 있기 때문에.
                    makeRow(title: "모집인원") {
                        RoundedTextField("", text: $vm.peopleCount)
                            .keyboardType(.numberPad)
                            .onReceive(Just(vm.peopleCount)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    vm.peopleCount = filtered
                                }
                            }
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
                            .opacity(0.02)
                        }
                        .padding(-8)
                        .roundedRectangleStyle()
                        
                    }
                    
                    // TODO: - DatePicker 8:59일때 돌리면 9:00이 되면 UX가 좋아지긴 함.. 참고로 당근은 대응 안했음
                    // TODO: - 글 작성하다 보면 현재시각 보다는 한 10분정도 뒤로 시작시간을 기본값으로 둔다던가 / 5분 or 30분 이런식으로 분단위를 설정하는방식의 의견이 필요할 듯.
                    // TODO: - 23:00 ~ 다음날 01:00인 경우는 어떻게 해야하는지...? 날짜도 범위로 지정할 수 있어야 하나?
                    makeRow(title: "진행시간") {
                        HStack {
                            ZStack(alignment: .leading) {
                                Text(vm.startTime.toString(by: .HHmm))
                                    .padding(.leading, 4)
                                
                                DatePicker(
                                    "",
                                    selection: $vm.startTime,
                                    in: vm.afterNow(vm.date),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .padding(.horizontal, -20)
                                .labelsHidden()
                                .opacity(0.02)
                            }
                            
                            Text("-")
                            
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
                                    in: vm.afterStartTime(vm.startTime),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .padding(.horizontal, -20)
                                .labelsHidden()
                                .opacity(0.02)
                            }
                        }
                        .padding(-9)
                        .roundedRectangleStyle()
                    }
                    
                    RoundedTextField("제목", text: $vm.title)
                        .padding(.top)
                    
                    RoundedTextField("내용", text: $vm.content, axis: .vertical, lineLimit: 10)
                }
                .padding([.leading, .trailing], 32)
                .padding(.bottom, 10)
            }
            
            // TODO: - 최초 게시 여부에 따라 게시하기 / 수정하기로 분기 필요
            // TODO: - padding 값 설정 필요
            FlatButton("게시하기") {
                vm.submit()
                vm.initialize()
                router.dismiss()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
        
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
