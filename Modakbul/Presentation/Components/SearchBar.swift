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
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
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
        TextField("카페 이름으로 찾기", text: $searchingText)
    }
    
    private var removeButton: some View {
        Button {
            searchingText.removeAll()
        } label: {
            Text("취소")
        }
    }
}
