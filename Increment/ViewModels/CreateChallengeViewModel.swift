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
    @Published var dropdowns: [ChallengePartViewModel] = [
        .init(type: .exercise),
        .init(type: .startAmount),
        .init(type: .increase),
        .init(type: .length)
    ]
    enum Action  {
        case selectOption(index: Int)
        case createChallenge
    }
    private let userService: UserServiceProtocol
    private var cancellable: [AnyCancellable] = []
    
    var hasSelectedDropdown: Bool {
        selectedDropdownIndex != nil
    }
    var selectedDropdownIndex: Int? {
        dropdowns.enumerated().first(where:{ $0.element.isSelected
        })?.offset
    }
    var displayedOptions: [DropdownOption] {
        guard let selectedDropdownIndex = selectedDropdownIndex else {
            return []
        }
        return dropdowns[selectedDropdownIndex].options
    }
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func send(action: Action) {
        switch action {
        case let .selectOption(index) :
            guard let selectedDropdownIndex = selectedDropdownIndex else {return}
            clearSelectedOption()
            dropdowns[selectedDropdownIndex].options[index].isSelected = true
            clearSelectDropdown()
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
     
    func clearSelectedOption() {
        guard let selectedDropdownIndex = selectedDropdownIndex else {return}
        dropdowns[selectedDropdownIndex].options.indices.forEach { index in
            dropdowns[selectedDropdownIndex].options[index].isSelected = false
        }
    }
    
    func clearSelectDropdown() {
        guard let selectedDropdownIndex = selectedDropdownIndex else {return}
        dropdowns[selectedDropdownIndex].options.indices.forEach { index in
            dropdowns[selectedDropdownIndex].isSelected = false
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
        var options: [DropdownOption]
        
        var headerTitle: String {
            type.rawValue
        }
        
        var dropdownTitle: String {
            options.first(where: {$0.isSelected })?.formatted ?? ""
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
                .init(type: .text(rawValue), formatted: rawValue.capitalized, isSelected: self == .pullups)
            }
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue)", isSelected: self == .one)
            }
        }
        
        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "+\(rawValue)", isSelected: self == .one)
            }
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, fourteen = 14, twentyOne =  21, twentyEigth = 28
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue) days", isSelected: self == .seven)
            }
        }
    }
}
