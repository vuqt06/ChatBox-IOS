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
import UIKit
import FirebaseStorage

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
    
    func setUserProfile(firstName: String, lastName: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        // Guard against logged out user
        guard AuthViewModel.isUserLoggedIn() != false else {
            // User is not logged in
            return
        }
        
        // Get user's phone number
        let userPhone = TextHelper.sanitizePhoneNumber(phone: AuthViewModel.getLoggedInUserPhone())
        
        // Get a reference to Firestore
        let db = Firestore.firestore()
        
        // Set the profile data
        // TODO: After implementing authentication, instead create a document with the actual user's uid
        let doc = db.collection("users").document(AuthViewModel.getLoggedInUserId())
        doc.setData(["firstname": firstName,
                     "lastname": lastName,
                     "phone": userPhone])
        
        // Check if an image is passed through
        if let image = image {
            // Create storage reference
            let storageRef = Storage.storage().reference()
            
            // Turn our image into data
            let imageData = image.jpegData(compressionQuality: 0.8)
            
            // Check that we were able to convert it to data
            guard imageData != nil else {
                return
            }
            
            // Specify the file path and name
            let path = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { meta, error in
                
                if error == nil && meta != nil {
                    // Get full url to image
                    fileRef.downloadURL { url, error in
                        // Check for errors
                        if url != nil && error == nil {
                            // Set the image path to the profile
                            doc.setData(["photo": url!.absoluteString], merge: true) {
                                error in
                                if error == nil {
                                    // Success, notify user
                                    completion(true)
                                }
                            }
                        }
                        else {
                            // Wasn't sucessful in getting download url for photo
                            completion(false)
                        }
                    }
                }
                else {
                    // Upload wasn't succesful, notify caller
                    completion(false)
                }
            }
            // Set the image path to the profile
        }
        else {
            // No image was set
            completion(true)
        }
    }
    
    func checkUserProfile(completion: @escaping (Bool) -> Void) {
        // Check that the user is logged in
        guard AuthViewModel.isUserLoggedIn() != false else {
            return
        }
        
        // Create firebase ref
        let db = Firestore.firestore()
        
        db.collection("users").document(AuthViewModel.getLoggedInUserId()).getDocument { snapshot, error in
            // TODO: Keep the users profile data
            if snapshot != nil && error == nil {
                // Notify that profile exists
                completion(snapshot!.exists)
            }
            else {
                // TODO: Look into using Result type to indicate failure vs profile exists
                completion(false)
            }
        }
    }
    
    // MARK: Chat Methods
    
    /// This method returns all chat documents where the logged in user is a participant
    func getAllChats(completion: @escaping ([Chat]) -> Void) {
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Perform a query against the chat collection for any chats where the user is a participant
        let chatsQuery = db.collection("chats").whereField("participantids", arrayContains: AuthViewModel.getLoggedInUserId())
        
        chatsQuery.getDocuments { snapshot, error in
            if snapshot != nil && error == nil {
                
                var chats = [Chat]()
                
                // Loop through all the returned chat docs
                for doc in snapshot!.documents {
                    // Parse the data into Chat structs
                    let chat = try? doc.data(as: Chat.self)
                    
                    // Add the chat into the array
                    if let chat = chat {
                        chats.append(chat)
                    }
                }
                
                // Return the data
                completion(chats)
            }
        }
        else {
            print("Error in database retrieval")
        }
    }
    
    /// This method returns all messages for a given chat
    func getAllMessages(chat: Chat, completion: @escaping ([ChatMessage]) -> Void) {
        
        // Check that the id is not nil
        guard chat.id != nil else {
            // Cannot fetch data
            completion([ChatMessage]())
            return
            
            // Get a reference to the database
            let db = Firestore.firestore()
            
            // Create teh query
            let msgsQuery = db.collection("chats")
                .document(chat.id!)
                .collection("msgs")
                .order(by: "timestamp")
            
            // Perform the query
            msgsQuery.getDocuments { snapshot, error in
                
                if snapshot != nil && error == nil {
                    var messages = [ChatMessage]()
                    
                    for doc in snapshot!.documents {
                        let msg = try? doc.data(as: ChatMessage.self)
                        
                        if let msg = msg {
                            messages.append(msg)
                        }
                    }
                    
                    // Return the result
                    completion(messages)
                }
                else {
                    print("Error in database retrieval")
                }
            }
        }
    }
    
    func sendMessage(msg: String, chat: Chat) {
        // Check that it's a valid chat
        guard chat.id != nil else {
            return
        }
        
        // Get a reference to database
        let db = Firestore.firestore()
        
        // Add msg documents
        db.collection("chats")
            .document(chat.id!)
            .collection("msgs")
            .addDocument(data: ["imageurl" : "",
                                "msg": msg,
                                "senderid": AuthViewModel.getLoggedInUserId(),
                                "timestamp": Date()])
        
        // Update the document
        db.collection("chats")
            .document(chat.id!)
            .setData(["updated" : Date(),
                      "lastmsg": msg],
                     merge: true)
    }
    
    func createChat(chat: Chat, completion: @escaping (String) -> Void) {
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Create a document
        let doc = db.collection("chats").document()
        
        // Set the data for the document
        try? doc.setData(from: chat, completion: { error in
            // Communicate the document id
            completion(doc.documentID)
        })
    }
}
