//
//  ChallengeListViewModel.swift
//  Increment
//
//  Created by Chirag's on 14/09/20.
//

import SwiftUI
import Combine
final class ChallengeListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellable: [AnyCancellable] = []
    @Published private(set) var itemsViewModels: [ChallengeItemViewModel] = []
    @Published private(set) var error: IncrementError?
    @Published private(set) var isLoading = false
    let title = "Challenges"
    enum Action {
        case retry
    }
    
    init(userService: UserServiceProtocol = UserService(),
         challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
        observeChallenges()
    }
    func send(action: Action) {
        switch action {
        case .retry:
            observeChallenges()
        }
    }
    private func observeChallenges() {
        isLoading = true
        userService.currentUser().compactMap {
            $0?.uid
        }.flatMap { [weak self] userId -> AnyPublisher<[Challenge], IncrementError> in
            guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher()}
            return self.challengeService.observeChallenges(userId: userId)
        }.sink { [weak self] completion in
            guard let self = self else { return}
            self.isLoading = false
            switch completion  {
            case let .failure(error):
                self.error = error
            case .finished:
                print("Finished")
            }
        } receiveValue: { [weak self] challenges in
            guard let self = self else { return}
            self.isLoading = false
            self.error = nil
            self.itemsViewModels = challenges.map{.init($0)}
        }.store(in: &cancellable)
    }
    
    
}
