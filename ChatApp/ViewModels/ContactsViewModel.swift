//
//  ContactsViewModel.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/31/22.
//

import Foundation
import SwiftUI
import Contacts

class ContactsViewModel: ObservableObject {
    private var users = [User]()
    private var filterText = ""
    @Published var filteredUsers = [User]()
    private var localContacts = [CNContact]()
    // Perform the contact store method asynchronously so it doesn't block the UI
    func getLocalContacts() {
        DispatchQueue.init(label: "getcontacts").async {
            do {
                // Ask for permission
                let store = CNContactStore()
                
                // Lit of keys we want to get
                let keys = [CNContactPhoneNumbersKey,
                            CNContactGivenNameKey, CNContactFamilyNameKey] as! [CNKeyDescriptor]
                
                // Create a Fetch request
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                
                // Get the contacts on the user's phone
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, success in
                    // Do something with the contact
                    self.localContacts.append(contact)
                })
                // See which local contacts are actually users of this app
                DatabaseService().getPlatformUsers(localContacts: self.localContacts) { platformUsers in
                    
                    // Update the UI in the main thread
                    DispatchQueue.main.async {
                        // Set the fetched users to the published users property
                        self.users = platformUsers
                        
                        // TODO: Set the filtered list
                        self.filterContacts(filterBy: self.filterText)
                    }
                   
                }
            }
            catch {
                // Handle error
            }
        }
    }
    
    func filterContacts(filterBy: String) {
        // Store parameter into property
        self.filterText = filterBy
        
        // If filter text is empty, then reveal all users
        if filterText == "" {
            self.filteredUsers = users
            return
        }
        
        // Run the users list through the filter term to get a list of filtered users
        self.filteredUsers = users.filter({ user in
            // Criteria for including this user into filtered users list
            user.firstname?.lowercased().contains(filterText) ?? false ||
            user.lastname?.lowercased().contains(filterText) ?? false ||
            user.phone?.lowercased().contains(filterText) ?? false
        })
    }
    
    /// Given a list of uder ids, return a list of user objects that have the same ids
    func getParticipants(ids: [String]) -> [User] {
        
        // Filter out the user lists for only the participants based on ids passed in
        let foundUsers = users.filter { user in
            if user.id == nil  {
                return false
            }
            else {
                return ids.contains(user.id!)
            }
        }
        return foundUsers
    }
}
