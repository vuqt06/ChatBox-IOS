//
//  CreateProfileTextFieldStyle.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/30/22.
//

import Foundation
import SwiftUI

struct CreateProfileTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("input"))
                .cornerRadius(8)
                .frame(height: 46)
            
            
            // This refers to the text field
            configuration
                .font(Font.tabBar)
                .padding()
        }
    }
}
