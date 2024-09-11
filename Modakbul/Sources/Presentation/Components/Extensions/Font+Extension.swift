//
//  Font+Extension.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/11/24.
//

import SwiftUI

extension Font {
    // https://developer.apple.com/design/human-interface-guidelines/typography#iOS-iPadOS-Dynamic-Type-sizes
    /*
     Style           Font                Size
     ----------------------------------------
     .largeTitle     SFUI-Regular        34.0
     .title1         SFUI-Regular        28.0
     .title2         SFUI-Regular        22.0
     .title3         SFUI-Regular        20.0
     .headline       SFUI-Semibold       17.0
     
     .body           SFUI-Regular        17.0
     .callout        SFUI-Regular        16.0
     .subheadline    SFUI-Regular        15.0
     .footnote       SFUI-Regular        13.0
     .caption1       SFUI-Regular        12.0
     
     .caption2       SFUI-Regular        11.0
     */
    
    struct Modakbul {
        static let largeTitle = custom(Constants.Font.modakbulRegular, size: 34)
        static let title = custom(Constants.Font.modakbulRegular, size: 28)
        static let title2 = custom(Constants.Font.modakbulRegular, size: 22)
        static let title3 = custom(Constants.Font.modakbulRegular, size: 20)
        static let headline = custom(Constants.Font.modakbulBold, size: 17)
        
        static let body = custom(Constants.Font.modakbulRegular, size: 17)
        /// - Text()에 사용되는 기본 폰트입니다.
        /// - default Text() size: font(. system(size: 16))
        static let callout = custom(Constants.Font.modakbulRegular, size: 16)
        static let subheadline = custom(Constants.Font.modakbulRegular, size: 15)
        static let footnote = custom(Constants.Font.modakbulRegular, size: 13)
        static let caption = custom(Constants.Font.modakbulRegular, size: 12)
        
        static let caption2 = custom(Constants.Font.modakbulRegular, size: 11)
    }
}
