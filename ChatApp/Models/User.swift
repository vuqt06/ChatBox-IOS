//
//  User.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/31/22.
//

import Foundation
import FirebaseFirestoreSwift
 
struct User: Codable {
    @DocumentID var id: String?
    var firstname: String?
    var lastname: String?
    var phone: String?
    var photo: String?
}
