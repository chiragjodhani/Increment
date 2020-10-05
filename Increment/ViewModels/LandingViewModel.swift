//
//  LandingViewModel.swift
//  Increment
//
//  Created by Chirag's on 05/10/20.
//

import Foundation
import SwiftUI
final class LandingViewModel: ObservableObject {
    @Published var loginSignupPushed = false
    @Published var createPushed = false
    
    let title = "Increment"
    let createButtonTitle = "Create a challenge"
    let createButtonImageName = "plus.circle"
    let alreadyButtonTitle = "I already have an account"
    let backgroundImageName = "pullups"
}
