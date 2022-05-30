//
//  PhoneNumberView.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/30/22.
//

import SwiftUI

struct PhoneNumberView: View {
    @State var phoneNumber = ""
    @Binding var currentStep: OnboardingStep
    var body: some View {
        VStack {
            Text("Verification")
                .font(.titleText)
                .padding(.top, 52)
            
            Text("Enter your mobile number below. We will send you a verification code.")
                .font(.bodyParagraph)
                .padding(.top, 12)
            
            // Textfield
            ZStack {
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("input"))
                
                HStack {
                    TextField("e.g. +1 613 515 0123", text: $phoneNumber)
                        .font(.bodyParagraph)
                    
                    Spacer()
                    
                    Button {
                        // Clear text field
                        phoneNumber = ""
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
                // Next Step
                currentStep = .verification
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)

        }
        .padding(.horizontal)
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.phoneNumber))
    }
}
