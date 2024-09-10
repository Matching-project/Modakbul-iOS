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
    
    init(_ myViewModel: MyViewModel) {
        self.vm = myViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if userId == Constants.loggedOutUserId {
                HeaderWhenLoggedOut()
            } else {
                HeaderWhenLoggedIn(vm)
                    .padding(.bottom, -10)
            }
            
            Cell(for: $vm.user)
        }
        .padding(.horizontal, Constants.horizontal)
    }
}

extension MyView {
    struct HeaderWhenLoggedIn: View {
        @EnvironmentObject private var router: Router
        @ObservedObject private var vm: MyViewModel
        @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
        
        init(_ vm: MyViewModel) {
            self.vm = vm
        }
        
        var body: some View {
            HStack {
                AsyncImageView(url: vm.user.imageURL)
                    .clipShape(.circle)
                    .frame(maxHeight: 128)
                
                VStack(alignment: .leading) {
                    // MARK: - 한글 닉네임 10자까지 가능(iPhone 15 Pro)
                    Text(vm.user.nickname + "님, 반가워요!")
                        .bold()
                    
                    Text(vm.user.categoriesOfInterest.description + " · " + vm.user.job.description + " · " + vm.user.birth.toAge())
                        .font(.subheadline)
                    
                    HStack {
                        Button {
                            router.route(to: .profileEditView)
                        } label: {
                            Text("프로필 수정")
                                .font(.footnote.bold())
                        }
                        .buttonStyle(.capsuledInset)
                        
                        Button {
                            showLogoutAlert()
                        } label: {
                            Text("로그아웃")
                                .font(.footnote.bold())
                        }
                        .buttonStyle(.capsuledInset)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
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
        @Binding private var user: User
        @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
        
        init(for user: Binding<User>) {
            self._user = user
        }
        
        var body: some View {
            List {
                Section("이용정보") {
                    button("나의 모집글", destination: .myCommunityRecruitingContentListView)
                    button("참여 모임 내역", destination: .myCommunityListView)
                    button("나의 참여 요청", destination: .myParticipationRequestListView)
                    button("카페 제보/리뷰", destination: .placeShowcaseView(userId: Int64(userId)))
                }
                .listRowSeparator(.hidden, edges: .top)
                
                Section("차단/신고") {
                    button("차단 목록", destination: .blockedListView)
                    button("신고 내역", destination: .reportListView)
                }
                .listRowSeparator(.hidden, edges: .top)
                
                Section {
                    button("알림 설정", destination: .notificationSettingsView)
                    // TODO: - 약관 및 정책 노션 링크 만들기
                    // button("약관 및 정책", destination: )
                    
                    // TODO: - 탈퇴하기 뷰를 따로 추가할지 건의함
//                    button("탈퇴하기", destination: Route)
//                    router.alert(for: .exitUser(nickname: user.nickname), actions: [
//                        .cancelAction("남아있기") {},
//                        .defaultAction("그래도 탈퇴하기") {
//                            // TODO: - 탈퇴 처리
//                        }
//                    ])
                    
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

struct MyView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .myView)
    }
}
