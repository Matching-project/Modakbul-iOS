//
//  MyView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/25/24.
//

import SwiftUI

struct MyView: View {
    @State private var models: [Int] = [Int](0...100)
    
    var body: some View {
        List(models, id: \.self) { num in
            Text("\(num)")
        }
    }
}

#Preview {
    MyView()
}
