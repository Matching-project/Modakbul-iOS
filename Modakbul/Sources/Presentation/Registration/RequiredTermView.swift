//
//  RequiredTermView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/30/24.
//

import SwiftUI

struct RequiredTermView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @State private var serviceChecked: Bool = false
    @State private var locationChecked: Bool = false
    @State private var privacyChecked: Bool = false
    @State private var EULAChecked: Bool = false
    
    private let userCredential: UserCredential
    
    init(userCredential: UserCredential) {
        self.userCredential = userCredential
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading,
                       spacing: 10) {
                // TODO: - 다기종 sheet 높이 점검 필요
                Text("약관에 동의해주세요")
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                    .font(.Modakbul.title2)
                    .fontWeight(.semibold)
                
                Toggle("모두 동의", isOn: Binding<Bool>(
                    get: { self.allChecked },
                    set: { newValue in
                        self.serviceChecked = newValue
                        self.locationChecked = newValue
                        self.privacyChecked = newValue
                        self.EULAChecked = newValue
                    }
                ))
                .toggleStyle(DefaultCheckBox())
                .padding(.vertical, 20)
                
                ForEach(RequiredTerm.allCases, id: \.self) { requiredTerm in
                    HStack {
                        Toggle(requiredTerm.description, isOn: binding(requiredTerm))
                            .toggleStyle(DefaultCheckBox())
                        
                        Spacer()
                        
                        Link(destination: URL(string: link(requiredTerm))!) {
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing, 10)
                    }
                }
            }
           .padding(.horizontal, 30)
            
            FlatButton("확인") {
                router.dismiss()
                router.route(to: .registrationView(userCredential: userCredential))
            }
            .disabled(!allChecked)
            .padding(.horizontal, Constants.horizontal)
            .padding(.top, 50)
            .padding(.bottom, 30)
        }
    }
}

extension RequiredTermView {
    private var allChecked: Bool {
        serviceChecked && locationChecked && privacyChecked && EULAChecked
    }
    
    private func binding(_ requiredTerm: RequiredTerm) -> Binding<Bool> {
        switch requiredTerm {
        case .service: return Binding(get: { serviceChecked }, set: { serviceChecked = $0 })
        case .location: return Binding(get: { locationChecked }, set: { locationChecked = $0 })
        case .privacy: return Binding(get: { privacyChecked }, set: { privacyChecked = $0 })
        case .EULA: return Binding(get: { EULAChecked }, set: { EULAChecked = $0 })
        }
    }
    
    private func link(_ requiredTerm: RequiredTerm) -> String {
        switch requiredTerm {
        case .service: return "https://exuberant-snowplow-45e.notion.site/d4ef7dcf9d1b4875abed5e87b43def74?pvs=4"
        case .location: return "https://exuberant-snowplow-45e.notion.site/265773e7dce6488bbad45da8bad15938?pvs=4"
        case .privacy: return "https://exuberant-snowplow-45e.notion.site/063bfff6884745e0a9e162551b5de062?pvs=4"
        case .EULA: return "https://exuberant-snowplow-45e.notion.site/EULA-8b858ec27ee248d69a7d6cef2c093b44?pvs=4"
        }
    }
}
