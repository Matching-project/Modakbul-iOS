//
//  HomeView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/21/24.
//

import SwiftUI

struct HomeView: View {
    @State private var textFieldText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(textFieldText: $textFieldText)
                .padding()
            
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
