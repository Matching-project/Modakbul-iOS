//
//  ReportView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/14/24.
//

import SwiftUI

// https://www.notion.so/8cdee4c8f8d549808e28381a025d6637?pvs=4
// - 신고 사유를 여러 개 선택할 수 있나요? → 1가지.
struct ReportView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: ReportViewModel
    
    init(_ vm: ReportViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        Text("fuck")
    }
}

struct ReportView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .reportView)
                .navigationBarBackButtonHidden()
                .navigationBarItems(leading: BackButton {
                    
                })
                // TODO: - 최초 게시 여부에 따라 모집글 작성 / 모집글 수정으로 분기 필요
                .navigationTitle("-----------------")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

final class ReportViewModel: ObservableObject {
    
}
