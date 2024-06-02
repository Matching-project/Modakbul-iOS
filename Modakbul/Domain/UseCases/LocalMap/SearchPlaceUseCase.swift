//
//  SearchPlaceUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 5/29/24.
//

import Foundation

protocol SearchPlaceUseCase {
    func searchPlace(by name: String) async throws -> Place
}
