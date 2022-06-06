//
//  VerificationView.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/30/22.
//

import SwiftUI
import Combine

struct VerificationView: View {
    @State var verfificationCode = ""
    @Binding var currentStep: OnboardingStep
    var body: some View {
        VStack {
            Text("Verification")
                .font(.titleText)
                .padding(.top, 52)
            
            Text("Enter the 6-digit verification code we sen to your device.")
                .font(.bodyParagraph)
                .padding(.top, 12)
            
            // Textfield
            ZStack {
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("input"))
                
                HStack {
                    TextField("", text: $verfificationCode)
                        .font(.bodyParagraph)
                        .keyboardType(.numberPad)
                        .onReceive(Just(verfificationCode)) { _ in
                            TextHelper.limitText(&verfificationCode, 6)
                        }
                    
                    Spacer()
                    
                    Button {
                        // Clear text field
                       verfificationCode = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                    }
                    .frame(width: 19, height: 19)
                    .tint(Color("icons-input"))
                }
                .padding()
            }
            .padding(.top, 34)
            
            Spacer()
            
            Button {
                // Send the verification code o Firebase
                AuthViewModel.verifyCode(code: verfificationCode) { error in
                    // Check for errors
                    if error == nil {
                        // Move to the next Step
                        currentStep = .profile
                    }
                    else {
                        // TODO: Show an error
                    }
                }
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)

        }
        .padding(.horizontal)
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification))
    }
}
