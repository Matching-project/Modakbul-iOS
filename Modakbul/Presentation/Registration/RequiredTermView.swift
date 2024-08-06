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
    
    var body: some View {
        LazyVStack(alignment: .leading,
                   spacing: RegistrationViewValue.Header.vStackSpacing) {
            Text("약관에 동의해주세요")
                .padding([.leading, .trailing], RegistrationViewValue.xAxisPadding)
                .padding(.top, RegistrationViewValue.Header.topPadding)
                .padding(.bottom, RegistrationViewValue.Header.bottomPadding)
                .font(.title2)
                .fontWeight(.semibold)
            
            Toggle("모두 동의", isOn: Binding<Bool>(
                get: { self.allChecked },
                set: { newValue in
                    self.serviceChecked = newValue
                    self.locationChecked = newValue
                    self.privacyChecked = newValue
                }
            ))
            .toggleStyle(DefaultCheckBox())
            .padding(RegistrationViewValue.yAxisPadding)
            
            ForEach(RequiredTerm.allCases, id: \.self) { requiredTerm in
                // TODO: 약관 내용을 표시할 Link() 추가 필요
                HStack {
                    Toggle(requiredTerm.description, isOn: binding(requiredTerm))
                        .toggleStyle(DefaultCheckBox())
                        .padding(.leading, RegistrationViewValue.yAxisPadding)
                    
                    Spacer()
                    
                    Link(destination: URL(string: link(requiredTerm))!) {
                        Image(systemName: "chevron.right")
                    }
                    .frame(width: 10)
                    .padding(.trailing, 30)
                }
            }
            
            FlatButton("확인") {
                router.route(to: .registrationView)
                router.dismiss()
            }
            .disabled(!allChecked)
            .padding([.leading, .trailing], RegistrationViewValue.xAxisPadding)
            .padding(.top, RegistrationViewValue.Footer.topPadding)
            .padding(.bottom, RegistrationViewValue.Footer.bottomPadding)
        }
    }
}

extension RequiredTermView {
    private var allChecked: Bool {
        serviceChecked && locationChecked && privacyChecked
    }
    
    private func binding(_ requiredTerm: RequiredTerm) -> Binding<Bool> {
        switch requiredTerm {
        case .service: return Binding(get: { serviceChecked }, set: { serviceChecked = $0 })
        case .location: return Binding(get: { locationChecked }, set: { locationChecked = $0 })
        case .privacy: return Binding(get: { privacyChecked }, set: { privacyChecked = $0 })
        }
    }
    
    private func link(_ requiredTerm: RequiredTerm) -> String {
        // TODO: - 약관 링크 추가 필요
        switch requiredTerm {
        case .service: return "https://naver.com"
        case .location: return "https:/google.co.kr"
        case .privacy: return "https://daum.net"
        }
    }
}
