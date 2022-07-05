//
//  RootView.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/27/22.
//

import SwiftUI

struct RootView: View {
    // For detecting when the app state changes
    @Environment(\.scenePhase) var scenePhse
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State var selectedTab: Tabs = .contacts
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    @State var isChatShowing = false
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack {
                switch selectedTab {
                case .chats:
                    ChatsListView(isChatShowing: $isChatShowing)
                case .contacts:
                    ContactsListView(isChatShowing: $isChatShowing)
                }
                
                Spacer()
                
                CustomTabBar(selectedTabs: $selectedTab)
            }
                    
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
        .fullScreenCover(isPresented: $isChatShowing) {
            // The conversation view
            ConversationView(isChatShowing: $isChatShowing)
        }
        .onChange(of: scenePhse) { newPhase in
            if newPhase == .active {
                print("Active")
            }
            else if newPhase == .inactive {
                print("Inactive")
            }
            else if newPhase == .background {
                chatViewModel.chatListViewCleanup()
            }
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
