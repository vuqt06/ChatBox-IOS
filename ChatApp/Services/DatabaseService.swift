//
//  DatabaseService.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/31/22.
//

import Foundation
import Contacts
import Firebase
import FirebaseFirestoreSwift

class DatabaseService {
    
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping ([User]) -> Void) {
        // The array where we're storing fetched platform users
        var platformUsers = [User]()
        
        // Construct an array of string phone numbers to look up
        var lookupPhoneNumbers = localContacts.map { contact in
            // Turn the contact into a phone number as a string
            return TextHelper.sanitizePhoneNumber(phone: contact.phoneNumbers.first?.value.stringValue ?? "")
        }
        
        // Make sure there are lookup numbers
        guard lookupPhoneNumbers.count > 0 else {
            // Callback
            completion(platformUsers)
            return
        }
        
        // Query the database for these phone numbers
        let db = Firestore.firestore()
        
        // Perform queries while we still have phone numbers
        while (!lookupPhoneNumbers.isEmpty) {
            
            // Get the first < 10 phone numbers to look up
            let tenPhoneNumbers = Array(lookupPhoneNumbers.prefix(10))
            
            // Remove the < 10 that we're looking up
            lookupPhoneNumbers = Array(lookupPhoneNumbers.dropFirst(10))
            
            // Look up the first 10 and retrieve the users that are on the platform
            db.collection("users").whereField("phone", in: tenPhoneNumbers)
                .getDocuments { snapshot, error in
                // Check for errors
                    if let err = error {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        for doc in snapshot!.documents {
                            let user = doc.data()
                            let firstname = user["firstname"] as? String ?? ""
                            let lastname = user["lastname"] as? String ?? ""
                            let phone = user["phone"] as? String ?? ""
                            let photo = user["photo"] as? String ?? ""
                            platformUsers.append(User(firstname: firstname, lastname: lastname, phone: phone, photo: photo))
                        }
                    }
                    
                    // Check if we have anymore phone numbers to look up
                    // If not, we can call the cpmpletion black and we're done
                    if lookupPhoneNumbers.isEmpty {
                        // Return these users
                        completion(platformUsers)
                    }
            }
        }
    }
}
