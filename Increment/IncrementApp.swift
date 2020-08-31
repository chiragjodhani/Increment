//
//  IncrementApp.swift
//  Increment
//
//  Created by Chirag's on 29/08/20.
//

import SwiftUI
import Firebase
@main
struct IncrementApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("setting up firebase")
        FirebaseApp.configure()
        return true
    }
}
