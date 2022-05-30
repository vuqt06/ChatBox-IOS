//
//  RootView.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/27/22.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: Tabs = .contacts
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            
            Spacer()
            
            CustomTabBar(selectedTabs: $selectedTab)
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
    }
    
//    init() {
//        for family in UIFont.familyNames {
//            for fontName in UIFont.fontNames(forFamilyName: family) {
//                print("--\(fontName)")
//            }
//        }
//    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
