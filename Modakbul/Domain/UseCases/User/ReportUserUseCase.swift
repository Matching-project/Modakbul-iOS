//
//  ReportUserUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol ReportUserUseCase {
    func report(id reportedId: String, by reporterId: String, type: ReportType) async throws
}
