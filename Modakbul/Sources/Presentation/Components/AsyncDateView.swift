//
//  AsyncDateView.swift
//  Modakbul
//
//  Created by Swain Yun on 12/22/24.
//

import SwiftUI

struct AsyncDateView: View {
    @State private var time: String = String()
    @Binding var date: Date
    
    let format: DateFormat
    let font: Font?
    
    init(
        date: Binding<Date>,
        format: DateFormat,
        font: Font? = nil
    ) {
        self._date = date
        self.format = format
        self.font = font
    }
    
    init(
        date: Date,
        format: DateFormat,
        font: Font? = nil
    ) {
        self.init(date: .constant(date), format: format, font: font)
    }
    
    var body: some View {
        Text(time)
            .font(font)
            .onChange(of: date) { _, newValue in
                Task { @MainActor in
                    time = await newValue.toString(by: format)
                }
            }
            .task {
                time = await date.toString(by: format)
            }
    }
}
