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
                // Check image cache, if it exists, use that
                if let cachedImage = CacheService.getImage(forKey: user.photo!) {
                    // Image is in cache so lets use it
                    cachedImage
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFill()
                        .clipped()
                }
                else {
                    // If not in the cache, download it
                    
                    // Create URl from user photo url
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
                                .onAppear {
                                    // Save this image into cache
                                    CacheService.setImage(image: image, forKey: user.photo!)
                                }
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
