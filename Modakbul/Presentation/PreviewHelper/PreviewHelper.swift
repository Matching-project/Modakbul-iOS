//
//  PreviewHelper.swift
//  Modakbul
//
//  Created by Swain Yun on 7/22/24.
//

import SwiftUI
import CoreLocation

extension PreviewProvider {
    static var previewHelper: PreviewHelper { PreviewHelper.shared }
    static var router: DefaultAppRouter { previewHelper.router }
}

final class PreviewHelper {
    static let shared = PreviewHelper()
    
    let router = DefaultAppRouter(by: InfrastructureAssembly(),
                                 DataAssembly(),
                                 DomainAssembly(),
                                 PresentationAssembly())
    
    var resolver: DependencyResolver { router.resolver }
    
    var places: [Place] = [
        Place(
            id: UUID().uuidString,
            location: Location(
                name: "구로디지털단지",
                address: "서울시 구로구 디지털로 26길 38",
                coordinate: CLLocationCoordinate2D(latitude: 37.4848, longitude: 126.8963)
            ),
            openingHoursOfWeek: [.mon: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .tue: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .wed: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .thu: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .fri: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sat: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sun: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            )],
            powerSocketState: .plenty,
            noiseLevel: .quiet,
            groupSeatingState: .yes,
            communities: [
                CommunityReqruitingContent(
                    id: UUID().uuidString,
                    title: "개발 모각코 하실 분 구합니다!",
                    content: "글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. ",
                    writtenDate: .now,
                    writer: User(
                        name: "SwainYun",
                        nickname: "SwainYun",
                        email: "destap@naver.com",
                        provider: .apple,
                        gender: .male,
                        job: .jobSeeker,
                        categoriesOfInterest: [.coding, .design, .selfImprovement],
                        isGenderVisible: true,
                        birth: .now,
                        imageURL: nil
                    ),
                    community: Community(
                        routine: .daily,
                        category: .coding,
                        participants: [
                            User(
                                name: "SwainYun",
                                nickname: "SwainYun",
                                email: "destap@naver.com",
                                provider: .apple,
                                gender: .male,
                                job: .jobSeeker,
                                categoriesOfInterest: [.coding, .design, .selfImprovement],
                                isGenderVisible: true,
                                birth: .now,
                                imageURL: nil
                            )
                        ],
                        participantsLimit: 5,
                        promiseDate: .init(date: .now, startTime: .now, endTime: .now)
                    )
                ),
            ],
            images: ["image1.png", "image2.png"]
        ),
        Place(
            id: UUID().uuidString,
            location: Location(
                name: "구로시장",
                address: "서울시 구로구 구로동 437-1",
                coordinate: CLLocationCoordinate2D(latitude: 37.4953, longitude: 126.8882)
            ),
            openingHoursOfWeek: [.mon: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .tue: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .wed: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .thu: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .fri: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sat: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sun: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            )],
            powerSocketState: .moderate,
            noiseLevel: .moderate,
            groupSeatingState: .no,
            communities: [],
            images: nil
        ),
        Place(
            id: UUID().uuidString,
            location: Location(
                name: "구로아트밸리",
                address: "서울시 구로구 구로동 814",
                coordinate: CLLocationCoordinate2D(latitude: 37.4958, longitude: 126.8874)
            ),
            openingHoursOfWeek: [.mon: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .tue: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .wed: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .thu: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .fri: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sat: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sun: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            )],
            powerSocketState: .few,
            noiseLevel: .noisy,
            groupSeatingState: .yes,
            communities: [],
            images: nil
        ),
        Place(
            id: UUID().uuidString,
            location: Location(
                name: "가산디지털단지",
                address: "서울시 금천구 가산동 371-28",
                coordinate: CLLocationCoordinate2D(latitude: 37.4812, longitude: 126.8827)
            ),
            openingHoursOfWeek: [.mon: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .tue: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .wed: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .thu: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .fri: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sat: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sun: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            )],
            powerSocketState: .plenty,
            noiseLevel: .quiet,
            groupSeatingState: .no,
            communities: [],
            images: nil
        ),
        Place(
            id: UUID().uuidString,
            location: Location(
                name: "디지털단지 지하상가",
                address: "서울시 구로구 구로동 3-25",
                coordinate: CLLocationCoordinate2D(latitude: 37.4845, longitude: 126.9013)
            ),
            openingHoursOfWeek: [.mon: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .tue: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .wed: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .thu: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .fri: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sat: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sun: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            )],
            powerSocketState: .moderate,
            noiseLevel: .moderate,
            groupSeatingState: .yes,
            communities: [],
            images: nil
        ),
        Place(
            id: UUID().uuidString,
            location: Location(
                name: "구로중앙공원",
                address: "서울시 구로구 구로동 685-101",
                coordinate: CLLocationCoordinate2D(latitude: 37.4956, longitude: 126.8879)
            ),
            openingHoursOfWeek: [.mon: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .tue: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .wed: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .thu: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .fri: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sat: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            ), .sun: Place.OpeningHours(
                open: DateComponents(hour: 9, minute: 0),
                close: DateComponents(hour: 18, minute: 0)
            )],
            powerSocketState: .few,
            noiseLevel: .noisy,
            groupSeatingState: .no,
            communities: [],
            images: []
        ),
    ]
    
    private init() {}
}
