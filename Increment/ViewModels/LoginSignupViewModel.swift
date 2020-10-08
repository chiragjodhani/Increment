//
//  LoginSignupViewModel.swift
//  Increment
//
//  Created by Chirag's on 05/10/20.
//
import SwiftUI
import Combine
final class LoginSignupViewModel: ObservableObject {
    private let mode: Mode
    
    @Published var emailText = ""
    @Published var passwordText = ""
    private(set) var emailPlaceHolderText = "Email"
    private(set) var passwordPlaceHolderText = "Password"
    @Published var isValid = false
    @Binding var isPushed: Bool
    private var cancellables: [AnyCancellable] = []
    private let userService: UserServiceProtocol
    init(mode : Mode, userService: UserServiceProtocol = UserService(), isPushed: Binding<Bool>) {
        self.mode = mode
        self.userService = userService
        self._isPushed = isPushed
    }
    
    var title: String {
        switch mode {
        case .login:
            return "Welcome back!"
        case .signup:
            return "Create an account"
        }
    }
    
    var subTitle: String {
        switch mode {
        case .login:
            return "Log in with your email"
        case .signup:
            return "Sign up via email"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .login:
            return "Log in"
        case .signup:
            return "Sign up"
        }
    }
    
    func tappedActionButton() {
        switch mode {
        case .login:
            print("Login")
        case .signup:
            userService.linkAccount(email: emailText, password: passwordText).sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("Finished")
                    self?.isPushed = false
                }
            } receiveValue: {(_) in}
            .store(in: &cancellables)
        }
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
    }
}
