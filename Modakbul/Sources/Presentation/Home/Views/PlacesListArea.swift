//
//  PlacesListArea.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlacesListArea<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: HomeViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    @FocusState private var isFocused: Bool
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                searchBarArea
                
                ZStack {
                    listArea
                    
                    if viewModel.searchedPlaces.isEmpty == false {
                        ScrollView(.vertical) {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.searchedPlaces, id: \.id) { place in
                                    VStack(alignment: .leading) {
                                        Text(place.location.name)
                                        Text(place.location.address)
                                    }
                                    .padding()
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        withAnimation(.bouncy) {
                                            isFocused = false
                                            viewModel.selectPlace(place)
                                        }
                                    }
                                }
                            }
                        }
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                }
            }
            
            hoveringButtonsArea
        }
        .task {
            await viewModel.fetchUnreadNotificationCount(userId: userId)
        }
    }
    
    private var listArea: some View {
        List(viewModel.places, id: \.id) { place in
            Cell(place)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    private var searchBarArea: some View {
        HStack {
            SearchBar("카페 이름으로 검색", text: $viewModel.searchingText, $isFocused)
            
            Button {
                if userId == Constants.loggedOutUserId {
                    router.route(to: .loginView)
                } else {
                    router.route(to: .notificationView(userId: Int64(userId)))
                }
            } label: {
                if viewModel.unreadCount > 0 {
                    NotificationIcon(badge: true)
                        .padding(5)
                } else {
                    NotificationIcon(badge: false)
                        .padding(10)
                }
            }
        }
    }
    
    private var hoveringButtonsArea: some View {
        VStack {
            Spacer()
            
            HStack {
                StrokedButton(.circle) {
                    Image(systemName: "map")
                        .padding(.horizontal, 4)
                } action: {
                    viewModel.isMapShowing.toggle()
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

extension PlacesListArea {
    struct Cell: View {
        @EnvironmentObject private var router: Router
        @Environment(\.colorScheme) private var colorScheme
        @State private var selectedOpeningHourOfDay: OpeningHour? {
            didSet { displaySelectedOpeningHourText() }
        }
        @State private var openingHourText: String = String()
        
        private let place: Place
        
        init(_ place: Place) {
            self.place = place
        }
        
        var body: some View {
            VStack {
                HStack {
                    if let url = place.imageURLs.first {
                        AsyncImageView(url: url, minWidth: 100, minHeight: 100)
                    } else {
                        Image(colorScheme == .light ? .modakbulMainLight : .modakbulMainDark)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 100, height: 100)
                    }
                    
                    informationArea
                    
                    Spacer()
                }
                .overlay(alignment: .topTrailing) {
                    communityRecruitingContentEditButton
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Image(.marker)
                    
                    Text("모임 \(place.meetingCount)개 진행 중")
                }
                
                Spacer()
            }
        }
        
        private var informationArea: some View {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.location.name)
                        .font(.Modakbul.title3)
                        .bold()
                    
                    Text(place.location.address)
                        .font(.Modakbul.caption)
                }
                .padding(.top)
                
                HStack {
                    Text("운영시간 ")
                    
                    Menu {
                        ForEach(place.openingHours, id: \.dayOfWeek) { openingHour in
                            Button {
                                selectedOpeningHourOfDay = openingHour
                            } label: {
                                Text(displayOpeningHours(openingHour))
                            }
                        }
                    } label: {
                        Text(openingHourText)
                        Image(systemName: "chevron.down")
                    }
                }
                
                HStack {
                    CapsuleTag(place.powerSocketState.description, .Modakbul.caption)
                    CapsuleTag(place.groupSeatingState.description, .Modakbul.caption)
                }
            }
            .font(.Modakbul.caption)
        }
        
        private var communityRecruitingContentEditButton: some View {
            Button {
                router.route(to: .placeInformationDetailMakingView(place: place, communityRecruitingContent: nil))
            } label: {
                Image(.photoUploadSelection)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 30, height: 30)
            // MARK: - https://stackoverflow.com/q/56561064
            .buttonStyle(BorderlessButtonStyle())
            .shadow(color: .gray.opacity(0.3), radius: 4, y: 4)
        }
        
        private func configureView(by place: Place) {
            let calendar = Calendar.current
            let weekDay = calendar.component(.weekday, from: .now)
            let dayOfWeek = DayOfWeek(weekDay)
            selectedOpeningHourOfDay = place.openingHours.first(where: {$0.dayOfWeek == dayOfWeek})
        }
        
        private func displayOpeningHours(_ openingHour: OpeningHour) -> String {
            let dayOfWeek = openingHour.dayOfWeek.description
            let open = openingHour.open
            let close = openingHour.close
            return "\(dayOfWeek) \(open) - \(close)"
        }
        
        private func displaySelectedOpeningHourText() {
            if let openingHour = selectedOpeningHourOfDay {
                openingHourText = displayOpeningHours(openingHour)
            }
        }
    }
}
