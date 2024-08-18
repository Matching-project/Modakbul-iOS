//
//  PlaceInformationDetailMakingView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/12/24.
//

import SwiftUI

struct PlaceInformationDetailMakingView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var placeInformationDetailMakingViewModel: PlaceInformationDetailMakingViewModel
       
    init(_ placeInformationDetailMakingViewModel: PlaceInformationDetailMakingViewModel) {
        self.placeInformationDetailMakingViewModel = placeInformationDetailMakingViewModel
    }
    
    var backButton : some View {
        Button{
            router.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("장소")
//                RoundedTextField(<#T##titleKey: String##String#>, text: <#T##Binding<String>#>)
                TextField("옘병", text: <#T##Binding<String>#>)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("모집글 작성")
        .navigationBarItems(leading: backButton)
    }
}

struct PlaceInformationDetailMakingView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .placeInformationDetailMakingView)
    }
}

final class PlaceInformationDetailMakingViewModel: ObservableObject {
    @Published var location = ""
    @Published var category = ""
    @Published var peopleCount = ""
    @Published var date = ""
    @Published var progressTime = ""
    @Published var title = ""
    @Published var content = ""
}
