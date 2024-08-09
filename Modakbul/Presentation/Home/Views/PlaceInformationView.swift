//
//  PlaceInformationView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlaceInformationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    private let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    var body: some View {
        VStack {
            PlaceInformationHeader(place)
                .padding(.top)
                .overlay(alignment: .topTrailing) {
                    Button {
                        // TODO: 모집글 작성 뷰로 이동
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.trailing)
                    .alignmentGuide(.top) { dimension in
                        dimension.height / 2 - 30
                    }
                    .alignmentGuide(.trailing) { dimension in
                        dimension.width / 2 + 14
                    }
                }
            
            ScrollView {
                LazyVStack {
                    ForEach(place.communities, id: \.id) { communityRecruitingContent in
                        Cell(communityRecruitingContent)
                    }
                }
            }
        }
        .padding()
    }
}

extension PlaceInformationView {
    struct Cell: View {
        private let communityRecruitingContent: CommunityReqruitingContent
        
        private var community: Community {
            self.communityRecruitingContent.community
        }
        
        init(_ communityRecruitingContent: CommunityReqruitingContent) {
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
            .border(.accent)
        }
    }
}

struct PlaceInformationSheet_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .placeInformationView(place: previewHelper.places.first!))
    }
}
