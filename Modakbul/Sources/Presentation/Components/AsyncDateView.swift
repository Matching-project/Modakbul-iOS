//
//  AsyncDateView.swift
//  Modakbul
//
//  Created by Swain Yun on 12/22/24.
//

import SwiftUI

struct AsyncDateView: View {
    @State private var time: String = String()
    
    let date: Date
    let format: DateFormat
    let font: Font?
    
    init(
        date: Date,
        format: DateFormat,
        font: Font? = nil
    ) {
        self.date = date
        self.format = format
        self.font = font
    }
    
    var body: some View {
        Text(time)
            .font(font)
            .task {
                time = await date.toString(by: format)
            }
    }
}
