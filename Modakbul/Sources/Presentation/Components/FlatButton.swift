//
//  FlatButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/5/24.
//

import SwiftUI

struct FlatButton: View {
    let label: String
    let action: () -> Void
    
    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .tint(.white)
                .bold()
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                }
        }
    }
}
