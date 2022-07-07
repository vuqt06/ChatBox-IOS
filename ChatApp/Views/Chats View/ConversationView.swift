//
//  ConversationView.swift
//  ChatApp
//
//  Created by Vu Trinh on 6/18/22.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    @Binding var isChatShowing: Bool
    @State var chatMessage = ""
    @State var participants = [User]()
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            HStack {
                VStack(alignment: .leading) {
                    // Back arrow
                    Button {
                        isChatShowing = false
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("bubble-primary"))
                    }
                    .padding(.bottom, 16)
                    
                    // Name
                    if participants.count > 0 {
                        let participant = participants.first
                        Text("\(participant?.firstname ?? "") \(participant?.lastname ?? "")")
                            .font(.chatHeading)
                            .foregroundColor(Color("text-header"))
                    }
                    
                }
                
                Spacer()
                
                // Profile Image
                if participants.count > 0 {
                    let participant = participants.first
                    ProfilePicView(user: participant!)
                }
                
            }
            .padding(.horizontal)
            .frame(height: 104)
            
            // Chat log
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        
                        ForEach(Array(chatViewModel.messages.enumerated()), id: \.element) {
                            index, msg in
                            let isFromUser = msg.senderid == AuthViewModel.getLoggedInUserId()
                            
                            // Dynamic message
                            HStack {
                                
                                if (isFromUser) {
                                    // Timestamp
                                    Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                        .font(.smallText)
                                        .foregroundColor(Color("text-timestamp"))
                                        .padding(.trailing)
                                    
                                    Spacer()
                                }
                                
                                // Message
                                Text(msg.msg)
                                    .font(.bodyParagraph)
                                    .foregroundColor(isFromUser ? Color("text-button") : Color("text-chat"))
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 24)
                                    .background(isFromUser ? Color("bubble-primary") : Color("bubble-secondary"))
                                    .cornerRadius(30, corners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                                
                                if (!isFromUser) {
                                    Spacer()
                                    
                                    // Timestamp
                                    Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                        .font(.smallText)
                                        .foregroundColor(Color("text-timestamp"))
                                        .padding(.leading)
                                }
                            }
                            .id(index)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                }
                .background(Color("background"))
                .onChange(of: chatViewModel.messages.count) { newCount in
                    withAnimation {
                        proxy.scrollTo(newCount - 1)
                    }
                }
            }
            
            // Chat message bar
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                HStack(spacing: 15) {
                    // Camera button
                    Button {
                        // TODO: Show picker
                    } label: {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("icons-secondary"))
                    }

                    // Textfield
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("date-pill"))
                            .cornerRadius(50)
                        
                        TextField("Type your message", text: $chatMessage)
                            .foregroundColor(Color("text-input"))
                            .font(.bodyParagraph)
                            .padding(10)
                        
                        // Emojis buton
                        HStack {
                            Spacer()
                            Button {
                                // Emojis
                            } label: {
                                Image(systemName: "face.smiling")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("text-input"))
                            }
                        }
                        .padding(.trailing, 12)

                    }
                    .frame(height: 44)
                    
                    // Send button
                    Button {
                        // TODO: Clean up text msg
                        chatMessage = chatMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // Send message
                        chatViewModel.sendMessage(msg: chatMessage)
                        
                        // Clear textbox
                        chatMessage = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("icons-primary"))
                    }
                    .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
            }
            .frame(height: 76)
        }
        .onAppear {
            // Call chat view model to retrieve all chat messages
            chatViewModel.getMessages()
            
            // Try to get the others participants as User instances
            let ids = chatViewModel.getParticipantIds()
            self.participants = contactsViewModel.getParticipants(ids: ids)
        }
        .onDisappear {
            // Do any necessary clean up before conversation view disappears
            chatViewModel.conversationViewCleanup()
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(isChatShowing: .constant(false))
    }
}
