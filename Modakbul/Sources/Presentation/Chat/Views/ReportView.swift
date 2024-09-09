//
//  ReportView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/14/24.
//

import SwiftUI

struct ReportView<Router: AppRouter>: View {
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: ReportViewModel
    @Binding private var isReported: Bool
    
    init(_ vm: ReportViewModel, isReported: Binding<Bool>) {
        self.vm = vm
        self._isReported = isReported
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    Spacer()
                    
                    ForEach(ReportType.allCases, id: \.self) { reportType in
                        HStack {
                            Image(systemName: vm.reportType == reportType ? "circle.inset.filled" : "circle")
                            Text(reportType.description)
                        }
                        .foregroundStyle(vm.reportType == reportType ? .accent : (colorScheme == .dark ? .white : .black))
                        .onTapGesture {
                            vm.reportType = reportType
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RoundedTextField(
                        text: $vm.description,
                        axis: .vertical,
                        lineLimit: (1, 10),      // TODO: - 기종별 대응 필요
                        disabled: vm.reportType == .other ? false : true,
                        color: vm.reportType == .other ? .accent : (colorScheme == .dark ? .white : .black)
                    )
                    .focused($isFocused)
                    .padding(.leading, 27)
                    .padding(.trailing, 1)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = false
            }
            .navigationModifier(title: "신고하기") {
                vm.initialize()
                router.dismiss()
            }
            
            FlatButton("신고완료") {
                router.alert(for: .reportUserConfirmation, actions: [
                    .defaultAction("확인") {
                        isReported = true
                        vm.submit()
                        vm.initialize()
                        router.dismiss()
                    }
                ])
            }
            .disabled(vm.reportType == nil ? true : false)
            .padding(.vertical, 5)
        }
        .padding(.horizontal, Constants.horizontal)
    }
}

struct ReportView_Preview: PreviewProvider {
    @State private static var isReported: Bool = false

    static var previews: some View {
        NavigationStack {
            router.view(to: .reportView(result: $isReported))
        }
    }
}
