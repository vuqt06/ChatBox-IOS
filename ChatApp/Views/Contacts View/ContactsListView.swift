//
//  ContactsListView.swift
//  ChatApp
//
//  Created by Vu Trinh on 6/12/22.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    @State var filterText = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Contacts")
                    .font(.pageTitle)
                Spacer()
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .tint(Color("icons-secondary"))
            }
            .padding(.top, 20)
            
            // Search bar
            ZStack {
                Rectangle()
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                
                TextField("Search contact or number", text: $filterText)
                    .font(.tabBar)
                    .foregroundColor(Color("text-textfield"))
                    .padding()
            }
            .frame(height: 46)
            
            if contactsViewModel.users.count > 0 {
                // List
                List(contactsViewModel.users) {
                    user in
                    Text(user.firstname ?? "Test User")
                }
                .listStyle(.plain)
            }
            else {
                Spacer()
                
                Image("no-contacts-yet")
                
                Text("Hmm... Zero contacts?")
                    .font(.titleText)
                    .padding(.top, 32)
                
                Text("Try saving some contacts on your phone!")
                    .font(.bodyParagraph)
                    .padding(.top, 8)
                
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .onAppear {
            contactsViewModel.getLocalContacts()
        }

    }
}

struct ContactsListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsListView()
    }
}
