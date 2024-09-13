//
//  SearchBar.swift
//  Modakbul
//
//  Created by Swain Yun on 6/26/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchingText: String
    
    private var isFocused: FocusState<Bool>.Binding
    private let placeholder: String
    private let iconName: String
    
    init(
        _ prompt: String,
        text: Binding<String>,
        _ isFocused: FocusState<Bool>.Binding,
        iconName: String = "magnifyingglass"
    ) {
        self.placeholder = prompt
        self._searchingText = text
        self.isFocused = isFocused
        self.iconName = iconName
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                textFieldArea
                
                if searchingText.isEmpty == false {
                    removeButton
                } else {
                    icon
                }
            }
        }
        .font(.Modakbul.headline)
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: .secondary, radius: 4, y: 4)
    }
    
    private var textFieldArea: some View {
        TextField(placeholder, text: $searchingText)
            .automaticFunctionDisabled()
            .padding(.horizontal, 4)
            .focused(isFocused)
    }
    
    private var icon: some View {
        Image(systemName: iconName)
            .foregroundStyle(.secondary)
    }
    
    private var removeButton: some View {
        Button {
            searchingText.removeAll()
            isFocused.wrappedValue = false
        } label: {
            Text("취소")
        }
    }
}
