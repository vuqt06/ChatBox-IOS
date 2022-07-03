//
//  ProfilePicView.swift
//  ChatApp
//
//  Created by Vu Trinh on 6/18/22.
//

import SwiftUI

struct ProfilePicView: View {
    var user: User
    var body: some View {
        ZStack {
            // Check if user has a photo
            if user.photo == nil {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                    
                    Text(user.firstname?.prefix(1) ?? "")
                        .bold()
                }
            }
            else {
                let photoUrl = URL(string: user.photo ?? "")
                AsyncImage(url: photoUrl) {
                    phase in
                    
                    switch phase {
                    case AsyncImagePhase.empty:
                        // Currently fetching
                        ProgressView()
                    case AsyncImagePhase.success(let image):
                        // Display the fetched image
                        image
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .clipped()
                    case AsyncImagePhase.failure(let error):
                        // Could not fetch the profile photo
                        // Display circle with first letter of first name
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                            
                            Text(user.firstname?.prefix(1) ?? "")
                                .bold()
                        }
                    }
                }
            }
            
            
            // Blue border
            Circle()
                .stroke(Color("create-profile-border"), lineWidth: 2)
        }
        .frame(width: 44, height: 44)
    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(user: User())
    }
}
