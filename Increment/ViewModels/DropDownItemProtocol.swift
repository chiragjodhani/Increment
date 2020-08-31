//
//  DropDownItemProtocol.swift
//  Increment
//
//  Created by Chirag's on 29/08/20.
//

import Foundation
protocol DropDownItemProtocol {
    var options: [DropdownOption] {
        get
    }
    var headerTitle: String {get}
    var dropdownTitle: String {get}
    var isSelected : Bool {get set}
}
protocol DropdownOptionProtocol {
    var toDropdownOption: DropdownOption {
        get
    }
}
struct DropdownOption {
    enum DropdownOptionType {
        case text(String)
        case number(Int)
    }
    let type : DropdownOptionType
    let formatted: String
    var isSelected: Bool
}
