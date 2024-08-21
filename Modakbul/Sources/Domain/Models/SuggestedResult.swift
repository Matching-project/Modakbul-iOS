//
//  SuggestedResult.swift
//  Modakbul
//
//  Created by Swain Yun on 7/11/24.
//

import Foundation
import MapKit

struct SuggestedResult {
    let id: UUID = UUID()
    let title: String
    let subtitle: String
    
    init(_ completion: MKLocalSearchCompletion) {
        self.title = completion.title
        self.subtitle = completion.subtitle
    }
}
