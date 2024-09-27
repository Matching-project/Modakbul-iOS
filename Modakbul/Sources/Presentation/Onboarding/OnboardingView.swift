//
//  OnboardingView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/19/24.
//

import SwiftUI

struct OnboradingView: View {
    @State private var selection: Int = 0
    @Binding var isFirstLaunch: Bool
    
    init(_ isFirstLaunch: Binding<Bool>) {
        _isFirstLaunch = isFirstLaunch
    }
    
    private let index = Array(0...2)
    private let titles = ["같이 공부하고, 같이 취미를\n즐기고 싶은 당신에게.",
                          "카페별로 진행 중인 모임에 참여해요!",
                          "모임에서 당신의 모닥불을 지펴봐요!"]
    // TODO: - 다크모드시 이미지 대응 안됨
    private let images = ["Onboarding 1", "Onboarding 2", "Onboarding 3"]


    var body: some View {
        VStack {
            GeometryReader { proxy in
                carouselArea(proxy.size)
            }
            
            FlatButton("시작하기") {
                isFirstLaunch = false
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, Constants.horizontal)
    }
    
    @ViewBuilder
    private func carouselArea(_ size: CGSize) -> some View {
        TabView(selection: $selection) {
            ForEach(index, id: \.self) { num in
                VStack {
                    Text(titles[num])
                        .font(.Modakbul.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    Image(images[num])
                        .resizable()
                        .scaledToFit()
                        .frame(height: size.height * 0.4)
                    
                    Spacer()
                }
                .tag(num)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(
            CustomPageControl(currentPageIndex: $selection, pageCountLimit: index.count),
            alignment: .bottom
        )
    }
}

struct OnboardingView_Preview: PreviewProvider {
    @State private static var isFirstLaunch: Bool = false

    static var previews: some View {
        OnboradingView($isFirstLaunch)
    }
}
