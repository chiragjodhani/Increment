//
//  ProgressCircleViewModel.swift
//  Increment
//
//  Created by Chirag's on 19/10/20.
//

import Foundation
import SwiftUI
struct ProgressCircleViewModel {
    let title : String
    let message: String
    let percentageComplete: Double
    var shouldShowTitle: Bool {
        percentageComplete <= 1
    }
}
