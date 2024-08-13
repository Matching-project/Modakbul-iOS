//
//  PlaceInformationView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlaceInformationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @State private var selectedDayOfWeek: DayOfWeek
    
    private let place: Place
    
    init(place: Place) {
        self.place = place
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: .now)
        switch weekDay {
        case 1: self.selectedDayOfWeek = .sun
        case 2: self.selectedDayOfWeek = .mon
        case 3: self.selectedDayOfWeek = .tue
        case 4: self.selectedDayOfWeek = .wed
        case 5: self.selectedDayOfWeek = .thu
        case 6: self.selectedDayOfWeek = .fri
        default: self.selectedDayOfWeek = .sat
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    AsyncDynamicSizingImageView(imageData: Data(), width: proxy.size.width / 3, height: proxy.size.width / 3)
                    
                    Spacer()
                    
                    informationArea
                }
                .padding(.top)
                .overlay(alignment: .topTrailing) {
                    communityRecruitingContentEditButton
                }
                
                communityRecruitingContentListArea
            }
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
                    Picker(selection: $selectedDayOfWeek) {
                        ForEach(DayOfWeek.allCases) { dayOfWeek in
                            Text(displayOpeningHours(dayOfWeek))
                        }
                    } label: {}
                } label: {
                    Text(displayOpeningHours(selectedDayOfWeek))
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
                ForEach(place.communities, id: \.id) { communityRecruitingContent in
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
    
    private func displayOpeningHours(_ dayOfWeek: DayOfWeek) -> String {
        let day = dayOfWeek.description
        guard let openingHours = place.openingHoursOfWeek[dayOfWeek] else {
            return day + " " + "정보 없음"
        }
        return day + " " + openingHours.open + " - " + openingHours.close
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
                        Text("\(community.promiseDate.startTime.toString(by: .HHmm))~\(community.promiseDate.startTime.toString(by: .HHmm))")
                    }
                    
                    Text(community.category.identifier)
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
