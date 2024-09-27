//
//  NetworkContentUnavailableView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/27/24.
//

import SwiftUI

struct NetworkContentUnavailableView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ContentUnavailableView("인터넷 연결 안 됨",
                               systemImage: "wifi.slash",
                               description: Text("인터넷 연결 상태를 확인해주세요.\n지속적으로 문제가 발생한다면 관리자에게 문의해주세요."))
    }
}
