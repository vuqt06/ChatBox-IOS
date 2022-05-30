//
//  OnboardingContainerView.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/30/22.
//

import SwiftUI

enum OnboardingStep: Int {
    case welcome = 0
    case phoneNumber = 1
    case verification = 2
    case profile = 3
    case contacts = 4
}

struct OnboardingContainerView: View {
    @Binding var isOnboarding: Bool
    @State var currentStep: OnboardingStep = .welcome
    var body: some View {
        ZStack {
            Color("background")
            
            switch currentStep {
            case .welcome:
                WelcomeView(currentStep: $currentStep)
            case .phoneNumber:
                PhoneNumberView(currentStep: $currentStep)
            case .verification:
                VerificationView(currentStep: $currentStep)
            case .profile:
                ProfileView(currentStep: $currentStep)
            case .contacts:
                SyncContactsView(isOnboarding: $isOnboarding)
            }
        }
        .ignoresSafeArea()
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView(isOnboarding: .constant(true))
    }
}
