//
//  NotificationIcon.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/6/24.
//

import SwiftUI

struct NotificationIcon: View {
    let badge: Bool
    
    var body: some View {
        if badge {
            Image(systemName: "bell")
                .font(.headline)
                .foregroundStyle(.accent)
                .padding(5)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(width: 5, height: 5)
                }
        } else {
            Image(systemName: "bell")
                .font(.headline)
                .foregroundStyle(.accent)
        }
    }
}
