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
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                TabView {
                    Text("Log").tabItem {
                        Image(systemName: "book")
                    }
                }.accentColor(.primary)
            }else {
                LandingView()
            }
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

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    
    private let userService: UserServiceProtocol
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
//        try? Auth.auth().signOut()
        self.userService.observeAuthChanges().map{$0 != nil}
            .assign(to: &$isLoggedIn)
    }
}
