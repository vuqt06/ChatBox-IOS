//
//  OnboardingButtonsStyle.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/30/22.
//

import Foundation
import SwiftUI

struct OnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Rectangle()
                .frame(height: 50)
                .cornerRadius(4)
                .foregroundColor(configuration.isPressed ? Color.white : Color("button-primary"))
            
            configuration.label
                .font(.button)
                .foregroundColor(configuration.isPressed ? Color("button-primary") : Color("text-button"))
        }
    }
}
