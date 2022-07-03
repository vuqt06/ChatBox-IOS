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
    
    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    
    @State var isSourceMenuShowing = false
    
    @State var isSaveButtonDisabled = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
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
                // Show action sheet
                isSourceMenuShowing = true
                
            } label: {
                ZStack {
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    }
                    else {
                        Circle()
                            .foregroundColor(Color.white)
                        
                        
                        Image(systemName: "camera.fill")
                            .tint(Color("icons-input"))
                    }
                    Circle()
                        .stroke(Color("create-profile-border"), lineWidth: 2)
                }
                .frame(width: 134, height: 134)
            }

            Spacer()
            // First Name
            TextField("Given Name", text: $firstName)
                .textFieldStyle(CreateProfileTextFieldStyle())
            
            // Last Name
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CreateProfileTextFieldStyle())
            
            Spacer()
            
            Button {
                // TODO: Check that firstname/lastname fields are filled before allowing to save
                
                // Next Step
                // Prevent double clicking
                isSaveButtonDisabled = true
                // Save the data
                DatabaseService().setUserProfile(firstName: firstName, lastName: lastName, image: selectedImage) { isSuccess in
                    if isSuccess {
                        currentStep = .contacts
                    }
                    else {
                        // TODO: Show error message to the user
                    }
                    isSaveButtonDisabled = false
                }
                
            } label: {
                Text(isSaveButtonDisabled ? "Uploading..." : "Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .disabled(isSaveButtonDisabled)
            .padding(.bottom, 87)

        }
        .padding(.horizontal)
        .confirmationDialog("From where?", isPresented: $isSourceMenuShowing, actions: {
            Button {
                // Set the source to photo library
                self.source = .photoLibrary
                // Show the image picker
                isPickerShowing = true
            } label: {
                Text("Photo Library")
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button {
                    // Set the source to camera
                    self.source = .camera
                    // Show the image picker
                    isPickerShowing = true
                } label: {
                    Text("Take Photo")
                }
            }

        })
        .sheet(isPresented: $isPickerShowing) {
            // Show the image picker
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: self.source)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(firstName: "", lastName: "", currentStep: .constant(.profile))
    }
}
