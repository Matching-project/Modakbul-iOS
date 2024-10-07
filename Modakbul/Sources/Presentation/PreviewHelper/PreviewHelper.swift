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
    static var router: DefaultAppRouter { PreviewHelper.router }
}

final class PreviewHelper: ObservableObject {
    static let shared = PreviewHelper()
    
    static let router = DefaultAppRouter(by: InfrastructureAssembly(),
                                         DataAssembly(),
                                         DomainAssembly(),
                                         PresentationAssembly())
    
    var resolver: DependencyResolver { Self.router.resolver }
    
    let places: [Place] = [
        Place(
            id: 0,
            location: Location(
                name: "스타벅스 구로오류DT점",
                address: "서울특별시 구로구 서해안로 2233",
                coordinate: CLLocationCoordinate2D(latitude: 37.488176, longitude: 126.834651)
            ),
            openingHours: [
                OpeningHour(dayOfWeek: .mon, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .tue, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .wed, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .thr, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .fri, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sat, open: "10:00", close: "15:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sun, open: "10:00", close: "15:00", openingState: .closed)
            ],
            imageURLs: []
        ),
        Place(
            id: 1,
            location: Location(
                name: "구로디지털단지",
                address: "서울시 구로구 디지털로 26길 38",
                coordinate: CLLocationCoordinate2D(latitude: 37.4848, longitude: 126.8963)
            ),
            openingHours: [
                OpeningHour(dayOfWeek: .mon, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .tue, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .wed, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .thr, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .fri, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sat, open: "10:00", close: "15:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sun, open: "10:00", close: "15:00", openingState: .closed)
            ],
            powerSocketState: .plenty,
            noiseLevel: .quiet,
            groupSeatingState: .yes,
            imageURLs: []
        ),
        Place(
            id: 2,
            location: Location(
                name: "구로시장",
                address: "서울시 구로구 구로동 437-1",
                coordinate: CLLocationCoordinate2D(latitude: 37.4953, longitude: 126.8882)
            ),
            openingHours: [
                OpeningHour(dayOfWeek: .mon, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .tue, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .wed, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .thr, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .fri, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sat, open: "10:00", close: "15:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sun, open: "10:00", close: "15:00", openingState: .closed)
            ],
            powerSocketState: .moderate,
            noiseLevel: .moderate,
            groupSeatingState: .no,
            imageURLs: []
        ),
        Place(
            id: 3,
            location: Location(
                name: "구로아트밸리",
                address: "서울시 구로구 구로동 814",
                coordinate: CLLocationCoordinate2D(latitude: 37.4958, longitude: 126.8874)
            ),
            openingHours: [
                OpeningHour(dayOfWeek: .mon, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .tue, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .wed, open: "09:00", close: "18:00", openingState: .closed),
                OpeningHour(dayOfWeek: .thr, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .fri, open: "09:00", close: "18:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sat, open: "10:00", close: "15:00", openingState: .opened),
                OpeningHour(dayOfWeek: .sun, open: "10:00", close: "15:00", openingState: .closed)
            ],
            powerSocketState: .few,
            noiseLevel: .noisy,
            groupSeatingState: .yes,
            imageURLs: []
        ),
        Place(
            id: Int64.random(in: 0..<100),
            location: Location(
                name: "가산디지털단지",
                address: "서울시 금천구 가산동 371-28",
                coordinate: CLLocationCoordinate2D(latitude: 37.4812, longitude: 126.8827)
            ),
            powerSocketState: .plenty,
            noiseLevel: .quiet,
            groupSeatingState: .no,
            imageURLs: []
        ),
        Place(
            id: Int64.random(in: 0..<100),
            location: Location(
                name: "디지털단지 지하상가",
                address: "서울시 구로구 구로동 3-25",
                coordinate: CLLocationCoordinate2D(latitude: 37.4845, longitude: 126.9013)
            ),
            powerSocketState: .moderate,
            noiseLevel: .moderate,
            groupSeatingState: .yes,
            imageURLs: []
        ),
        Place(
            id: Int64.random(in: 0..<100),
            location: Location(
                name: "구로중앙공원",
                address: "서울시 구로구 구로동 685-101",
                coordinate: CLLocationCoordinate2D(latitude: 37.4956, longitude: 126.8879)
            ),
            powerSocketState: .few,
            noiseLevel: .noisy,
            groupSeatingState: .no,
            imageURLs: []
        ),
    ]
    
    let users: [User] = [
        User(id: 1, name: "팀쿡", nickname: "빌게이츠", gender: .female, job: .officeWorker, categoriesOfInterest: [.coding, .design], isGenderVisible: true, birth: DateComponents(year: 2000, month: 1, day: 1).toDate(), imageURL: URL(string: "https://res.heraldm.com/content/image/2023/12/24/20231224000165_0.jpg")!),
        User(id: 2, name: "이재용", nickname: "삼성", gender: .male, job: .jobSeeker, categoriesOfInterest: [.coding, .design], isGenderVisible: false, birth: DateComponents(year: 1990, month: 1, day: 1).toDate(), imageURL: URL(string: "https://image.ajunews.com/content/image/2022/07/06/20220706160753669738.jpg")!),
        User(id: 3, name: "조성규", nickname: "yagom", gender: .male, job: .collegeStudent, categoriesOfInterest: [.coding, .interview, .selfImprovement], isGenderVisible: false, birth: DateComponents(year: 1980, month: 1, day: 1).toDate(), imageURL: URL(string: "https://developer.apple.com/documentation/swiftui/asyncimagephase"))
    ]
    
    let messages: [ChatMessage] = [
        ChatMessage(chatRoomId: 0, senderId: 0, senderNickname: "디자인 천재", content: "안녕하세요!", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: 0, senderNickname: "디자인 천재", content: "안녕하세요!", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: 0, senderNickname: "디자인 천재", content: "안녕하세요!", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: -1, senderNickname: "", content: "", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "안녕하사시부리", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 2),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "안녕", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 2),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "안녕하다고", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 2),
        ChatMessage(chatRoomId: 0, senderId: -0, senderNickname: "디자인 천재", content: "삼성\n엘지\n테슬라", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 1),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "테스트\n테스트\n테스트\n테스트라이크~", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 1),
        ChatMessage(chatRoomId: 0, senderId: -0, senderNickname: "디자인 천재", content: "이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 13))!, readCount: 1),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 13))!, readCount: 1),
    ]
    
    let communityRecruitingContents = [
        CommunityRecruitingContent(
            id: Int64.random(in: 0..<100),
            placeImageURLs: [
                URL(string: "https://picsum.photos/200/300"),
                URL(string: "https://picsum.photos/200/300"),
                URL(string: "https://picsum.photos/200/300"),
                URL(string: "https://picsum.photos/200/300"),
            ],
            title: "개발 모각코 하실 분 구합니다!",
            content: "글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다.",
            writtenDate: "1998-07-23",
            writer: User(
                id: 1,
                name: "SwainYun",
                nickname: "SwainYun",
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
                        id: 1,
                        name: "SwainYun",
                        nickname: "SwainYun",
                        gender: .male,
                        job: .jobSeeker,
                        categoriesOfInterest: [.coding, .design, .selfImprovement],
                        isGenderVisible: true,
                        birth: .now,
                        imageURL: nil
                    )
                ],
                participantsLimit: 4,
                meetingDate: "1998-07-23",
                startTime: "09:00",
                endTime: "18:00"
            )
        ),
        
        CommunityRecruitingContent(
            id: Int64.random(in: 0..<100),
            title: "개발 모각코 하실 분 구합니다!",
            content: "글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다.",
            writtenDate: "1998-07-23",
            writer: User(
                id: 1,
                name: "SwainYun",
                nickname: "SwainYun",
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
                        id: 1,
                        name: "SwainYun",
                        nickname: "SwainYun",
                        gender: .male,
                        job: .jobSeeker,
                        categoriesOfInterest: [.coding, .design, .selfImprovement],
                        isGenderVisible: true,
                        birth: .now,
                        imageURL: nil
                    )
                ],
                participantsLimit: 4,
                meetingDate: "1998-07-23",
                startTime: "09:00",
                endTime: "18:00"
            )
        ),
        
        CommunityRecruitingContent(
            id: Int64.random(in: 0..<100),
            title: "개발 모각코 하실 분 구합니다!",
            content: "글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다.",
            writtenDate: "1998-07-23",
            writer: User(
                id: 1,
                name: "SwainYun",
                nickname: "SwainYun",
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
                        id: 1,
                        name: "SwainYun",
                        nickname: "SwainYun",
                        gender: .male,
                        job: .jobSeeker,
                        categoriesOfInterest: [.coding, .design, .selfImprovement],
                        isGenderVisible: true,
                        birth: .now,
                        imageURL: nil
                    )
                ],
                participantsLimit: 4,
                meetingDate: "1998-07-23",
                startTime: "09:00",
                endTime: "18:00"
            )
        ),
        
        CommunityRecruitingContent(
            id: Int64.random(in: 0..<100),
            title: "개발 모각코 하실 분 구합니다!",
            content: "글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다.",
            writtenDate: "1998-07-23",
            writer: User(
                id: 1,
                name: "SwainYun",
                nickname: "SwainYun",
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
                        id: 1,
                        name: "SwainYun",
                        nickname: "SwainYun",
                        gender: .male,
                        job: .jobSeeker,
                        categoriesOfInterest: [.coding, .design, .selfImprovement],
                        isGenderVisible: true,
                        birth: .now,
                        imageURL: nil
                    )
                ],
                participantsLimit: 4,
                meetingDate: "1998-07-23",
                startTime: "09:00",
                endTime: "18:00"
            )
        ),
        
        CommunityRecruitingContent(
            id: Int64.random(in: 0..<100),
            title: "개발 모각코 하실 분 구합니다!",
            content: "글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다. 글의 내용입니다.",
            writtenDate: "1998-07-23",
            writer: User(
                id: 1,
                name: "SwainYun",
                nickname: "SwainYun",
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
                        id: 1,
                        name: "SwainYun",
                        nickname: "SwainYun",
                        gender: .male,
                        job: .jobSeeker,
                        categoriesOfInterest: [.coding, .design, .selfImprovement],
                        isGenderVisible: true,
                        birth: .now,
                        imageURL: nil
                    )
                ],
                participantsLimit: 4,
                meetingDate: "1998-07-23",
                startTime: "09:00",
                endTime: "18:00"
            )
        ),
    ]
    
    static let url1 = URL(string: "https://res.heraldm.com/content/image/2023/12/24/20231224000165_0.jpg")!
    static let url2 = URL(string: "https://image.ajunews.com/content/image/2022/07/06/20220706160753669738.jpg")!
    static let url3 = URL(string: "https://menu.moneys.co.kr/moneyweek/thumb/2024/04/19/06/2024041916030557751_1.jpg/dims/optimize/")!
    static let url4 = URL(string: "https://developer.apple.com/documentation/swiftui/asyncimagephase")
    
    @Published var notifications: [PushNotification] = [
//        PushNotification(imageURL: url1, title: "디자인초보", subtitle: "UI/UX디자인", timestamp: "1초전", type: .request),
//        PushNotification(imageURL: url2, title: "또봐요", subtitle: "면접합격꿀팁", timestamp: "10분전", type: .exit),
//        PushNotification(imageURL: url3, title: "개발좋아", subtitle: "웹개발", timestamp: "12분전", type: .accept),
//        PushNotification(imageURL: url4, title: "열공생", subtitle: "열공생", timestamp: "13분전", type: .newChat),
//        PushNotification(imageURL: url1, title: "디자인초보", subtitle: "UI/UX디자인", timestamp: "1초전", type: .request),
//        PushNotification(imageURL: url2, title: "또봐요", subtitle: "면접합격꿀팁", timestamp: "10분전", type: .exit),
//        PushNotification(imageURL: url3, title: "개발좋아", subtitle: "웹개발", timestamp: "12분전", type: .accept),
//        PushNotification(imageURL: url4, title: "열공생", subtitle: "열공생", timestamp: "13분전", type: .newChat),
//        PushNotification(imageURL: url1, title: "디자인초보", subtitle: "UI/UX디자인", timestamp: "1초전", type: .request),
//        PushNotification(imageURL: url2, title: "또봐요", subtitle: "면접합격꿀팁", timestamp: "10분전", type: .exit),
//        PushNotification(imageURL: url3, title: "개발좋아", subtitle: "웹개발", timestamp: "12분전", type: .accept),
//        PushNotification(imageURL: url4, title: "열공생", subtitle: "열공생", timestamp: "13분전", type: .newChat),
    ]
    
    private init() {}
}

