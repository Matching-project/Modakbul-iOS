//
//  PlaceInformationHeader.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import SwiftUI

struct PlaceInformationHeader: View {
    @State private var selectedDayOfWeek: DayOfWeek
    
    private let place: Place
    
    init(_ place: Place) {
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
        HStack {
            imageArea
            
            Spacer()
            
            informationArea
        }
    }
    
    private var imageArea: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .background(.gray)
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
                CapsuleTag(place.noiseLevel.description)
                CapsuleTag(place.groupSeatingState.description)
            }
            .font(.caption)
        }
    }
    
    private func displayOpeningHours(_ dayOfWeek: DayOfWeek) -> String {
        let day = dayOfWeek.description
        guard let openingHours = place.openingHoursOfWeek[dayOfWeek] else {
            return day + " " + "정보 없음"
        }
        return day + " " + openingHours.open + " - " + openingHours.close
    }
}
