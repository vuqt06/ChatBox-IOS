//
//  RootView.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/27/22.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
    
    init() {
        for family in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print("--\(fontName)")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
