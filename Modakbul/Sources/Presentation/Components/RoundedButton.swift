//
//  RoundedButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/28/24.
//

import SwiftUI

struct RoundedButton<Label: View>: View {
    private let action: () -> Void
    private let label: () -> Label
    
    init(action: @escaping () -> Void, label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            label()
                .padding(17)
                .tint(.white)
                .background(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8)
                }
        }
    }
}
