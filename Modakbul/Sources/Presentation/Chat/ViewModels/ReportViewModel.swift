//
//  ReportViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation

final class ReportViewModel: ObservableObject {
    @Published var reportType: ReportType? = nil
    @Published var description: String = ""
    
    func initialize() {
        reportType = nil
        description = ""
    }
    
    func submit() {
        if reportType != .other {
            description = ""
        }
        
        // TODO: - UseCase 연결 필요
        //        Report(type: reportType, from: <#T##User#>, to: <#T##User#>, description: description)
    }
}
