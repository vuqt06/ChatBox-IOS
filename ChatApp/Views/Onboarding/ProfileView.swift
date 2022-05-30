//
//  ProfileView.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/30/22.
//

import SwiftUI

struct ProfileView: View {
    @State var firstName = ""
    @State var lastName = ""
    @Binding var currentStep: OnboardingStep
    var body: some View {
        VStack {
            Text("Setup your profile")
                .font(.titleText)
                .padding(.top, 52)
            
            Text("Just a few more details to get started")
                .font(.bodyParagraph)
                .padding(.top, 12)
            
            Spacer()
            
            // Profile image button
            Button {
                
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color.white)
                    
                    Circle()
                        .stroke(Color("create-profile-border"), lineWidth: 2)
                    
                    Image(systemName: "camera.fill")
                        .tint(Color("icons-input"))
                }
                .frame(width: 134, height: 134)
            }

            Spacer()
            // First Name
            TextField("Given Name", text: $firstName)
                .textFieldStyle(CreateProfileTextFieldStyle())
            
            // Last Name
            TextField("Last Name", text: $firstName)
                .textFieldStyle(CreateProfileTextFieldStyle())
            
            Spacer()
            
            Button {
                // Next Step
                currentStep = .contacts
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)

        }
        .padding(.horizontal)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(firstName: "", lastName: "", currentStep: .constant(.profile))
    }
}
