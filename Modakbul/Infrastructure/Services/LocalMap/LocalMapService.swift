//
//  LocalMapService.swift
//  Modakbul
//
//  Created by Swain Yun on 7/8/24.
//

import Foundation
import MapKit

protocol LocalMapService: NSObject {
    func search(by keyword: String, on coordinate: Coordinate) async throws -> [Location]
}

final class DefaultLocalMapService: NSObject {
    private var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

// MARK: LocalMapService Conformation
extension DefaultLocalMapService: LocalMapService {
    func search(by keyword: String, on coordinate: Coordinate) async throws -> [Location] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        request.region = MKCoordinateRegion(center: coordinate.toCLCoordinate(), span: span)
        
        let response = try await MKLocalSearch(request: request).start()
        return response.mapItems.map { mapItem in
            Location(mapItem.placemark)
        }
    }
}
