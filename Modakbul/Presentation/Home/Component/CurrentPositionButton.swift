//
//  CurrentPositionButton.swift
//  Modakbul
//
//  Created by Swain Yun on 6/18/24.
//

import SwiftUI

struct CurrentPositionButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "location.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .padding(.bottom)
                .shadow(radius: 10)
        }
    }
}
