//
//  PlaceInformationView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlaceInformationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    @State private var selectedOpeningHourByDay: OpeningHour?
    @State private var communityRecruitingContents: [CommunityRecruitingContent] = []
    
    private let place: Place
    
    init(
        place: Place
    ) {
        self.place = place
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: .now)
        let dayOfWeek = DayOfWeek(weekDay)
        self.selectedOpeningHourByDay = place.openingHours.first(where: {$0.dayOfWeek == dayOfWeek})
    }
    
    var body: some View {
        VStack {
            HStack {
                AsyncImageView(imageData: Data())
                    .background(.gray)
                
                Spacer()
                
                informationArea
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                communityRecruitingContentEditButton
            }
            
            if communityRecruitingContents.isEmpty {
                // TODO: 모임 개수 표시 영역
            } else {
                communityRecruitingContentListArea
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var informationArea: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.location.name)
                    .font(.title2.bold())
                
                Text(place.location.address)
                    .font(.subheadline)
            }
            
            HStack {
                Text("운영시간: ")
                    .font(.subheadline)
                
                Menu {
                    Picker(selection: $selectedOpeningHourByDay) {
                        ForEach(place.openingHours, id: \.dayOfWeek) { openingHour in
                            displayOpeningHours(openingHour)
                        }
                    } label: {}
                } label: {
                    displayOpeningHours(selectedOpeningHourByDay)
                    Image(systemName: "chevron.down")
                }
                .font(.subheadline)
            }
            
            HStack {
                CapsuleTag(place.powerSocketState.description)
                CapsuleTag(place.groupSeatingState.description)
            }
            .font(.caption)
        }
    }
    
    private var communityRecruitingContentEditButton: some View {
        Button {
            router.route(to: .placeInformationDetailMakingView)
        } label: {
            // TODO: 이미지 제공 받아야함
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
        .padding(.trailing)
        .shadow(color: .secondary, radius: 4, y: 4)
        .alignmentGuide(.top) { dimension in
            dimension.height / 2 - 30
        }
        .alignmentGuide(.trailing) { dimension in
            dimension.width / 2 + 14
        }
    }
    
    private var communityRecruitingContentListArea: some View {
        ScrollView {
            LazyVStack {
                ForEach(communityRecruitingContents, id: \.id) { communityRecruitingContent in
                    Cell(communityRecruitingContent)
                        .onTapGesture {
                            router.dismiss()
                            router.route(to: .placeInformationDetailView(communityRecruitingContentId: communityRecruitingContent.id))
                        }
                }
            }
        }
        .padding(.top)
    }
    
    private func displayOpeningHours(_ openingHour: OpeningHour?) -> Text {
        guard let openingHour = openingHour else { return Text("정보 없음") }
        let dayOfWeek = openingHour.dayOfWeek.description
        let open = openingHour.open
        let close = openingHour.close
        
        return Text("\(dayOfWeek) \(open) - \(close)")
    }
}

extension PlaceInformationView {
    struct Cell: View {
        private let communityRecruitingContent: CommunityRecruitingContent
        
        private var community: Community {
            self.communityRecruitingContent.community
        }
        
        init(_ communityRecruitingContent: CommunityRecruitingContent) {
            self.communityRecruitingContent = communityRecruitingContent
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(communityRecruitingContent.title)
                    .font(.headline)
                
                HStack {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("\(community.participants.count)/\(community.participantsLimit)")
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("\(community.startTime)~\(community.endTime)")
                    }
                    
                    Text(community.category.description)
                }
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(.accent)
            )
        }
    }
}

struct PlaceInformationSheet_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .placeInformationView(place: previewHelper.places.first!))
    }
}