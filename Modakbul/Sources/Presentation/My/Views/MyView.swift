//
//  MyView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/25/24.
//

import SwiftUI

struct MyView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: MyViewModel
    @State private var isLoggedIn: Bool
    
    // TODO: - 로그인 상태 AppStorage로 관리 필요
    init(myViewModel: MyViewModel, isLoggedIn: Bool = true) {
        self.vm = myViewModel
        self.isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoggedIn {
                HeaderWhenLoggedIn(user: $vm.user)
                    .padding(.bottom, -10)
                    .border(.red)
            } else {
                HeaderWhenLoggedOut()
            }
            
            Cell()
                .border(.red)
        }
        .padding(.horizontal, Constants.horizontal)
    }
}

extension MyView {
    struct HeaderWhenLoggedIn: View {
        @EnvironmentObject private var router: Router
        @Binding var user: User
        
        var body: some View {
            HStack {
                AsyncImageView(url: user.imageURL)
                    .clipShape(.circle)
                    .frame(maxHeight: 128)
                
                VStack(alignment: .leading) {
                    // MARK: - 한글 닉네임 10자까지 가능(iPhone 15 Pro)
                    Text(user.nickname + "님, 반가워요!")
                        .bold()
                    
                    Text(user.categoriesOfInterest.description + " · " + user.job.description + " · " + user.birth.toAge())
                        .font(.subheadline)
                    
                    HStack {
                        CapsuledInsetButton {
                            //                            router.route(to: .)
                        } label: {
                            Text("프로필 수정")
                        }
                        
                        CapsuledInsetButton {
                            router.alert(for: .logout, actions: [
                                .cancelAction("취소") {
                                    router.dismiss()
                                },
                                .defaultAction("로그아웃") {
                                    router.dismiss()
                                }])
                        } label: {
                            Text("로그아웃")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
        }
    }
    
    struct HeaderWhenLoggedOut: View {
        @EnvironmentObject private var router: Router
        
        var body: some View {
            HStack {
                Image(.modakbulMainDark)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 80)
                
                HStack(spacing: 0) {
                    Button {
                        router.route(to: .loginView)
                    } label: {
                        Text("로그인/회원가입")
                            .underline()
                    }
                    
                    Text("을 해주세요.")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    struct Cell: View {
        @EnvironmentObject private var router: Router
        
        var body: some View {
            List {
                Section("이용정보") {
                    Button {
                        
                    } label: {
                        Text("나의 모집글")
                    }
                    
                    Button {
                        
                    } label : {
                        Text("참여 모집 내역")
                    }
                    
                    Button {
                        
                    } label : {
                        Text("나의 참여 요청")
                    }
                    
                    Button {
                        router.route(to: .placeShowcaseView)
                    } label : {
                        Text("카페 제보/리뷰")
                    }
                }
                .headerProminence(.increased)
                .listRowSeparator(.hidden, edges: .top)
                .padding(.top, -10)
                
                Section("차단/신고") {
                    Button {
                        
                    } label: {
                        Text("차단 목록")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("신고 내역")
                    }
                }
                .headerProminence(.increased)
                .listRowSeparator(.hidden, edges: .top)
                .padding(.top, -10)
                
                Section {
                    Button {
                        
                    } label: {
                        Text("알림 설정")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("약관 및 정책")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("탈퇴하기")
                    }
                    
                    Text("문의처: modakbul@email.com")
                }
                .listRowSeparator(.hidden)
            }
            .scrollDisabled(true)
            .listStyle(.inset)
        }
    }
}

final class MyViewModel: ObservableObject {
    @Published var user: User
    //    private let userBusinessUseCase: UserBusinessUseCase
    
    init(user: User = PreviewHelper.shared.users.first ?? User()) {
        self.user = user
        //        self.userBusinessUseCase = userBusinessUseCase
    }
}


struct MyView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .myView)
    }
}
