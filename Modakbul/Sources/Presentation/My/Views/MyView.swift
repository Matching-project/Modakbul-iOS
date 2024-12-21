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
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    @AppStorage(AppStorageKey.provider) private var provider: AuthenticationProvider?
    
    init(_ myViewModel: MyViewModel) {
        self.vm = myViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = vm.user {
                HeaderWhenLoggedIn(vm, user: user)
                   .padding(.bottom, -10)
            } else {
                HeaderWhenLoggedOut()
            }
            
            Cell(for: vm.user)
        }
        .padding(.horizontal, Constants.horizontal)
        .onChange(of: vm.user?.id ?? Constants.temporalId) { _, newValue in
            if newValue != Constants.temporalId {
                userId = Int(newValue)
            }
        }
    }
}

extension MyView {
    struct HeaderWhenLoggedIn: View {
        @EnvironmentObject private var router: Router
        @ObservedObject private var vm: MyViewModel
        @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
        
        private let user: User
        
        init(
            _ vm: MyViewModel,
            user: User
        ) {
            self.vm = vm
            self.user = user
        }
        
        var body: some View {
            HStack {
                AsyncImageView(
                    url: user.imageURL,
                    contentMode: .fill,
                    maxWidth: 100,
                    maxHeight: 100,
                    clipShape: .circle
                )
                
                VStack(alignment: .leading) {
                    // MARK: - 한글 닉네임 10자까지 가능(iPhone 15 Pro)
                    Text(user.nickname + "님, 반가워요!")
                        .bold()
                    
                    Text(user.categoriesOfInterest.description + " · " + user.job.description + " · " + user.birth.toAge())
                        .font(.Modakbul.subheadline)
                    
                    HStack {
                        Button {
                            router.route(to: .profileEditView(user: user))
                        } label: {
                            Text("프로필 수정")
                                .font(.Modakbul.footnote)
                                .bold()
                        }
                        .buttonStyle(.capsuledInset)
                        
                        Button {
                            showLogoutAlert()
                        } label: {
                            Text("로그아웃")
                                .font(.Modakbul.footnote)
                                .bold()
                        }
                        .buttonStyle(.capsuledInset)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .layoutPriority(1)
            }
            .onAppear {
                vm.readMyProfile(Int64(userId))
            }
        }
        
        private func showLogoutAlert() -> Void {
            router.alert(for: .logout, actions: [
                .cancelAction("취소") {
                    router.dismiss()
                },
                .defaultAction("로그아웃") {
                    vm.logout(userId: Int64(userId))
                }
            ])
        }
    }
    
    struct HeaderWhenLoggedOut: View {
        @EnvironmentObject private var router: Router
        
        var body: some View {
            HStack {
                Image(.modakbulMainReverse)
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
        @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
        private let user: User?
        
        init(for user: User?) {
            self.user = user
        }
        
        var body: some View {
            List {
                Section("이용정보") {
                    button("나의 모집글", destination: .myCommunityRecruitingContentListView(userId: Int64(userId)))
                    button("참여 모임 내역", destination: .myCommunityListView(userId: Int64(userId)))
                    button("나의 참여 요청", destination: .myParticipationRequestListView(userId: Int64(userId)))
                    button("카페 제보/리뷰", destination: .placeShowcaseView(userId: Int64(userId)))
                }
                .listRowSeparator(.hidden, edges: .top)
                
                Section("차단/신고") {
                    button("차단 목록", destination: .blockedListView)
                    button("신고 내역", destination: .reportListView)
                }
                .listRowSeparator(.hidden, edges: .top)
                
                Section {
//                    button("알림 설정", destination: .notificationSettingsView)
                    Link("약관 및 정책", destination: URL(string: "https://www.notion.so/204b106dd58a4f5fbec3320410cb72a7?pvs=4")!)
                    
                    if let user = user {
                        button("탈퇴하기", destination: .unregistrationView(user: user))
                    }
                    
                    Text("문의처: modakbul@gmail.com")
                }
                .listRowSeparator(.hidden)
            }
            .scrollDisabled(true)
            .listStyle(.inset)
        }
        
        private func button(_ title: String, destination: Route) -> some View {
            Button {
                handleButtonTap(for: destination)
            } label: {
                Text(title)
            }
        }
        
        private func handleButtonTap(for destination: Route) {
            if userId == Constants.loggedOutUserId {
                router.alert(for: .login, actions: [
                    .cancelAction("취소") {
                        router.dismiss()
                    },
                    .defaultAction("로그인") {
                        router.route(to: .loginView)
                    }
                ])
            } else {
                router.route(to: destination)
            }
        }
    }
}
