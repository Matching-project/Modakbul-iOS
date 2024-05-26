//
//  SearchBar.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI

struct SearchBar: View {
    @FocusState private var isFocused: Bool
    @Binding var textFieldText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(textFieldText.isEmpty ? .secondary : .primary)
            
            TextField("지하철, 카페 이름으로 검색", text: $textFieldText)
                .focused($isFocused)
            
            if textFieldText.isEmpty == false {
                cancelButton
            }
        }
        .font(.headline)
        .padding()
        .clipShape(.buttonBorder)
    }
    
    private var cancelButton: some View {
        Button {
            textFieldText.removeAll()
            hideKeyboard()
        } label: {
            Image(systemName: "xmark.circle")
                .foregroundStyle(.gray)
        }
    }
    
    private func hideKeyboard() {
        withAnimation(.easeInOut) { isFocused = false }
    }
}

#Preview {
    SearchBar(textFieldText: .constant(""))
}
