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
    var currentUser: User? { get }
    func currentUserPublisher() -> AnyPublisher<User?, Never>
    func signInAnonymously() -> AnyPublisher<User, IncrementError>
    func observeAuthChanges() -> AnyPublisher<User?, Never>
    
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, IncrementError>
    func logout() -> AnyPublisher<Void, IncrementError>
    func login(email: String, password: String) -> AnyPublisher<Void, IncrementError>
}

final class UserService: UserServiceProtocol {
    let currentUser = Auth.auth().currentUser
    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
    
    func signInAnonymously() -> AnyPublisher<User, IncrementError> {
        return Future<User, IncrementError>  { promise in
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                }else if let user = result?.user {
                    return promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func observeAuthChanges() -> AnyPublisher<User?, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }
    
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, IncrementError> {
        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        return Future<Void, IncrementError> { promise in
            Auth.auth().currentUser?.link(with: emailCredential){ result, error in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                }else if let user = result?.user {
                    Auth.auth().updateCurrentUser(user) { error in
                        if let error = error {
                            return promise(.failure(.default(description: error.localizedDescription)))
                        }else {
                            return promise(.success(()))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            }catch {
                promise(.failure(.default(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                }else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
