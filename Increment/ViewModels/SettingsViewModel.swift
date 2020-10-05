//
//  SettingsViewModel.swift
//  Increment
//
//  Created by Chirag's on 30/09/20.
//

import Combine
import SwiftUI
final class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Published private(set) var itemViewModels: [SettingsItemViewModel] = []
    let title = "Settings"
    @Published var loginSignupPushed = false
    func item(at index: Int) -> SettingsItemViewModel {
        itemViewModels[index]
    }
    
    func tappedItem(at index: Int) {
        switch itemViewModels[index].type {
        case .account:
            self.loginSignupPushed = true
        case .mode:
            self.isDarkMode = !self.isDarkMode
            buildItems()
        default:
            break
        }
    }
    
    func buildItems(){
        itemViewModels = [
            .init(title: "Create Account", iconName: "person.circle", type: .account),
            .init(title: "Switch to \(isDarkMode ? "Light" : "Dark") Mode", iconName: "lightbulb", type: .mode),
            .init(title: "Privacy Policy", iconName: "shield", type: .privacy)
        ]
    }
    func onAppear() {
        buildItems()
    }
}
