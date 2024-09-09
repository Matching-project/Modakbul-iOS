//
//  MyViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation

final class MyViewModel: ObservableObject {
    @Published var user: User
    //    private let userBusinessUseCase: UserBusinessUseCase
    
    init(user: User = PreviewHelper.shared.users.first ?? User()) {
        self.user = user
        //        self.userBusinessUseCase = userBusinessUseCase
    }
}
