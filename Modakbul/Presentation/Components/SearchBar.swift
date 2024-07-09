//
//  SearchBar.swift
//  Modakbul
//
//  Created by Swain Yun on 6/26/24.
//

import SwiftUI

enum HomeViewFocus {
    case searchBar
    case localMap
}

struct SearchBar: View {
    @Binding var searchingText: String
    
    private let placeholder: String
    private let iconName: String
    
    init(
        _ prompt: String,
        text: Binding<String>,
        iconName: String = "magnifyingglass"
    ) {
        self.placeholder = prompt
        self._searchingText = text
        self.iconName = iconName
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundStyle(searchingText.isEmpty ? .secondary : .primary)
                
                textFieldArea
                
                if searchingText.isEmpty == false {
                    removeButton
                }
            }
        }
        .font(.headline)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var textFieldArea: some View {
        TextField(placeholder, text: $searchingText)
    }
    
    private var removeButton: some View {
        Button {
            searchingText.removeAll()
        } label: {
            Text("취소")
        }
    }
}
