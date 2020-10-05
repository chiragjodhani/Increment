//
//  LoginSignupViewModel.swift
//  Increment
//
//  Created by Chirag's on 05/10/20.
//

import SwiftUI
final class LoginSignupViewModel: ObservableObject {
    private let mode: Mode
    
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    init(mode : Mode) {
        self.mode = mode
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
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
    }
}
