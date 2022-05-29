//
//  ChatApp.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/27/22.
//

import SwiftUI
import Firebase

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        RootView()
      }
    }
  }
}

