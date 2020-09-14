//
//  QuerySnapshotPublisher.swift
//  Increment
//
//  Created by Chirag's on 14/09/20.
//

import Combine
import Firebase
extension Publishers {
    struct QuerySnapshotPublisher: Publisher {
        typealias Output = QuerySnapshot
        typealias Failure = IncrementError
        
        private let query:Query
        init(query: Query) {
            self.query = query
        }
        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let querySnapshotSubcription = QuerySnapshotSubcription(subscriber: subscriber, query:query)
            subscriber.receive(subscription: querySnapshotSubcription)
        }
    }
    
    class QuerySnapshotSubcription<S:Subscriber>:Subscription where S.Input == QuerySnapshot, S.Failure == IncrementError {
        private var subscriber: S?
        private var listener: ListenerRegistration?
        
        init(subscriber: S,query: Query) {
            listener = query.addSnapshotListener{ querySnapshot, error in
                if let error = error {
                    subscriber.receive(completion: .failure(.default(description: error.localizedDescription)))
                }else if let querysnapshot  = querySnapshot {
                    _ = subscriber.receive(querysnapshot)
                }else {
                    subscriber.receive(completion: .failure(.default()))
                }
            }
        }
        func request(_ demand: Subscribers.Demand) {}
        func cancel() {
            subscriber = nil
            listener = nil
        }
    }
}
