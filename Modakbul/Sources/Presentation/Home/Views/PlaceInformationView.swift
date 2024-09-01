//
//  PlaceInformationView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlaceInformationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: PlaceInformationViewModel
    
    private let place: Place
    
    init(
        _ viewModel: PlaceInformationViewModel,
        place: Place
    ) {
        self.viewModel = viewModel
        self.place = place
    }
    
    var body: some View {
        VStack {
            HStack {
                AsyncImageView(imageData: Data())
                    .background(.gray)
                
                informationArea
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                communityRecruitingContentEditButton
            }
            
            if viewModel.communityRecruitingContents.isEmpty {
                // TODO: 모임 개수 표시 영역
            } else {
                communityRecruitingContentListArea
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.configureView(by: place)
        }
    }
    
    private var informationArea: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.location.name)
                    .font(.title3.bold())
                
                Text(place.location.address)
                    .font(.caption)
            }
            
            HStack {
                Text("운영시간 ")
                
                Menu {
                    ForEach(place.openingHours, id: \.dayOfWeek) { openingHour in
                        Button {
                            viewModel.selectedOpeningHourByDay = openingHour
                        } label: {
                            Text(viewModel.displayOpeningHours(openingHour))
                        }
                    }
                } label: {
                    Text(viewModel.openingHourText)
                    Image(systemName: "chevron.down")
                }
                .tint(colorScheme == .dark ? .white : .black)
            }
            
            HStack {
                CapsuleTag(place.powerSocketState.description, .caption)
                CapsuleTag(place.groupSeatingState.description, .caption)
            }
        }
        .font(.caption)
    }
    
    private var communityRecruitingContentEditButton: some View {
        Button {
            router.route(to: .placeInformationDetailMakingView)
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
    
    private var communityRecruitingContentListArea: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.communityRecruitingContents, id: \.id) { communityRecruitingContent in
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
}

extension PlaceInformationView {
    struct Cell: View {
        private let communityRecruitingContent: CommunityRecruitingContent
        
        private var community: Community { communityRecruitingContent.community }
        
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
