//
//  AuthViewModel.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/29/22.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    static func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func getLoggedInUserId() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    static func loggedOut() {
        try? Auth.auth().signOut()
    }
}
