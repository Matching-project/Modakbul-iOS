//
//  PlaceInformationView.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct PlaceInformationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    @State private var isExpanded: Bool = false
    
    private let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "questionmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
//                    .background(.red.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("카페 이름")
                        .font(.headline)
                    
                    Text("카페 도로명주소")
                        .font(.subheadline)
                    HStack {
                        Text("운영시간: ")
                        Text("수: 00:00 ~ 00:00").foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("콘센트 여부: 혼잡도")
                        Spacer()
                        Text("단체석").foregroundColor(.gray)
                    }
                }
            }
//            .background(.green.opacity(0.3))
            
            List(place.communities, id: \.id) { recruitingContent in
                HStack {
                    CapsuleTag("일일")
                    Text(recruitingContent.title)
                }
                
                HStack(spacing: 4) {
                    CapsuleTag(recruitingContent.community.category.identifier)
                    Image(systemName: "person.fill")
                    Text("\(recruitingContent.community.participants.count) / \(recruitingContent.community.participantsLimit)")
                    Image(systemName: "calendar")
                    Text(recruitingContent.community.promiseDate.date.toString(by: .yyyyMMddKorean))
                    Image(systemName: "clock")
                    Text(recruitingContent.community.promiseDate.date.toString(by: .HHmm))
                }
            }
            .listStyle(.plain)
        }
    }
}

struct PlaceInformationSheet_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .placeInformationView(place: previewHelper.places.first!))
    }
}
