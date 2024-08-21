//
//  Badge.swift
//  Modakbul
//
//  Created by Swain Yun on 8/14/24.
//

import SwiftUI

struct Badge: View {
    @ScaledMetric(relativeTo: .subheadline) private var padding = 4
    
    private let count: Int
    
    init(count: Int) {
        self.count = count
    }
    
    var body: some View {
        Text("\(count)")
            .font(.subheadline)
            .padding(.horizontal, padding)
            .foregroundStyle(.white)
            .background {
                if count > 0 {
                    Capsule()
                        .fill(Color.accentColor.gradient)
                }
            }
    }
}
