//
//  CreateChallengeViewModel.swift
//  Increment
//
//  Created by Chirag's on 29/08/20.
//

import SwiftUI
import Combine

typealias UserId = String
final class CreateChallengeViewModel: ObservableObject {
    @Published var exerciseDropDown = ChallengePartViewModel(type: .exercise)
    @Published var startAmountDropDown = ChallengePartViewModel(type: .startAmount)
    @Published var increaseDropDown = ChallengePartViewModel(type: .increase)
    @Published var lengthDropDown = ChallengePartViewModel(type: .length)
    @Published var error: IncrementError?
    @Published var isLoading = false
    
    enum Action  {
        case createChallenge
    }
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellable: [AnyCancellable] = []
    
    init(userService: UserServiceProtocol = UserService(), challengeService: ChallengeServiceProtocol  = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
    }
    
    func send(action: Action) {
        switch action {
        case .createChallenge:
            self.isLoading = true
            currentUserId().flatMap { userId -> AnyPublisher<Void, IncrementError> in
                return self.createChallenge(userId: userId)
            }.sink { completion in
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    print("Finished")
                }
            } receiveValue: { (_) in
                print("Success")
            }.store(in: &cancellable)
        }
    }
    
    private func createChallenge(userId: UserId) -> AnyPublisher<Void, IncrementError> {
        guard let exercise = exerciseDropDown.text, let startAmount = startAmountDropDown.number, let increase = increaseDropDown.number, let length = lengthDropDown.number else {
            return Fail(error: .default(description: "Parsing error")).eraseToAnyPublisher()
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        
        let challenge = Challenge(
            exercise: exercise,
            startAmount: startAmount,
            increase: increase,
            length: length,
            userId: userId,
            startDate: startDate,
            activities: (0..<length).compactMap { dayNum in
                if let dateForDayNum = Calendar.current.date(byAdding: .day, value: dayNum, to: startDate) {
                    return .init(date: dateForDayNum, isComplete: false)
                }else {
                    return nil
                }
            }
        )
        return challengeService.create(challenge).eraseToAnyPublisher()
    }
    
    private func currentUserId() -> AnyPublisher<UserId, IncrementError> {
        print("getting userid")
        return userService.currentUserPublisher().flatMap { user -> AnyPublisher<UserId, IncrementError> in
//            return Fail(error: .auth(description: "some firebase auth error")).eraseToAnyPublisher()
            if let userId = user?.uid {
                print("user is logged in......")
                return Just(userId).setFailureType(to: IncrementError.self).eraseToAnyPublisher()
            }else {
                print("user is logged in anonymously......")
               return self.userService.signInAnonymously().map {
                    $0.uid
                }.eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}

extension CreateChallengeViewModel {
    struct ChallengePartViewModel: DropDownItemProtocol {
        var selectedOption: DropdownOption
        
        var options: [DropdownOption]
        
        var headerTitle: String {
            type.rawValue
        }
        
        var dropdownTitle: String {
            selectedOption.formatted
        }
        
        var isSelected: Bool = false
    
        private let type: ChallengePartType
        
        init(type: ChallengePartType) {
            switch type {
            case .exercise:
                self.options = ExerciseOption.allCases.map{$0.toDropdownOption                }
            case .startAmount:
                self.options = StartOption.allCases.map{ $0.toDropdownOption}
            case .increase:
                self.options = IncreaseOption.allCases.map{ $0.toDropdownOption}
            case .length:
                self.options = LengthOption.allCases.map{ $0.toDropdownOption}
            }
            self.type = type
            self.selectedOption = options.first!
        }
        enum ChallengePartType: String, CaseIterable {
            case exercise = "Exercise"
            case startAmount = "Starting Amount"
            case increase = "Daily Increase"
            case length = "Challenge Length"
        }
        
        enum ExerciseOption: String, CaseIterable, DropdownOptionProtocol {
            case pullups
            case pushups
            case situps
            
            var toDropdownOption: DropdownOption {
                .init(type: .text(rawValue), formatted: rawValue.capitalized)
            }
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue)")
            }
        }
        
        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "+\(rawValue)")
            }
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, fourteen = 14, twentyOne =  21, twentyEigth = 28
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue) days")
            }
        }
    }
}

extension CreateChallengeViewModel.ChallengePartViewModel {
    var text: String? {
        if case let .text(text)  = selectedOption.type {
            return text
        }
        return nil
    }
    
    var number: Int? {
        if case let .number(number)  = selectedOption.type {
            return number
        }
        return nil
    }
}
