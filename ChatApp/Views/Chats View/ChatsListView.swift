//
//  ChatsListView.swift
//  ChatApp
//
//  Created by Vu Trinh on 6/12/22.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    @Binding var isChatShowing: Bool
    
    var body: some View {
        VStack {
            // Heading
            HStack {
                Text("Chats")
                    .font(Font.pageTitle)
                
                Spacer()
                
                Button {
                    // TODO: Settings
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tint(Color("icons-secondary"))
                }
            }
            .padding(.top, 80)
            .padding(.horizontal)
            
            // Chat list
            if chatViewModel.chats.count > 0 {
                List(chatViewModel.chats) {
                    chat in
                    Button {
                        // Set selected chat for that chatViewModel
                        chatViewModel.selectedChat = chat
                        // Display conversation view
                        isChatShowing = true
                    } label: {
                        ChatListRow(chat: chat, otherParticipants: contactsViewModel.getParticipants(ids: chat.participantids))
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
            else {
                Spacer()
                
                Image("no-chats-yet")
                
                Text("Hmm... no chats here yet!")
                    .font(Font.titleText)
                    .padding(.top, 32)
                
                Text("Chat with a friend to get started")
                    .font(Font.bodyParagraph)
                    .padding(.top, 8)
                
                
                Spacer()
            }
        }
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView(isChatShowing: .constant(false))
    }
}
