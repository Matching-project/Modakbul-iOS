//
//  NavigationModifier.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/14/24.
//

import SwiftUI

struct NavigationModifier<MenuContent: View>: ViewModifier {
    let title: String?
    let backButtonAction: () -> Void
    let menuButtonAction: () -> MenuContent
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title ?? "")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton(action: backButtonAction)
                }
                
                if type(of: menuButtonAction()) != type(of: EmptyView()) {
                    ToolbarItem(placement: .topBarTrailing) {
                        MenuButton {
                            menuButtonAction()
                        }
                    }
                }
            }
            .navigationPopGestureRecognizerEnabled()
    }
}

extension NavigationModifier {
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
    
    struct MenuButton<Content: View>: View {
        private let content: () -> Content
        
        init(content: @escaping () -> Content) {
            self.content = content
        }
        
        var body: some View {
            Menu {
                content()
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

struct GestureRecognizerEnabled: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        Task { @MainActor in
            controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            controller.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
