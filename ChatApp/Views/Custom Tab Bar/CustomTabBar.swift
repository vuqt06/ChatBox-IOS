//
//  CustomTabBar.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/28/22.
//

import SwiftUI

enum Tabs: Int {
    case chats = 0
    case contacts = 1
}

struct CustomTabBar: View {
    @Binding var selectedTabs: Tabs
    
    var body: some View {
        HStack (alignment: .center) {
            Button {
                // Switch to chats
                selectedTabs = .chats
            } label: {
                TabBarButton(buttonText: "Chats", imageName: "bubble.left", isActive: selectedTabs == .chats)
            }
            .tint(Color("icons-secondary"))
            
            Button {
                // Switch to new chat
                AuthViewModel.loggedOut()
            } label: {
                VStack(alignment: .center, spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Text("New Chat")
                        .font(.tabBar)
                }
            }
            .tint(Color("icons-primary"))

            
            
            Button {
                // Switch to contacts
                selectedTabs = .contacts
            } label: {
                TabBarButton(buttonText: "Contacts", imageName: "person", isActive: selectedTabs == .contacts)
            }
            .tint(Color("icons-secondary"))


        }
        .frame(height: 82)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTabs: .constant(.contacts))
    }
}
