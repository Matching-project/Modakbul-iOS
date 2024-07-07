//
//  ConfirmationContentPresentable.swift
//  Modakbul
//
//  Created by Swain Yun on 7/6/24.
//

import SwiftUI

protocol ConfirmationContentPresentable {
    associatedtype ConfirmationContent: View
    
    @ViewBuilder func confirmationButtons(_ actions: [ConfirmationAction?]) -> ConfirmationContent
}

extension ConfirmationContentPresentable {
    @ViewBuilder func confirmationButtons(_ actions: [ConfirmationAction?]) -> some View {
        let actions = actions.compactMap({$0})
        
        ForEach(actions, id: \.id) { action in
            switch action {
            case .defaultAction(let title, let action):
                Button {
                    action()
                } label: {
                    Text(title)
                }
            case .cancelAction(let title, let action):
                Button(role: .cancel) {
                    action()
                } label: {
                    Text(title)
                }
            case .destructiveAction(let title, let action):
                Button(role: .destructive) {
                    action()
                } label: {
                    Text(title)
                }
            }
        }
    }
}
