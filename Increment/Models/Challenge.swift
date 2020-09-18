//
//  Challenge.swift
//  Increment
//
//  Created by Chirag's on 31/08/20.
//

import Foundation
struct Challenge: Codable, Hashable {
    let exercise: String
    let startAmount: Int
    let increase: Int
    let length: Int
    let userId: String
    let startDate: Date
}
