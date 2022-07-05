//
//  ContactRow.swift
//  ChatApp
//
//  Created by Vu Trinh on 6/13/22.
//

import SwiftUI

struct ContactRow: View {
    
    var user: User
    var body: some View {
        // Create URL from user photo url
        HStack(spacing: 24) {
            // Profile Image
            ProfilePicView(user: user)
            
            VStack(alignment: .leading, spacing: 4) {
                // Name
                Text("\(user.firstname ?? "") \(user.lastname ?? "")")
                    .font(.button)
                    .foregroundColor(Color(("text-primary")))
                
                // Phone number
                Text(user.phone ?? "")
                    .font(.bodyParagraph)
                    .foregroundColor(Color("text-sub"))
            }
            
            // Extra space
            Spacer()
        }
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(user: User())
    }
}
