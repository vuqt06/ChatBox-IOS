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
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack {
                switch selectedTab {
                case .chats:
                    ChatsListView()
                case .contacts:
                    ContactsListView()
                }
                
                Spacer()
                
                CustomTabBar(selectedTabs: $selectedTab)
            }
                    
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
        .frame(alignment: .topLeading)
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
