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
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    @Published var loginSignupPushed = false
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    func item(at index: Int) -> SettingsItemViewModel {
        itemViewModels[index]
    }
    
    func tappedItem(at index: Int) {
        switch itemViewModels[index].type {
        case .account:
            guard userService.currentUser?.email == nil  else {
                return
            }
            self.loginSignupPushed = true
        case .mode:
            self.isDarkMode = !self.isDarkMode
            buildItems()
        case .logout:
            self.userService.logout().sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("Finished")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

        default:
            break
        }
    }
    
    func buildItems(){
        itemViewModels = [
            .init(title: userService.currentUser?.email ?? "Create Account", iconName: "person.circle", type: .account),
            .init(title: "Switch to \(isDarkMode ? "Light" : "Dark") Mode", iconName: "lightbulb", type: .mode),
            .init(title: "Privacy Policy", iconName: "shield", type: .privacy)
        ]
        
        if userService.currentUser?.email != nil {
            itemViewModels += [.init(title: "Logout", iconName: "arrowshape.turn.up.left", type: .logout)]
        }
    }
    func onAppear() {
        buildItems()
    }
}
