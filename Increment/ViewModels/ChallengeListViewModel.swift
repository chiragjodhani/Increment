//
//  ChallengeListViewModel.swift
//  Increment
//
//  Created by Chirag's on 14/09/20.
//

import SwiftUI
final class ChallengeListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    init(userService: UserServiceProtocol = UserService(),
         challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
    }
}
