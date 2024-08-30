//
//  DefaultSelectionButtonModifier.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/27/24.
//

import SwiftUI

struct DefaultSelectionButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 110,
                   height: 50,
                   alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.accent, lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .shadow(color: .gray,
                                radius: 4,
                                x: 0.0,
                                y: 10.0)
                    )
            }
    }
}
