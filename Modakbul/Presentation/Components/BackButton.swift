//
//  BackButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/14/24.
//

import SwiftUI

/// NavigationBackButton의 label을 제거할 때 사용합니다.
struct BackButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
        
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
        }
    }
}
