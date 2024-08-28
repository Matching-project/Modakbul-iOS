//
//  RegistrationViewValue.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/1/24.
//

import Foundation

struct RegistrationViewValue {
    private static let defaultCornerRadius: CGFloat = 8
    private static let defaultPadding: CGFloat = 20
    // padding() default: 16
    
    // MARK: Registration
    static let xAxisPadding: CGFloat = defaultPadding
    static let yAxisPadding: CGFloat = defaultPadding
    
    // MARK: Header
    struct Header {
        static let vStackSpacing: CGFloat = 10
        static let topPadding: CGFloat = 50
        static let bottomPadding: CGFloat = 30
    }
    
    // MARK: Content
    struct RoundedTextField {
        static let cornerRadius: CGFloat = defaultCornerRadius
    }
    
    struct NicknameCheckButton {
        static let padding: CGFloat = 17
        static let cornerRadius: CGFloat = defaultCornerRadius
    }
    
    struct GenderSelectionButton {
        static let padding: CGFloat = 10
    }
    
    struct DefaultSelectionButton {
        static let widthFrame: CGFloat = 110
        static let heightFrame: CGFloat = 50
        static let cornerRadius: CGFloat = 20       // maximum: 25
        static let cornerRadiusMaximum: CGFloat = 25
        static let opacity: CGFloat = 0.3
        static let shadowRadius: CGFloat = 4
        static let shadowXAxisPosition: CGFloat = 0.0
        static let shadowYAxisPosition: CGFloat = 10.0
    }
    
    
    // MARK: Next Button
    struct Footer {
        static let xAxisPadding: CGFloat = defaultPadding
        static let topPadding: CGFloat = 50
        static let bottomPadding: CGFloat = 30
        static let cornerRadius: CGFloat = defaultCornerRadius
    }
}
