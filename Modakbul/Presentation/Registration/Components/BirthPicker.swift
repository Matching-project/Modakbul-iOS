//
//  BirthPicker.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

struct BirthPicker: View {
    @Binding var birth: DateComponents
    
    var body: some View {
        HStack {
            contentView(titleKey: "생년",
                        dateType: birth.year,
                        defaultValue: 2000,
                        startRange: 1900,
                        endRange: 2050) {
                birth.year = $0
            }
            
            contentView(titleKey: "월",
                        dateType: birth.month,
                        defaultValue: 1,
                        startRange: 1,
                        endRange: 12) {
                birth.month = $0
            }
            
            contentView(titleKey: "일",
                        dateType: birth.day,
                        defaultValue: 1,
                        startRange: 1,
                        endRange: 31) {
                birth.day = $0
            }
        }
    }
    
    @ViewBuilder
    private func contentView(titleKey: String,
                             dateType: Int?,
                             defaultValue: Int,
                             startRange: Int,
                             endRange: Int,
                             updateValue: @escaping (Int) -> Void) -> some View {
        Picker(titleKey, selection: Binding(
            get: { dateType ?? defaultValue },
            set: { updateValue($0) }
        )) {
            ForEach(startRange...endRange, id: \.self) { number in
                Text(verbatim: "\(number)")
            }
        }.pickerStyle(WheelPickerStyle())
    }
}
