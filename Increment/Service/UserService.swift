//
//  UserService.swift
//  Increment
//
//  Created by Chirag's on 31/08/20.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAuth
protocol UserServiceProtocol {
    func currentUser() -> AnyPublisher<User?, Never>
    func signInAnonymously() -> AnyPublisher<User, Error>
}

final class UserService: UserServiceProtocol {
    func currentUser() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
    
    func signInAnonymously() -> AnyPublisher<User, Error> {
        return Future<User, Error>  { promise in
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    return promise(.failure(error))
                }else if let user = result?.user {
                    return promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
}
