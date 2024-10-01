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
        
        // 지역과 주를 결합
        if let locality = placemark.locality {
            cityAndState = locality
        }
        if let administrativeArea = placemark.administrativeArea {
            cityAndState = cityAndState.isEmpty ? administrativeArea : "\(administrativeArea) \(cityAndState)"
        }
        
        // 상세 주소 설정
        if let subThoroughfare = placemark.subThoroughfare {
            address = subThoroughfare
        }
        if let thoroughfare = placemark.thoroughfare {
            address = address.isEmpty ? thoroughfare : "\(thoroughfare) \(address)"
        }
        
        // 주소가 비어있는 경우, 지역과 주를 사용
        if address.trimmingCharacters(in: .whitespaces).isEmpty {
            address = cityAndState
        } else if !cityAndState.isEmpty {
            address = "\(cityAndState) \(address)"
        }
        
        // name을 적절히 설정
        self.init(name: placemark.thoroughfare ?? "Unknown Location", address: address, coordinate: placemark.location?.coordinate ?? CLLocationCoordinate2D())
    }
}
