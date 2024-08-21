//
//  Location.swift
//  Modakbul
//
//  Created by Swain Yun on 6/15/24.
//

import Foundation
import CoreLocation

/**
 지도에 표시된 지점입니다.
 
 - Note: `Location`은 지도에 표시된 지점에 대한 단순한 정보입니다. 특별히 식별된 장소는 `Place`로 표현합니다.
 */
struct Location: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(
        id: UUID = UUID(),
        name: String? = nil,
        address: String? = nil,
        coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    ) {
        self.id = id
        self.name = name ?? "Unknown Location"
        self.address = address ?? "주소 없음"
        self.coordinate = coordinate
    }
    
    init(_ placemark: CLPlacemark) {
        var cityAndState = String()
        var address = String()
        
        cityAndState = placemark.locality ?? String()
        if let city = placemark.administrativeArea {
            cityAndState = cityAndState.isEmpty ? city : "\(city) \(cityAndState)"
        }
        
        address = placemark.subThoroughfare ?? String()
        if let street = placemark.thoroughfare {
            address = address.isEmpty ? street : "\(street) \(address)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty, cityAndState.isEmpty == false {
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(cityAndState) \(address)"
        }
        
        self.init(name: placemark.name, address: address, coordinate: placemark.location?.coordinate ?? CLLocationCoordinate2D())
    }
}
