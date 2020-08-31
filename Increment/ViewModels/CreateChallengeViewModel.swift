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
    enum Action  {
        case createChallenge
    }
    private let userService: UserServiceProtocol
    private var cancellable: [AnyCancellable] = []
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func send(action: Action) {
        switch action {
        case .createChallenge:
            currentUserId().sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("Completed")
                }
            } receiveValue: { (userId) in
                print("Received USerId:- \(userId)")
            }.store(in: &cancellable)
        }
    }
    
    private func currentUserId() -> AnyPublisher<UserId, Error> {
        print("getting userid")
        return userService.currentUser().flatMap { user -> AnyPublisher<UserId, Error> in
            if let userId = user?.uid {
                print("user is logged in......")
                return Just(userId).setFailureType(to: Error.self).eraseToAnyPublisher()
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
