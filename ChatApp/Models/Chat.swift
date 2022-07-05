//
//  Chat.swift
//  ChatApp
//
//  Created by Vu Trinh on 6/19/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Codable, Identifiable {
    @DocumentID var id: String?
    
    var numparticipants: Int
    
    var participantids: [String]
    
    var lastMsg: String?
    
    @ServerTimestamp var updated: Date?
    
    var msgs: [ChatMessage]?
}

struct ChatMessage: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    
    var imageurl: String?
    
    var msg: String
    
    @ServerTimestamp var timestamp: Date?
    
    var senderid: String
}
